local DiscordLuau = require("../../../DiscordLuau")
local DiscordBot = require("../../DiscordBot")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.PermissionsBuilder.new()
	:addPermission(DiscordLuau.PermissionsBuilder.Permissions.UseApplicationCommands)

local Lifetime = SlashCommand.new(
	DiscordLuau.CommandBuilder.new()
		:setName("lifetime")
		:setDescription("Fetch the uptime/lifetime of this Discord Bot!")
		:setGuildPermissions(SlashCommandPermissions)
		:setType(DiscordLuau.CommandBuilder.Type.ChatInput)
		:addContext(DiscordLuau.CommandBuilder.Context.Guild)
		:addContext(DiscordLuau.CommandBuilder.Context.PrivateChannel)
		:addContext(DiscordLuau.CommandBuilder.Context.BotDM)
		:addIntegration(DiscordLuau.CommandBuilder.IntegrationType.GuildCommand)
		:addIntegration(DiscordLuau.CommandBuilder.IntegrationType.UserCommand)
)

function Lifetime:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local discordEmbed = DiscordLuau.EmbedBuilder.new()
	local responseMessage = DiscordLuau.MessageBuilder.new()

	local deltaTime = os.time() - DiscordBot.startTime

	local _seconds = deltaTime
	local minutes = (deltaTime - _seconds % 60) / 60
	local hours = (minutes - minutes % 60) / 60

	discordEmbed:setTitle("Bot Lifetime")
	discordEmbed:setColor(0xffffff)
	discordEmbed:setDescription(`Alive for; {string.format("%02i:%02i:%02i", hours, minutes - hours * 60, _seconds - minutes * 60)}!`)

	responseMessage:addEmbed(discordEmbed)

	interaction:sendMessageAsync(responseMessage)
end

return Lifetime