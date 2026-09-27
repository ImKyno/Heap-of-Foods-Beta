local _G = GLOBAL

local function CancelPossessedBrewing(inst)
	if inst.prefab ~= "wx78_possessedbody" then
		local container = inst._brewer_container

		if container == nil or not container:IsValid() then
			return
		end

		local brewer = container.components.wxbrewer

		if brewer ~= nil and (brewer:IsBrewing() or brewer:IsPaused()) then
			brewer:CancelBrewing()
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