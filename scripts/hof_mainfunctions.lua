function ChangeFoodConfigs(config, value)
	local configs = KnownModIndex:LoadModConfigurationOptions("Heap-of-Foods-Workshop", false)
	-- local configs = KnownModIndex:LoadModConfigurationOptions("workshop-2334209327", false) -- Heap of Foods Workshop.
	if configs ~= nil then
		for i, v in ipairs(configs) do
			if v.name == config then
				v.saved = value
			end
		end
	end
	KnownModIndex:SaveConfigurationOptions(function() end, "Heap-of-Foods-Workshop", configs, false)
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