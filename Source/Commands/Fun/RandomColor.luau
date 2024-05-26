local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.PermissionsBuilder.new()
	:addPermission(DiscordLuau.PermissionsBuilder.Permissions.UseApplicationCommands)

local RandomColor = SlashCommand.new(
	DiscordLuau.CommandBuilder.new()
		:setName("random-color")
		:setDescription("Fetch a random color!")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.CommandBuilder.Context.Guild)
		:setType(DiscordLuau.CommandBuilder.Type.ChatInput)
)

function RandomColor:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local hexColor = math.random(0x000000, 0xffffff)
	local responseEmbed = DiscordLuau.EmbedBuilder.new()
	local responseMessage = DiscordLuau.MessageBuilder.new()

	responseEmbed:setTitle(`A RandomColor`)
	responseEmbed:setDescription(`Your random color is: #{string.upper(hexColor)}`)
	responseEmbed:setColor(hexColor)

	responseMessage:addEmbed(responseEmbed)

	interaction:sendMessageAsync(responseMessage)
end

return RandomColor