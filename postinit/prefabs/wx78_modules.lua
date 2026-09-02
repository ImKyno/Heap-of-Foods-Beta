local _G = GLOBAL

-- LOL, a postinit of our own prefab because
-- it's being created through "hof_wx78moduledefs.lua" using Klei's constructor...
local function WX78ModuleBrewerPostInit(inst)
	local function OnSave(inst, data)
		if inst._brewer_savedata ~= nil then
			data.wxbrewer_savedata = inst._brewer_savedata
		end
	end

	local function OnLoad(inst, data, newents)
		if data ~= nil and data.wxbrewer_savedata ~= nil then
			inst._brewer_savedata = data.wxbrewer_savedata
		end
	end

	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
end

AddPrefabPostInit("wx78module_brewer", WX78ModuleBrewerPostInit)