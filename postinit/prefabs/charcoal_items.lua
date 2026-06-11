local _G = GLOBAL

-- Items that can be turned to charcoal by Fire Packim Baggims.
local function CharcoalItemsPostInit(inst)
    inst:AddTag("charcoal_source")
end

for k, v in pairs(TUNING.KYNO_PACKIMBAGGIMS_CHARCOAL_ITEMS) do
    AddPrefabPostInit(v, CharcoalItemsPostInit)
end