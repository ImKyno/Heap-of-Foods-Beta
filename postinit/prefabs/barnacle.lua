local _G = GLOBAL

local function BarnaclePostInit(inst)
    local function GetRoeKey(inst)
		return inst.prefab
	end

	local function roeresearchfn(inst)
		return inst:GetRoeKey()
	end

    inst:AddTag("roeresearchable")
    inst:AddTag("fishfarmable_product")

    inst.GetRoeKey = GetRoeKey

    if not _G.TheWorld.ismastersim then
		return inst
	end

    inst:AddComponent("roeresearchable")
	inst.components.roeresearchable:SetResearchFn(roeresearchfn)
end

AddPrefabPostInit("barnacle", BarnaclePostInit)