local _G                        = GLOBAL
local POSSESSED_BREWER_TRANSFER = TUNING.KYNO_WX78_MODULES_BREWER_TRANSFER

local function WX78PossessedBodyPostInit(inst)

	if not _G.TheWorld.ismastersim then
		return inst
	end

	-- WX-78 Cannot die from excessive gambling!
	inst.tagvar_gambling_addicted = true

	local _OnSave = inst.OnSave

	inst.OnSave = function(inst, data, ...)
		if _OnSave ~= nil then
			_OnSave(inst, data, ...)
		end

		local container = inst._brewer_container

		if container ~= nil and container.components.wxbrewer ~= nil then
			local brewer = container.components.wxbrewer
			data.wxbrewer = brewer:OnSave()
		end

		return data
	end

	local _OnLoad = inst.OnLoad

	inst.OnLoad = function(inst, data, newents, ...)
		if _OnLoad ~= nil then
			_OnLoad(inst, data, newents, ...)
		end

		if data == nil or data.wxbrewer == nil then
			return
		end

		local container = inst._brewer_container

		if container ~= nil and container.components.wxbrewer ~= nil then
			container.components.wxbrewer:OnLoadData(data.wxbrewer)
		else
			local key = _G.GetBrewerModuleTransferKey(inst)

			if key ~= nil then
				POSSESSED_BREWER_TRANSFER[key] = data.wxbrewer
			end
		end
	end
end

AddPrefabPostInit("wx78_possessedbody", WX78PossessedBodyPostInit)