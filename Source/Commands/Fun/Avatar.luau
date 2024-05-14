local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.DiscordPermissions.new()
	:addPermission(DiscordLuau.DiscordPermissions.Permissions.UseApplicationCommands)

local Avatar = SlashCommand.new(
	DiscordLuau.ApplicationCommand.new()
		:setName("get-avatar")
		:setDescription("Fetch the avatar of a user")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.ApplicationCommand.Context.Guild)
		:setType(DiscordLuau.ApplicationCommand.Type.ChatInput)
		:addOption(
			(DiscordLuau.ApplicationCommandOption.new() :: any)
				:setType(DiscordLuau.ApplicationCommandOption.Type.User)
				:setChannelTypes(DiscordLuau.ApplicationCommandOption.ChannelType.GuildVoice)
				:setDescription("The user you'd like the image of")
				:setName("target-user")
				:setRequired(true)
		)
)

function Avatar:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local userId = (interaction.data :: any).options["1"].value
	local member = interaction.guild:getMemberAsync(userId):await()
	local avatarHash = member.user.avatar

	local responseEmbed = DiscordLuau.DiscordEmbed.new()

	responseEmbed:setTitle(`{member.user.username}'s Avatar`)
	responseEmbed:setColor(0xffffff)
	responseEmbed:setImage({
		imageUrl = `https://cdn.discordapp.com/avatars/{userId}/{avatarHash}.webp?size=240`,
	})

	interaction:sendMessageAsync({
		embeds = { responseEmbed }
	})
end

return Avatar