chestfunctions = require("scenarios/chestfunctions")

local function OnCreate(inst, scenariorunner)
    local loot =
    {
        {
            item = "smallmeat",
            count = 1,
        },
        {
            item = "meat",
            count = 1,
        },
        {
            item = "monstermeat",
            count = 1,
        }
    }

    chestfunctions.AddChestItems(inst, loot)
end

return
{
    OnCreate = OnCreate,
}
