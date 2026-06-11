local _G = GLOBAL

-- Purple Grouper can be caught on Swamp ponds.
local function PondMosPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.fishable ~= nil then
        inst.components.fishable:AddFish("kyno_grouper")
    end
end

AddPrefabPostInit("pond_mos", PondMosPostInit)