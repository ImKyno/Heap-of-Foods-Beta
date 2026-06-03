GLOBAL.setfenv(1, GLOBAL)

-- Adjectives for Vitality and Yield Boosters.
local _GetAdjectivedName = EntityScript.GetAdjectivedName
function EntityScript:GetAdjectivedName(...)
	return self:HasTag("plantboosted_vitality") and ConstructAdjectivedName(self, self:GetBasicDisplayName(), STRINGS.KYNO_PLANTBOOSTED_VITALITY)
	or self:HasTag("plantboosted_yield") and ConstructAdjectivedName(self, self:GetBasicDisplayName(), STRINGS.KYNO_PLANTBOOSTED_YIELD)
	or _GetAdjectivedName(self, ...)
end