-- Common Dependencies.
local _G          = GLOBAL
local require     = _G.require
local SpawnPrefab = _G.SpawnPrefab
local Pollinator  = require("components/pollinator")

require("hof_mainfunctions")

-- Butterflies landing on Sugar Flowers inside Serenity Archipelago will be replaced with Sugarflies.
local OldPollinate = Pollinator.Pollinate
function Pollinator:Pollinate(flower, ...)
	if self.inst.prefab == "butterfly" and self.inst:GetTimeAlive() < 1 then
		if flower.prefab == "kyno_sugartree_flower" then
			-- if IsSerenityBiome(flower) then
				local x, y, z = flower.Transform:GetWorldPosition()
				local sugarfly = SpawnPrefab("kyno_sugarfly")
					
				sugarfly.Transform:SetPosition(x, y, z)
				if sugarfly.components.pollinator then
					sugarfly.components.pollinator:Pollinate(flower)
				end
				
				self.inst:Hide()
				self.inst:DoTaskInTime(0, self.inst.Remove)
				
				print("FUCK YOU")
			-- end
		end
	end
		
	return OldPollinate(self, flower, ...)
end

-- Pollinators will also target Sugar Flowers as well.	
local OldCanPollinate = Pollinator.CanPollinate
function Pollinator:CanPollinate(flower, ...)
	local FLOWER_TAGS = {"flower", "sugarflower"}

	if self.inst:HasTag("sugarflowerpollinator") then
		return flower ~= nil and flower:HasOneOfTags(FLOWER_TAGS) and not table.contains(self.flowers, flower)
	else
		return OldCanPollinate(self, flower, ...)
	end
end