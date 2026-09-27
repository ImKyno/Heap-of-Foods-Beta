local _G          = GLOBAL
local require     = _G.require
local SpawnPrefab = _G.SpawnPrefab

require("stategraphs/commonstates")

local SPECIAL_ITEM_PREFAB = "monkeyislandmeal"
local SPECIAL_REMOVE_CURSE_AMOUNT = 999
local SPECIAL_RIGHT_OF_PASSAGE_TIME = TUNING.TOTAL_DAY_TIME * 1.5

AddStategraphPostInit("monkeyqueen", function(sg)
    local getitem = sg.states["getitem"]

    if getitem ~= nil and getitem.onenter ~= nil then
        local _getitem_onenter = getitem.onenter

        getitem.onenter = function(inst, data)
            inst._special_monkey_bribe = data ~= nil and data.item ~= nil and data.item.prefab == SPECIAL_ITEM_PREFAB or false
            _getitem_onenter(inst, data)
        end
    end

    local removecurse = sg.states["removecurse"]
    local _removecurse = removecurse.events.animover.fn

    removecurse.events.animover.fn = function(inst)
        if not inst._special_monkey_bribe then
            return _removecurse(inst)
        end

        local curseprop = _G.SpawnPrefab("cursed_monkey_token_prop")

        curseprop:RemoveComponent("inventoryitem")
        curseprop:RemoveComponent("curseditem")

        local giver = inst.sg.statemem.giver

        if giver ~= nil and giver:IsValid() then
            curseprop.Transform:SetPosition(giver.Transform:GetWorldPosition())

            if giver.components.inventory ~= nil then
                if giver.components.cursable ~= nil then
                    giver.components.cursable:RemoveCurse("MONKEY", SPECIAL_REMOVE_CURSE_AMOUNT)
                end

                local curses = giver.components.inventory:FindItems(function(thing)
                    return thing:HasTag("monkey_token")
                end)

                if #curses >= 0 then
                    inst.right_of_passage = true

                    if inst.components.timer:TimerExists("right_of_passage") then
                        inst.components.timer:SetTimeLeft("right_of_passage", SPECIAL_RIGHT_OF_PASSAGE_TIME)
                    else
                        inst.components.timer:StartTimer("right_of_passage", SPECIAL_RIGHT_OF_PASSAGE_TIME)
                    end
                end
            end
        else
            curseprop.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end

        curseprop.target = inst

        inst.sg:GoToState("removecurse_channel")

        inst._special_monkey_bribe = false
    end
end)