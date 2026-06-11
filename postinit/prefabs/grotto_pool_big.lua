local _G = GLOBAL

-- Add Chilled Swordfish to Vitreoasis.
local function GrottoPoolBigPostInit(inst)
	inst:AddTag("pond")

	local function GetFish(inst)
		return _G.TheWorld.state.iswinter and "kyno_swordfish_blue" or "pondfish" -- Can't be nil.
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("fishable")
	inst.components.fishable:SetGetFishFn(GetFish)
	inst.components.fishable.maxfish = TUNING.KYNO_GROTTO_POOL_MAX_FISH
	inst.components.fishable:SetRespawnTime(TUNING.KYNO_SWORDFISH_BLUE_REGROW_TIME)
end

AddPrefabPostInit("grotto_pool_big", GrottoPoolBigPostInit)