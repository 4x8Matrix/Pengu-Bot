local DiscordLuau = require("../../../DiscordLuau")
local DiscordBot = require("../../DiscordBot")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.DiscordPermissions.new()
	:addPermission(DiscordLuau.DiscordPermissions.Permissions.UseApplicationCommands)

local Lifetime = SlashCommand.new(
	DiscordLuau.ApplicationCommand.new()
		:setName("lifetime")
		:setDescription("Fetch the uptime/lifetime of this Discord Bot!")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.ApplicationCommand.Context.Guild)
		:setType(DiscordLuau.ApplicationCommand.Type.ChatInput)
)

function Lifetime:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local discordEmbed = DiscordLuau.DiscordEmbed.new()

	local deltaTime = os.time() - DiscordBot.startTime

	local _seconds = deltaTime
	local minutes = (deltaTime - _seconds % 60) / 60
	local hours = (minutes - minutes % 60) / 60

	discordEmbed:setTitle("Bot Lifetime")
	discordEmbed:setColor(0xffffff)
	discordEmbed:setDescription(`Alive for; {string.format("%02i:%02i:%02i", hours, minutes - hours * 60, _seconds - minutes * 60)}!`)

	interaction:sendMessageAsync({
		embeds = { discordEmbed }
	})
end

return Lifetime