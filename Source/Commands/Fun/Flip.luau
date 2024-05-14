local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local HEADS_IMAGE_URL = "https://i.ibb.co/cNLMgZd/HEAD.png"
local TAILS_IMAGE_URL = "https://i.ibb.co/9ZxVV2X/TAILS.png"

local SlashCommandPermissions = DiscordLuau.DiscordPermissions.new()
	:addPermission(DiscordLuau.DiscordPermissions.Permissions.UseApplicationCommands)

local Flip = SlashCommand.new(
	DiscordLuau.ApplicationCommand.new()
		:setName("flip")
		:setDescription("Flip a coin!")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.ApplicationCommand.Context.Guild)
		:setType(DiscordLuau.ApplicationCommand.Type.ChatInput)
)

function Flip:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local responseEmbed = DiscordLuau.DiscordEmbed.new()
	local isHeads = math.random() > 0.5

	responseEmbed:setTitle(`Here you go;`)
	responseEmbed:setDescription(`You got a '{isHeads and "HEADS" or "TAILS"}'!`)
	responseEmbed:setColor(0xffffff)
	responseEmbed:setImage({
		imageUrl = isHeads and HEADS_IMAGE_URL or TAILS_IMAGE_URL
	})

	interaction:sendMessageAsync({
		embeds = { responseEmbed }
	})
end

return Flip