local Task = require("@lune/task")

local DiscordLuau = require("../../DiscordLuau")
local DiscordBot = require("../DiscordBot")

local SlashCommand = {}

SlashCommand.Prototype = {}
SlashCommand.Interface = {}

function SlashCommand.Prototype.invokeLifecycle(self: SlashCommand, lifecycleName: string, ...)
	if (self :: {})[lifecycleName] then
		Task.spawn((self :: {})[lifecycleName], self, ...)
	end
end

function SlashCommand.Prototype.destroy(self: SlashCommand, lifecycleName: string, ...)
	self:invokeLifecycle("onStop")

	self._connection:disconnect()
	self._connection = nil
end

function SlashCommand.Interface.new(applicationCommand)
	local self = setmetatable({
		command = applicationCommand
	}, {
		__index = SlashCommand.Prototype
	})

	self._connection = DiscordBot.discordClient:on("Interaction", function(interaction: DiscordLuau.DiscordInteraction)
		if interaction.data.name ~= self.command.commandName then
			return
		end

		self:invokeLifecycle("onInvoked", interaction)
	end)

	self:invokeLifecycle("onStart")

	return self
end

export type SlashCommand = typeof(SlashCommand.Prototype) & {
	command: any
}

return SlashCommand.Interface