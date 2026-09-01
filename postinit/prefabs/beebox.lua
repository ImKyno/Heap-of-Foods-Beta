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

	local function BeeBoxPostInit(inst)
		local updatelevel = UpvalueHacker.GetUpvalue(_G.Prefabs.beebox.fn, "updatelevel")

		if not _G.TheWorld.ismastersim then
			return inst
		end

		if inst.components.harvestable ~= nil then
			local _onharvestfn = inst.components.harvestable.onharvestfn

			inst.components.harvestable:SetOnHarvestFn(function(inst, picker, produce)
				if not inst:HasTag("burnt") then
					if picker ~= nil then
						if picker:HasTag("beefriendly") then
							if updatelevel ~= nil then
								updatelevel(inst)
							end

							-- Gain sanity for harvesting. Yay.
							if picker.components.sanity ~= nil then
								picker.components.sanity:DoDelta(TUNING.KYNO_BEEFRIENDLYBUFF_SANITY_BONUS)
							end
						else
							if _onharvestfn ~= nil then
								_onharvestfn(inst, picker, produce)
							end
						end
					end
				end
			end)
		end
	end

	for k, v in pairs(BEEBOXES) do
		AddPrefabPostInit(v, BeeBoxPostInit)
	end
end