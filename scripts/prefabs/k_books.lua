local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
local WEIGHTED_SEED_TABLE = require("prefabs/weed_defs").weighted_seed_table

require("prefabs/veggies")

local assets =
{
    Asset("ANIM", "anim/books.zip"),
	
	Asset("IMAGE", "images/inventoryimages1.tex"),
	Asset("ATLAS", "images/inventoryimages1.xml"),
}

local assets_fx =
{
    Asset("ANIM", "anim/fx_books.zip"),
}

local grow_sounds =
{
	grow_oversized = "farming/common/farm/grow_oversized",
	grow_full = "farming/common/farm/grow_full",
	grow_rot = "farming/common/farm/rot",
}

local GARDENING_CANT_TAGS = { "player", "stump", "withered", "barren", "INLIMBO", "FX" }
local GARDENING_ONEOF_TAGS = { "plant", "lichen", "oceanvine", "mushroom_farm", "kelp", "marbletree" }

local function PickFarmPlant()
	if math.random() < TUNING.FARM_PLANT_RANDOMSEED_WEED_CHANCE then
		return weighted_random_choice(WEIGHTED_SEED_TABLE)
	else
		local season = TheWorld.state.season
		local weights = {}
		local season_mod = TUNING.SEED_WEIGHT_SEASON_MOD

		for k, v in pairs(VEGGIES) do
			weights[k] = v.seed_weight * ((PLANT_DEFS[k] and PLANT_DEFS[k].good_seasons[season]) and season_mod or 1)
		end

		return "farm_plant_"..weighted_random_choice(weights)
	end
	
	return "weed_forgetmelots"
end

local function ReplaceWithPlant(inst)
	local plant_prefab = inst._identified_plant_type or PickFarmPlant()
	local plant = SpawnPrefab(plant_prefab)
	
	plant.Transform:SetPosition(inst.Transform:GetWorldPosition())

	if plant.plant_def ~= nil then
		plant.long_life = inst.long_life
		plant.components.farmsoildrinker:CopyFrom(inst.components.farmsoildrinker)
		plant.components.farmplantstress:CopyFrom(inst.components.farmplantstress)
		plant.components.growable:DoGrowth()
		plant.AnimState:OverrideSymbol("veggie_seed", "farm_soil", "seed")
	end

	inst.grew_into = plant
	inst:Remove()
end

local function MaximizePlant(inst)
	if inst.components.farmplantstress ~= nil then
		if inst.components.farmplanttendable then
			inst.components.farmplanttendable:TendTo()
		end

		local _x, _y, _z = inst.Transform:GetWorldPosition()
		local x, y = TheWorld.Map:GetTileCoordsAtPoint(_x, _y, _z)

		local nutrient_consumption = inst.plant_def.nutrient_consumption
		TheWorld.components.farming_manager:AddTileNutrients(x, y, nutrient_consumption[1] * 6, nutrient_consumption[2] * 6, nutrient_consumption[3] * 6)
	end
end

