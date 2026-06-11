local _G            = GLOBAL
local require       = _G.require
local UpvalueHacker = require("tools/hof_upvaluehacker")

-- Harvesting Bee Box while friendly does not trigger bees.
if not TUNING.HOF_IS_TCP_ENABLED then
	local BEEBOXES =
	{
		"beebox",
		"beebox_hermit",
	}

	local function IsFriendlyBee(inst)
		return inst and inst:HasTag("player") and inst:HasTag("beefriendly")
	end

	local function FriendlyBee(inst, picker)
		if IsFriendlyBee(picker) then
			local friend = picker ~= nil and picker:HasTag("beefriendly")
			local bonus = TUNING.KYNO_BEEFRIENDLYBUFF_SANITY_BONUS

			if friend then
				if picker.components.sanity ~= nil then
					picker.components.sanity:DoDelta(bonus) -- Gain sanity for harvesting. Yay.
				end
			end
		else
			if not (picker ~= nil and picker.components.skilltreeupdater ~= nil 
			and picker.components.skilltreeupdater:IsActivated("wormwood_bugs")) then
				inst.components.childspawner:ReleaseAllChildren(picker)
			end
		end
	end

	local function BeeBoxPostInit(inst)
		local updatelevel = UpvalueHacker.GetUpvalue(_G.Prefabs.beebox.fn, "updatelevel")

		local function onharvest(inst, picker)
			if not inst:HasTag("burnt") then
				updatelevel(inst)

				if inst.components.childspawner ~= nil and not _G.TheWorld.state.iswinter then
					FriendlyBee(inst, picker)
				end
			end
		end

		if not _G.TheWorld.ismastersim then
			return inst
		end

		if inst.components.harvestable ~= nil then
			inst.components.harvestable:SetUp("honey", 6, nil, onharvest, updatelevel)
		end
	end

	for k, v in pairs(BEEBOXES) do
		AddPrefabPostInit(v, BeeBoxPostInit)
	end
end