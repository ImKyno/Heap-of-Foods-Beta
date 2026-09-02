local _G                    = GLOBAL
local WX78_BREWER_TRANSFER  = TUNING.KYNO_WX78_MODULES_BREWER_TRANSFER

local function WX78BackupBodyPostInit(inst)
	inst._brewer_container_net = net_entity(inst.GUID, "wx78._brewer_container")

	if not _G.TheWorld.ismastersim then
		return inst
	end

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
			local key = _G.GetWX78TransferKey(inst)

			if key ~= nil then
				WX78_BREWER_TRANSFER[key] = data.wxbrewer
			end
		end
	end
end

AddPrefabPostInit("wx78_backupbody", WX78BackupBodyPostInit)