local assets =
{
	Asset("ANIM", "anim/swap_foodsack.zip"),
	Asset("ANIM", "anim/deer_ice_flakes.zip"),
	Asset("ANIM", "anim/ui_piggyback_2x6.zip"),

	Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),

	Asset("IMAGE", "images/minimapimages/hof_minimapimages.tex"),
	Asset("ATLAS", "images/minimapimages/hof_minimapimages.xml"),
}

local prefabs =
{
	"saltrock",
	"kyno_foodsack_fx",
}

local function UpdateFoodCount(inst)
	if inst.components.container == nil then
		inst._foodcount = 0
		return
	end

	local count = 0

	for _, item in pairs(inst.components.container.slots) do
		if item ~= nil then
			local isfood = item:HasTag("foodsack_valid")

			if not isfood then
				for _, v in pairs(FOODGROUP.OMNI.types) do
					if item:HasTag("edible_" .. v) and item.components.perishable then
						isfood = true
						break
					end
				end
			end

			if isfood then
				if item.components.stackable ~= nil then
					count = count + item.components.stackable:StackSize()
				else
					count = count + 1
				end
			end
		end
	end

	inst._foodcount = count
end

local function GetSaltAmount(inst)
	local foodcount = inst._foodcount or 0
	return math.floor((foodcount - 1) / 10) + 1
end

local function HasIngredients(inst)
	if inst.components.container ~= nil then
		for _, item in pairs(inst.components.container.slots) do
			if item ~= nil then
				local isingredient = item:HasTag("foodsack_valid")

				if not isingredient then
					for _, v in pairs(FOODGROUP.OMNI.types) do
						if item:HasTag("edible_" .. v) and item.components.perishable then
							isingredient = true
							break
						end
					end
				end

				if isingredient then
					return true
				end
			end
		end

		return false
	end
end

local function IsValidSaltState(inst, owner)
	if owner == nil or not owner:HasTag("player") then
		return false
	end

	if inst.components.equippable ~= nil and not inst.components.equippable:IsEquipped() then
		return false
	end

	return HasIngredients(inst)
end

local function SpawnSalt(inst, owner)
	if owner ~= nil then

		local amount = GetSaltAmount(inst)

    	if amount <= 0 then
			return
		end

		local first_salt = SpawnPrefab("saltrock")
		local max_stack = 1

		if first_salt.components.stackable ~= nil then
			max_stack = first_salt.components.stackable.maxsize or 1
		end

		local pt = Vector3(inst.Transform:GetWorldPosition())

		while amount > 0 do
			local salt = first_salt
			first_salt = nil

			if salt == nil then
				salt = SpawnPrefab("saltrock")
			end

			local stack = math.min(amount, max_stack)
			amount = amount - stack

			if salt.components.stackable ~= nil then
				salt.components.stackable:SetStackSize(stack)
			end

			salt.Transform:SetPosition(pt:Get())

			local angle = owner.Transform:GetRotation() * (PI / 180)
			local sp = (math.random() + 1) * -1

			salt.Physics:SetVel(sp * math.cos(angle), math.random() * 2 + 8, -sp * math.sin(angle))
		end
	end
end

local function StartSaltTask(inst, owner)
	if inst.salt_task == nil then
		inst.salt_task = inst:DoPeriodicTask(TUNING.KYNO_FOODSACK_SALT_PERIOD, function()
			SpawnSalt(inst, owner)
		end)
	end
end

local function StopSaltTask(inst)
	if inst.salt_task ~= nil then
		inst.salt_task:Cancel()
		inst.salt_task = nil
	end
end

local function UpdateSaltState(inst, owner)
	if IsValidSaltState(inst, owner) then
		StartSaltTask(inst, owner)
	else
		StopSaltTask(inst)
	end
end

local function OnEquip(inst, owner)
	if owner ~= nil then
		owner.AnimState:OverrideSymbol("swap_body", "swap_foodsack", "backpack")
		owner.AnimState:OverrideSymbol("swap_body", "swap_foodsack", "swap_body")

		if inst.components.container ~= nil then
			inst.components.container:Open(owner)
		end

		UpdateSaltState(inst, owner)
	end
end

local function OnUnequip(inst, owner)
	if owner ~= nil then
		owner.AnimState:ClearOverrideSymbol("swap_body")
		owner.AnimState:ClearOverrideSymbol("backpack")

		if inst.components.container ~= nil then
			inst.components.container:Close(owner)
		end

		StopSaltTask(inst)
	end
end

local function OnEquipToModel(inst, owner)
	if owner ~= nil then
		if inst.components.container ~= nil then
			inst.components.container:Close(owner)
		end

		StopSaltTask(inst)
	end
end

local function OnPreEquipVanity(inst, owner, from_ground)
	inst.components.inventoryitem.__cangoincontainer = inst.components.inventoryitem.cangoincontainer
	inst.components.inventoryitem.cangoincontainer = true
end

local function OnEquipVanity(inst, owner, from_ground)
	inst:AddTag("vanity_equipped")

	if owner ~= nil then
		if inst.components.preserver ~= nil then
			inst.components.preserver:SetPerishRateMultiplier(1)
		end

		StopSaltTask(inst)
	end
end

local function OnUnequipVanity(inst, owner)
	if owner ~= nil then
		if inst.components.preserver ~= nil then
			inst.components.preserver:SetPerishRateMultiplier(TUNING.KYNO_FOODSACK_PERISH_MULT)
		end

		if inst.components.equippable ~= nil then
			inst.components.equippable:Unequip(owner)
		end
	end

	inst:RemoveTag("vanity_equipped")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("kyno_foodsack.tex")

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.15)

	inst.AnimState:SetBank("kyno_foodsack")
	inst.AnimState:SetBuild("swap_foodsack")
	inst.AnimState:PlayAnimation("anim")

	inst:AddTag("backpack")
	inst:AddTag("fridge")
	inst:AddTag("nocool")
	inst:AddTag("waterproofer")

	inst.foleysound = "dontstarve/movement/foley/marblearmour"

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst)
			inst.replica.container:WidgetSetup("foodsack")
		end
		return inst
	end

	inst._foodcount = 0

	inst.onpreequipvanity = OnPreEquipVanity
	inst.onequipvanity = OnEquipVanity
	inst.onunequipvanity = OnUnequipVanity

	inst:AddComponent("inspectable")

	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(0)

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(TUNING.KYNO_FOODSACK_PERISH_MULT)

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_foodsack"
	inst.components.inventoryitem.cangoincontainer = false

	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable:SetOnEquipToModel(OnEquipToModel)

	inst:AddComponent("insulator")
	inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)
	inst.components.insulator:SetSummer()

	inst:AddComponent("container")
	inst.components.container:WidgetSetup("foodsack")

	inst:ListenForEvent("itemget", function()
		local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
		UpdateFoodCount(inst)
		UpdateSaltState(inst, owner)
	end)

	inst:ListenForEvent("itemlose", function()
		local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
		UpdateFoodCount(inst)
		UpdateSaltState(inst, owner)
	end)

	MakeHauntableLaunchAndDropFirstItem(inst)

	return inst
end

local function fxfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetScale(.25, .25, .25)

	inst.AnimState:SetBank("deer_ice_flakes")
	inst.AnimState:SetBuild("deer_ice_flakes")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:SetFinalOffset(0)

	inst:AddTag("FX")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	return inst
end

return Prefab("kyno_foodsack", fn, assets, prefabs),
Prefab("kyno_foodsack_fx", fxfn, assets, prefabs)