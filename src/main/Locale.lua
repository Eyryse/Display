local LocalizationService = game:GetService("LocalizationService");
local Players = game:GetService("Players");

--[[
	@class Locale
	@client
]]--
local CLASS_METHODS = {};
local CLASS_METATABLE = {__index = CLASS_METHODS};
local CLASS_CONSTRUCTORS = {};

function CLASS_METHODS:translate(key, arguments)
	local translation = "";
	
	local foundTranslation = pcall(function()
		translation = self._translator:FormatByKey(key, arguments);
	end);
	
	if (foundTranslation) then
		return translation;
	end
	return false;
end

local function new()
	local self = setmetatable({}, CLASS_METATABLE);
	
	local player = Players.LocalPlayer;
	
	local split = string.split(string.reverse(string.gsub(string.reverse(player.LocaleId), '-', '&', 1)), '&');
	
	self.languageCode = split[1];
	self.countryCode = split[2];
	
	local success = false;
	
	success, self._translator = pcall(function()
		return LocalizationService:GetTranslatorForLocaleAsync(self.languageCode);
	end)
	
	if (not success) then
		success, self._translator = pcall(function()
			return LocalizationService:GetTranslatorForLocaleAsync("en");
		end)
	end
	
	return self;
end

function CLASS_CONSTRUCTORS.of(context)
	return context.locale;
end

return setmetatable({}, {
	__index = CLASS_CONSTRUCTORS,
	__call = function(cls, ...)
		return new(...);
	end,
});