local function TryGrowth(inst, maximize)
	if not inst:IsValid()
		or inst:IsInLimbo()
		or (inst.components.witherable ~= nil and inst.components.witherable:IsWithered()) then

		return false
	end

	if inst.components.growable ~= nil then
		if inst.components.growable.magicgrowable or ((inst:HasTag("tree") or inst:HasTag("winter_tree")) and not inst:HasTag("stump")) then
			if inst.components.simplemagicgrower ~= nil then
				inst.components.simplemagicgrower:StartGrowing()
				return true
			elseif inst:HasTag("farm_plant") and inst:HasTag("weed") then
				-- Case for Weeds because they used different stages and such, ugh.
				if inst:IsAsleep() then
					return
				end
				
				local growable = inst.components.growable
				local weed_def = inst.weed_def or (inst.prefab and WEED_DEFS[inst.prefab])

				growable:DoGrowth()
				growable:DoGrowth()
				
				local fx = SpawnPrefab("farm_plant_happy")
				fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				
				if inst.SoundEmitter ~= nil then
					inst.SoundEmitter:PlaySound("farming/common/farm/grow_full")
				end

				return true
			elseif inst:HasTag("farm_plant") and inst.components.growable.domagicgrowthfn ~= nil and not inst:HasTag("weed") then
				-- Just check if its really a farm plant, but can't use magicgrowth because that prevents oversized crops.
				-- We could also check if its pickable and cancel.
				if inst:IsAsleep() or inst.components.growable:GetStage() >= 5 or inst.is_oversized then
					return
				end
				
				local growable = inst.components.growable
				local plant_def = inst.plant_def or (inst.prefab and PLANT_DEFS[inst.prefab])
				local current_season = TheWorld.state.season

				if plant_def and plant_def.is_randomseed then					
					ReplaceWithPlant(inst)
					
					inst = inst.grew_into
					growable = inst.components.growable
					growable.stage = 1
					
					plant_def = inst.plant_def or (inst.prefab and PLANT_DEFS[inst.prefab])
					
					if inst:HasTag("weed") then
						growable:SetStage(3)
					end
				end
				
				local max_stage = #growable.stages

				-- We still need to check for weeds because randomseed might spawn them.
				-- If a weed enter the loop it will cause stack overflow because they have cycling stages.
				if not inst:HasTag("weed") then
					while growable.stage < max_stage do
						local next_stage = growable.stage + 1
						local next_stage_data = growable.stages[next_stage]
					
						if next_stage_data == nil or next_stage_data.name == "rotten" then
							break
						end
					
						growable:DoGrowth()
					end
				end
				
				if plant_def and not plant_def.is_randomseed and not inst:HasTag("weed") then
					MaximizePlant(inst)
				end
				
				if plant_def ~= nil then
					local good_seasons = plant_def.good_seasons or {}
					
					if not inst:HasTag("weed") then
						if good_seasons[current_season] and math.random() < TUNING.KYNO_GROWTH_OVERSIZED_CHANCE then
							inst.is_oversized = true
						end
					else
						if math.random() < TUNING.KYNO_GROWTH_OVERSIZED_CHANCE then
							inst.is_oversized = true
						end
					end
				end
				
				local fx = SpawnPrefab("farm_plant_happy")
				fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				
				local anim = inst.is_oversized and "oversized" or "full"
				inst.AnimState:PlayAnimation("grow_"..anim, false)
				inst.AnimState:PushAnimation("crop_"..anim, true)

				if plant_def and plant_def.sounds and plant_def.sounds["grow_"..anim] then
					if inst.SoundEmitter ~= nil then
						inst.SoundEmitter:PlaySound(plant_def.sounds["grow_"..anim])
					end
				elseif grow_sounds["grow_"..anim] ~= nil and inst.SoundEmitter ~= nil then
					if inst.SoundEmitter ~= nil then
						inst.SoundEmitter:PlaySound(grow_sounds["grow_"..anim])
					end
				end

				return true
			else
				return inst.components.growable:DoGrowth()
			end
		end
	end
	
	if inst.components.growable ~= nil and ((inst:HasTag("tree") or inst:HasTag("winter_tree") or inst:HasTag("marbletree")) and not inst:HasTag("stump")) then
		local is_marble = inst:HasTag("marbletree")
		local is_hallowen = inst:HasTag("livingtree_halloween")
		local stage_name = nil
		
		if is_marble or is_hallowen then
			stage_name = inst.components.growable.stage
		else
			local stage_data = inst.components.growable:GetCurrentStageData()
			stage_name = stage_data and stage_data.name or nil
		end

		if (not is_marble and stage_name == "tall") or (is_marble and stage_name == 3) or (is_hallowen and stage_name == 2) then
			if inst:HasTag("ancienttree") and inst.components.pickable ~= nil then
				if inst.components.pickable:CanBePicked() and inst.components.pickable.caninteractwith then
					return false
				end
			end

			return false
		end

		inst.components.growable:DoGrowth()
	end
	
	-- Special case for this stupid tree using timer ahahahaha.
	-- I really should rewrite its code to use the proper growable system.
	if inst.components.timer ~= nil then
		if inst:HasTag("sugartree_growing") then
			local tall = SpawnPrefab("kyno_sugartree")
			tall.Transform:SetPosition(inst.Transform:GetWorldPosition())
			tall.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
			
			inst:Remove()
			
			return true
		end
	end

	if inst.components.pickable ~= nil then
		if inst.components.pickable:CanBePicked() and inst.components.pickable.caninteractwith then
			return false
		end
		
		if inst.components.pickable:FinishGrowing() then
			inst.components.pickable:ConsumeCycles(1)
			return true
		end
	end

	if inst.components.crop ~= nil then
		if inst.components.crop:IsReadyForHarvest() then
			return false
		end
		
		inst.components.crop:DoGrow(9999)
		return true
	end

	if inst.components.harvestable ~= nil and inst.components.harvestable:CanBeHarvested() and inst:HasTag("mushroom_farm") then
		if inst.components.harvestable:IsMagicGrowable() then
			inst.components.harvestable:DoMagicGrowth()
			return true
		else
			if inst.components.harvestable:Grow() then
				return true
			end
		end
	end

	return false
