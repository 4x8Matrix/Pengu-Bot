local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.DiscordPermissions.new()
	:addPermission(DiscordLuau.DiscordPermissions.Permissions.UseApplicationCommands)

local RandomColor = SlashCommand.new(
	DiscordLuau.ApplicationCommand.new()
		:setName("random-color")
		:setDescription("Fetch a random color!")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.ApplicationCommand.Context.Guild)
		:setType(DiscordLuau.ApplicationCommand.Type.ChatInput)
)

function RandomColor:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local hexColor = math.random(0x000000, 0xffffff)
	local responseEmbed = DiscordLuau.DiscordEmbed.new()

	responseEmbed:setTitle(`A RandomColor`)
	responseEmbed:setDescription(`Your random color is: #{string.upper(hexColor)}`)
	responseEmbed:setColor(hexColor)

	interaction:sendMessageAsync({
		embeds = { responseEmbed }
	})
end

return RandomColor