local _G = GLOBAL

-- Make Banana Bushes give our Bananas instead.
local function BananaBushPostInit(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    if inst.components.pickable ~= nil then
        inst.components.pickable:SetUp("kyno_banana")
    end
end

AddPrefabPostInit("bananabush", BananaBushPostInit)