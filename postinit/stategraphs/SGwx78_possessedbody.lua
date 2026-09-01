local _G = GLOBAL

local function CancelPossessedBrewing(inst)
	if inst.prefab ~= "wx78_possessedbody" then
		return
	end

	local brewer = inst._brewer_container
	local container = brewer ~= nil and brewer.components.wxbrewer

	if container ~= nil then
		if container:IsBrewing() or container:IsPaused() then
			container:CancelBrewing()
		end
	end
end

AddStategraphPostInit("wx78_possessedbody", function(sg)
	local death = sg.states["death"]

	if death ~= nil then
		local _onenter = death.onenter

		death.onenter = function(inst, ...)
			CancelPossessedBrewing(inst)

			if _onenter ~= nil then
				_onenter(inst, ...)
			end
		end
	end

	--[[
	local despawn = sg.states["despawn"]

	if despawn ~= nil then
		local _onenter = despawn.onenter

		despawn.onenter = function(inst, ...)
			CancelPossessedBrewing(inst)

			if _onenter ~= nil then
				_onenter(inst, ...)
			end
		end
	end
	]]--
end)