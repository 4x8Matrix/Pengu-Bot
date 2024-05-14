local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.DiscordPermissions.new()
	:addPermission(DiscordLuau.DiscordPermissions.Permissions.UseApplicationCommands)

local Ping = SlashCommand.new(
	DiscordLuau.ApplicationCommand.new()
		:setName("ping")
		:setDescription("Simple Ping/Pong command, will this command ever get old?")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.ApplicationCommand.Context.Guild)
		:setType(DiscordLuau.ApplicationCommand.Type.ChatInput)
)

function Ping:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	interaction:sendMessageAsync({
		content = "Pong!"
	})
end

return Ping