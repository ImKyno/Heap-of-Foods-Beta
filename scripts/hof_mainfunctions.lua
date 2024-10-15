function ChangeFoodConfigs(config, value)
	local configs = KnownModIndex:LoadModConfigurationOptions("workshop-2334209327", false)
	-- local configs = KnownModIndex:LoadModConfigurationOptions("workshop-2334209327", false) -- Heap of Foods Workshop.
	if configs ~= nil then
		for i, v in ipairs(configs) do
			if v.name == config then
				v.saved = value
			end
		end
	end
	KnownModIndex:SaveConfigurationOptions(function() end, "workshop-2334209327", configs, false)
	-- KnownModIndex:SaveConfigurationOptions(function() end, "workshop-2334209327", configs, false)
end

local function TogglePickable(pickable, isspring)
    if isspring then
        pickable:Pause()
    else
        pickable:Resume()
    end
end

function MakeNoGrowInSpring(inst)
    inst.components.pickable:WatchWorldState("isspring", TogglePickable)
    TogglePickable(inst.components.pickable, TheWorld.state.isspring)
end

function IsSerenityBiome(inst)
	if inst ~= nil and inst:IsValid() and TheWorld.Map:IsVisualGroundAtPoint(inst.Transform:GetWorldPosition()) then
		local node = TheWorld.Map:FindNodeAtPoint(inst.Transform:GetWorldPosition())
		return node and node.tags and table.contains(node.tags, "serenityarea")
	end
	
	return false
end

function IsSerenityBiomeAtPoint(x, y, z)
	if TheWorld.Map:IsVisualGroundAtPoint(x, y, z) then
		local node = TheWorld.Map:FindNodeAtPoint(x, y, z)
		return node and node.tags and table.contains(node.tags, "serenityarea")
	end
	
	return false
end