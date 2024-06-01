local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.PermissionsBuilder.new()
	:addPermission(DiscordLuau.PermissionsBuilder.Permissions.UseApplicationCommands)

local Ping = SlashCommand.new(
	DiscordLuau.CommandBuilder.new()
		:setName("ping")
		:setDescription("Simple Ping/Pong command, will this command ever get old?")
		:setGuildPermissions(SlashCommandPermissions)
		:setType(DiscordLuau.CommandBuilder.Type.ChatInput)
		:addContext(DiscordLuau.CommandBuilder.Context.Guild)
		:addContext(DiscordLuau.CommandBuilder.Context.PrivateChannel)
		:addContext(DiscordLuau.CommandBuilder.Context.BotDM)
		:addIntegration(DiscordLuau.CommandBuilder.IntegrationType.GuildCommand)
		:addIntegration(DiscordLuau.CommandBuilder.IntegrationType.UserCommand)
)

function Ping:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	interaction:sendMessageAsync(
		DiscordLuau.MessageBuilder.new():setContent("Pong!")
	)
end

return Ping