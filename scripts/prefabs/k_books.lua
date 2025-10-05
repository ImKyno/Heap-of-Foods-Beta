local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS

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
local GARDENING_ONEOF_TAGS = { "plant", "lichen", "oceanvine", "mushroom_farm", "kelp" }

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
			elseif inst:HasTag("farm_plant") and inst.components.growable.domagicgrowthfn ~= nil then
				-- Just check if its really a farm plant, but can't use magicgrowth because that prevents oversized crops.
				-- We could also check if its pickable and cancel.
				if inst:IsAsleep() or inst.components.growable:GetStage() >= 5 or inst.is_oversized then
					return
				end
				
				local grow_loops = 4
            
				for i = 1, grow_loops do
					inst.components.growable:DoGrowth()
				end
				
				MaximizePlant(inst)
				
				if math.random() < TUNING.KYNO_GROWTH_OVERSIZED_CHANCE then
					inst.is_oversized = true
				end
				
				local fx = SpawnPrefab("farm_plant_happy")
				fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
				
				-- Play animation and sounds because this skips all growing stages.
				local anim = inst.is_oversized and "oversized" or "full"
				inst.AnimState:PlayAnimation("grow_"..anim, false)
				inst.AnimState:PushAnimation("crop_"..anim, true)
				
				local plant_def = inst.plant_def or (inst.prefab and PLANT_DEFS[inst.prefab])
				
				if plant_def and plant_def.sounds and plant_def.sounds["grow_"..anim] then
					inst.SoundEmitter:PlaySound(plant_def.sounds["grow_"..anim])
				else
					local sound = grow_sounds["grow_"..anim]

					if sound ~= nil and inst.SoundEmitter ~= nil then
						inst.SoundEmitter:PlaySound(sound)
					end
				end

				return true
			else
				return inst.components.growable:DoGrowth()
			end
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

	if inst.components.crop ~= nil and (inst.components.crop.rate or 0) > 0 then
		if inst.components.crop:DoGrow(1 / inst.components.crop.rate, true) then
			return true
		end
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
	local targets = {}
	
	for i, v in ipairs(ents) do
		if v.components.pickable ~= nil or v.components.crop ~= nil or v.components.growable ~= nil or v.components.harvestable ~= nil then
			table.insert(targets, v)
		end
	end

	if #targets == 0 then
		return false, "NOHORTICULTURE"
	end
	
	local ready_for_harvest = false
	
	for _, v in ipairs(targets) do
		if (v.components.pickable ~= nil and v.components.pickable:CanBePicked()) or (v.components.crop ~= nil 
		and v.components.crop:IsReadyForHarvest()) or (v.components.harvestable ~= nil and v.components.harvestable:CanBeHarvested()) then
			ready_for_harvest = true
			break
		end
	end

	if ready_for_harvest then
		return false, "NOHORTICULTURE"
	end

	local spell = SpawnPrefab("kyno_book_gardening_spell")
	spell.Transform:SetPosition(x, 0, z)
			
	if #ents > 0 then
		TryGrowth(table.remove(ents, math.random(#ents)))
				
		if #ents > 0 then
			local timevar = 1 - 1 / (#ents + 1)
					
			for i, v in ipairs(ents) do
				v:DoTaskInTime(timevar * math.random(), TryGrowth)
			end
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