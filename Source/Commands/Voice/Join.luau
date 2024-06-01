local DiscordLuau = require("../../../DiscordLuau")
local DiscordBot = require("../../DiscordBot")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.PermissionsBuilder.new()
	:addPermission(DiscordLuau.PermissionsBuilder.Permissions.UseApplicationCommands)

local Join = SlashCommand.new(
	DiscordLuau.CommandBuilder.new()
		:setName("join-voice-channel")
		:setDescription("Join your user Voice channel")
		:setGuildPermissions(SlashCommandPermissions)
		:setType(DiscordLuau.CommandBuilder.Type.ChatInput)
		:addContext(DiscordLuau.CommandBuilder.Context.Guild)
		:addContext(DiscordLuau.CommandBuilder.Context.PrivateChannel)
		:addContext(DiscordLuau.CommandBuilder.Context.BotDM)
		:addIntegration(DiscordLuau.CommandBuilder.IntegrationType.GuildCommand)
		:addIntegration(DiscordLuau.CommandBuilder.IntegrationType.UserCommand)
		:addOption(
			(DiscordLuau.CommandOptionBuilder.new() :: any)
				:setType(DiscordLuau.CommandOptionBuilder.Type.Channel)
				:setChannelTypes(DiscordLuau.CommandOptionBuilder.ChannelType.GuildVoice)
				:setDescription("The voice channel the bot should join")
				:setName("voice-channel")
				:setRequired(true)
		)
)

function Join:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local voiceChannel = DiscordBot.discordClient:fetchChannelAsync((interaction.data :: any).options["1"].value):await()

	local responseEmbed = DiscordLuau.EmbedBuilder.new()
	local responseMessage = DiscordLuau.MessageBuilder.new()

	responseEmbed:setTitle(`Joined the '<#{voiceChannel.id}>' Voice Channel!`)
	responseEmbed:setFooter({ text = "Whoop whoop!" })
	responseEmbed:setColor(0xffffff)

	voiceChannel:connectAsync():await()

	DiscordBot.connectedVoiceChannel = voiceChannel

	responseMessage:addEmbed(responseEmbed)

	interaction:sendMessageAsync(responseMessage)
end

return Join