end

local function GardeningSpellFn()
	local inst = CreateEntity()

	if not TheWorld.ismastersim then
		inst:DoTaskInTime(0, inst.Remove)

		return inst
	end

	inst.entity:AddTransform()
	inst.entity:Hide()

	inst:AddTag("CLASSIFIED")

	return inst
end

local function DoGardeningSpell(x, z, max_targets, maximize)
    local ents = TheSim:FindEntities(x, 0, z, 30, nil, GARDENING_CANT_TAGS, GARDENING_ONEOF_TAGS)
    local grow_targets = {}

	for _, v in ipairs(ents) do
		local can_grow = false

		if v.components.growable ~= nil then
			local stage = v.components.growable:GetCurrentStageData()
			local stagename = stage ~= nil and stage.name or nil

			if v:HasTag("farm_plant") then
				if stagename ~= "full" and stagename ~= "rotten" then
					can_grow = true
				end
			elseif v:HasTag("marbletree") then
				if v.components.growable.stage < 3 then
					v.components.growable:DoGrowth()
					can_grow = true
				else
					can_grow = false
				end
			elseif v:HasTag("livingtree_halloween") then
				if v.components.growable.stage < 2 then
					v.components.growable:DoGrowth()
					can_grow = true
				else
					can_grow = false
				end
			elseif v:HasTag("tree") or v:HasTag("winter_tree") then
				if stagename == "old" then
					v.components.growable:DoGrowth()
					can_grow = true
				elseif stagename ~= "tall" and not v:HasTag("stump") then
					v.components.growable:DoGrowth()
					can_grow = true
				end
			else
				can_grow = true
			end
		elseif v.components.timer ~= nil then
			if v:HasTag("sugartree_growing") then
				can_grow = true
			else
				can_grow = true
			end
		elseif v.components.pickable ~= nil or v.components.crop ~= nil or v.components.harvestable ~= nil then
			can_grow = true
			
			if v.components.pickable ~= nil and v.components.pickable:CanBePicked() then
				can_grow = false
			end
			
			if v.components.crop ~= nil and v.components.crop:IsReadyForHarvest() then
				can_grow = false
			end
			
			if v.components.harvestable ~= nil and v.components.harvestable:CanBeHarvested() then
				can_grow = false
			end
		end

		if can_grow then
			table.insert(grow_targets, v)
		end
	end

	if #grow_targets == 0 then
		return false, "NOHORTICULTURE"
	end

	local spell = SpawnPrefab("kyno_book_gardening_spell")
	spell.Transform:SetPosition(x, 0, z)

	local target = table.remove(grow_targets, math.random(#grow_targets))
    
	TryGrowth(target)

	if #grow_targets > 0 then
		local timevar = 1 - 1 / (#grow_targets + 1)
		
		for _, v in ipairs(grow_targets) do
			v:DoTaskInTime(timevar * math.random(), TryGrowth)
		end
	end

	return true
end

local book_defs =
{
	{
		name = "kyno_book_gardening",
		uses = 2, -- Gonna use 2 because this book allows giant crops. TUNING.BOOK_USES_SMALL
		read_sanity = -TUNING.SANITY_HUGE,
		peruse_sanity = -TUNING.SANITY_HUGE,
		
		anim = "book_gardening",
		swap_prefix = "book_gardening",
		atlas = "images/inventoryimages1.xml",
		image = "book_gardening",
		
		nameoverride = "book_gardening",
		
		fx_under = "plants_big",
		layer_sound = { frame = 22, sound = "wickerbottom_rework/book_spells/upgraded_horticulture" },
		
		deps = { "kyno_book_gardening_spell" },	
		fn = function(inst, reader)
			local x, y, z = reader.Transform:GetWorldPosition()
			return DoGardeningSpell(x, z, nil, true)
		end,
		
		perusefn = function(inst,reader)
			if reader.peruse_gardening then
				reader.peruse_gardening(reader)
			end
			
			reader.components.talker:Say(GetString(reader, "ANNOUNCE_READ_BOOK", "BOOK_GARDENING"))
			return true
		end,
    },
}

local function MakeBook(def)
	local prefabs
	
	if def.deps ~= nil then
		prefabs = {}
		
		for i, v in ipairs(def.deps) do
			table.insert(prefabs, v)
		end
	end

	if def.fx ~= nil then
		prefabs = prefabs or {}
		table.insert(prefabs, def.fx)
	end
	
	if def.fxmount ~= nil then
		prefabs = prefabs or {}
		table.insert(prefabs, def.fxmount)
	end
	
	if def.fx_over ~= nil then
		prefabs = prefabs or {}
		local fx_over_prefab = "fx_kyno_"..def.fx_over.."_over_book"
		
		table.insert(prefabs, fx_over_prefab)
		table.insert(prefabs, fx_over_prefab.."_mount")
	end
	
	if def.fx_under ~= nil then
		prefabs = prefabs or {}
		local fx_under_prefab = "fx_kyno_"..def.fx_under.."_under_book"
		
		table.insert(prefabs, fx_under_prefab)
		table.insert(prefabs, fx_under_prefab.."_mount")
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst, "med", nil, 0.75)

		inst.AnimState:SetBank("books")
		inst.AnimState:SetBuild("books")
		inst.AnimState:PlayAnimation(def.anim)

		inst:AddTag("book")
		inst:AddTag("bookcabinet_item")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst.def = def
		inst.swap_build = "swap_books"
		inst.swap_prefix = def.swap_prefix

		inst:AddComponent("inspectable")
		inst.components.inspectable.nameoverride = def.nameoverride
		
		inst:AddComponent("book")
		inst.components.book:SetOnRead(def.fn)
		inst.components.book:SetOnPeruse(def.perusefn)
		inst.components.book:SetReadSanity(def.read_sanity)
		inst.components.book:SetPeruseSanity(def.peruse_sanity)
		inst.components.book:SetFx(def.fx, def.fxmount)

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = def.atlas
		inst.components.inventoryitem.imagename = def.image

		inst:AddComponent("finiteuses")
		inst.components.finiteuses:SetMaxUses(def.uses)
		inst.components.finiteuses:SetUses(def.uses)
		inst.components.finiteuses:SetOnFinished(inst.Remove)

		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = TUNING.MED_FUEL

		MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
		MakeSmallPropagator(inst)
		
		MakeHauntableLaunch(inst)

		return inst
	end

	return Prefab(def.name, fn, assets, prefabs)
end

local function MakeFX(name, anim, ismount)
	if ismount then
		name = name.."_mount"
		anim = anim.."_mount"
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddFollower()
		inst.entity:AddNetwork()

		inst:AddTag("FX")

		if ismount then
			inst.Transform:SetSixFaced()
		else
			inst.Transform:SetFourFaced()
		end

		inst.AnimState:SetBank("fx_books")
		inst.AnimState:SetBuild("fx_books")
		inst.AnimState:PlayAnimation(anim)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:ListenForEvent("animover", inst.Remove)
		inst.persists = false

		return inst
	end

	return Prefab(name, fn, assets_fx)
end

local ret = { Prefab("kyno_book_gardening_spell", GardeningSpellFn) }
for i, v in ipairs(book_defs) do
	table.insert(ret, MakeBook(v))
	
	if v.fx_over ~= nil then
		v.fx_over_prefab = "fx_kyno_"..v.fx_over.."_over_book"
		table.insert(ret, MakeFX(v.fx_over_prefab, v.fx_over, false))
		table.insert(ret, MakeFX(v.fx_over_prefab, v.fx_over, true))
	end
	
	if v.fx_under ~= nil then
		v.fx_under_prefab = "fx_kyno_"..v.fx_under.."_under_book"
		table.insert(ret, MakeFX(v.fx_under_prefab, v.fx_under, false))
		table.insert(ret, MakeFX(v.fx_under_prefab, v.fx_under, true))
	end
end

book_defs = nil
return unpack(ret)