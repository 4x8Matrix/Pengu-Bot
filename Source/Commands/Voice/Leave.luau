local DiscordLuau = require("../../../DiscordLuau")
local DiscordBot = require("../../DiscordBot")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.DiscordPermissions.new()
	:addPermission(DiscordLuau.DiscordPermissions.Permissions.UseApplicationCommands)

local Leave = SlashCommand.new(
	DiscordLuau.ApplicationCommand.new()
		:setName("leave-voice-channel")
		:setDescription("Join your user Voice channel")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.ApplicationCommand.Context.Guild)
		:setType(DiscordLuau.ApplicationCommand.Type.ChatInput)
)

function Leave:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local responseEmbed = DiscordLuau.DiscordEmbed.new()
	
	if DiscordBot.connectedVoiceChannel then
		responseEmbed:setTitle(`Left the '<#{DiscordBot.connectedVoiceChannel.id}>' Voice Channel!`)
		responseEmbed:setFooter({ text = "Whoop whoop!" })
		responseEmbed:setColor(0xffffff)

		DiscordBot.connectedVoiceChannel:disconnectAsync():await()
	else
		responseEmbed:setTitle(`Error!`)
		responseEmbed:setDescription("Not currently in a Voice Channel...")
		responseEmbed:setColor(0xff0000)
	end

	interaction:sendMessageAsync({
		embeds = { responseEmbed }
	})
end

return Leave