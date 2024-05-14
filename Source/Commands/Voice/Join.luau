local DiscordLuau = require("../../../DiscordLuau")
local DiscordBot = require("../../DiscordBot")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.DiscordPermissions.new()
	:addPermission(DiscordLuau.DiscordPermissions.Permissions.UseApplicationCommands)

local Join = SlashCommand.new(
	DiscordLuau.ApplicationCommand.new()
		:setName("join-voice-channel")
		:setDescription("Join your user Voice channel")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.ApplicationCommand.Context.Guild)
		:setType(DiscordLuau.ApplicationCommand.Type.ChatInput)
		:addOption(
			(DiscordLuau.ApplicationCommandOption.new() :: any)
				:setType(DiscordLuau.ApplicationCommandOption.Type.Channel)
				:setChannelTypes(DiscordLuau.ApplicationCommandOption.ChannelType.GuildVoice)
				:setDescription("The voice channel the bot should join")
				:setName("voice-channel")
				:setRequired(true)
		)
)

function Join:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local voiceChannel = DiscordBot.discordClient:fetchChannelAsync((interaction.data :: any).options["1"].value):await()

	local responseEmbed = DiscordLuau.DiscordEmbed.new()

	responseEmbed:setTitle(`Joined the '<#{voiceChannel.id}>' Voice Channel!`)
	responseEmbed:setFooter({ text = "Whoop whoop!" })
	responseEmbed:setColor(0xffffff)

	voiceChannel:connectAsync():await()

	DiscordBot.connectedVoiceChannel = voiceChannel

	interaction:sendMessageAsync({
		embeds = { responseEmbed }
	})
end

return Join