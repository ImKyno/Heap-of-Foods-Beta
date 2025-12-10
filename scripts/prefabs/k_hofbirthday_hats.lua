local function MakeHat(data)
	local assets = 
	{
		Asset("ANIM", "anim/"..data.build..".zip"),
	
		Asset("IMAGE", "images/inventoryimages/hof_inventoryimages.tex"),
		Asset("ATLAS", "images/inventoryimages/hof_inventoryimages.xml"),
		Asset("ATLAS_BUILD", "images/inventoryimages/hof_inventoryimages.xml", 256),
	}

	local function OnEquip(inst, owner, from_ground)
		owner.AnimState:OverrideSymbol("swap_hat", data.build, "swap_hat")
	
		owner.AnimState:Show("HAT")
		owner.AnimState:Show("HAIR_HAT")
		owner.AnimState:Show("HEAD_HAT")
	
		owner.AnimState:Hide("HAIR")
		owner.AnimState:Hide("HAIR_NOHAT")
		owner.AnimState:Hide("HEAD")
	end

	local function OnUnequip(inst, owner, from_ground)
		owner.AnimState:ClearOverrideSymbol("swap_hat")
	
		owner.AnimState:Hide("HAT")
		owner.AnimState:Hide("HAIR_HAT")
		owner.AnimState:Hide("HEAD_HAT")
	
		owner.AnimState:Show("HAIR")
		owner.AnimState:Show("HAIR_NOHAT")
		owner.AnimState:Show("HEAD")
	end

	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)

		inst.AnimState:SetBank(data.bank)
		inst.AnimState:SetBuild(data.build)
		inst.AnimState:PlayAnimation("anim")

		inst:AddTag("hat")
		inst:AddTag("waterproofer")
		inst:AddTag("anniversaryhat")
	
		inst.components.floater:SetSize("med")
		inst.components.floater:SetVerticalOffset(0.1)
		inst.components.floater:SetScale(0.6)

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("inspectable")
		inst:AddComponent("tradable")
		inst:AddComponent("snowmandecor")
	
		inst:AddComponent("waterproofer")
		inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)
	
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/hof_inventoryimages.xml"
		inst.components.inventoryitem.imagename = data.imagename
	
		inst:AddComponent("equippable")
		inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
		inst.components.equippable.dapperness = TUNING.DAPPERNESS_TINY
		inst.components.equippable:SetOnEquip(OnEquip)
		inst.components.equippable:SetOnUnequip(OnUnequip)

		MakeHauntableLaunch(inst)

		return inst
	end
	
	return Prefab(data.name, fn, assets, prefabs)
end

local hats =
{
	-- Sammy's Unique Anniversary Hat
	{
		name      = "kyno_hofbirthday_sammyhat",
		bank      = "hofbirthday_sammyhat",
		build     = "hat_hofbirthday_sammy",
		imagename = "kyno_hofbirthday_sammyhat",
		
	},
	
	-- We started doing the event on the 5th Anniversary, so its like the first.
	-- 5th Anniversary (Hat 1)
	{
		name      = "kyno_hofbirthday_5hat",
		bank      = "hofbirthday_5hat",
		build     = "hat_hofbirthday_5",
		imagename = "kyno_hofbirthday_5hat",
	},
}

local prefabs = {}

for i, v in ipairs(hats) do
	table.insert(prefabs, MakeHat(v))
end

return unpack(prefabs)