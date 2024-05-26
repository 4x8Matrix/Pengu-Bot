local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.PermissionsBuilder.new()
	:addPermission(DiscordLuau.PermissionsBuilder.Permissions.UseApplicationCommands)

local Avatar = SlashCommand.new(
	DiscordLuau.CommandBuilder.new()
		:setName("get-avatar")
		:setDescription("Fetch the avatar of a user")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.CommandBuilder.Context.Guild)
		:setType(DiscordLuau.CommandBuilder.Type.ChatInput)
		:addOption(
			(DiscordLuau.CommandOptionBuilder.new() :: any)
				:setType(DiscordLuau.CommandOptionBuilder.Type.User)
				:setChannelTypes(DiscordLuau.CommandOptionBuilder.ChannelType.GuildVoice)
				:setDescription("The user you'd like the image of")
				:setName("target-user")
				:setRequired(true)
		)
)

function Avatar:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local userId = (interaction.data :: any).options["1"].value
	local member = interaction.guild:getMemberAsync(userId):await()
	local avatarHash = member.user.avatar

	local responseEmbed = DiscordLuau.EmbedBuilder.new()
	local responseMessage = DiscordLuau.MessageBuilder.new()

	responseEmbed:setTitle(`{member.user.username}'s Avatar`)
	responseEmbed:setColor(0xffffff)
	responseEmbed:setImage({
		imageUrl = `https://cdn.discordapp.com/avatars/{userId}/{avatarHash}.webp?size=240`,
	})

	responseMessage:addEmbed(responseEmbed)

	interaction:sendMessageAsync(responseMessage)
end

return Avatar