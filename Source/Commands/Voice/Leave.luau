local DiscordLuau = require("../../../DiscordLuau")
local DiscordBot = require("../../DiscordBot")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.PermissionsBuilder.new()
	:addPermission(DiscordLuau.PermissionsBuilder.Permissions.UseApplicationCommands)

local Leave = SlashCommand.new(
	DiscordLuau.CommandBuilder.new()
		:setName("leave-voice-channel")
		:setDescription("Join your user Voice channel")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.CommandBuilder.Context.Guild)
		:setType(DiscordLuau.CommandBuilder.Type.ChatInput)
)

function Leave:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local responseEmbed = DiscordLuau.EmbedBuilder.new()
	local responseMessage = DiscordLuau.MessageBuilder.new()
	
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

	responseMessage:addEmbed(responseEmbed)

	interaction:sendMessageAsync(responseMessage)
end

return Leave