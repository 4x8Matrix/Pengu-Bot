local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local HEADS_IMAGE_URL = "https://i.ibb.co/cNLMgZd/HEAD.png"
local TAILS_IMAGE_URL = "https://i.ibb.co/9ZxVV2X/TAILS.png"

local SlashCommandPermissions = DiscordLuau.PermissionsBuilder.new()
	:addPermission(DiscordLuau.PermissionsBuilder.Permissions.UseApplicationCommands)

local Flip = SlashCommand.new(
	DiscordLuau.CommandBuilder.new()
		:setName("flip")
		:setDescription("Flip a coin!")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.CommandBuilder.Context.Guild)
		:setType(DiscordLuau.CommandBuilder.Type.ChatInput)
)

function Flip:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local responseEmbed = DiscordLuau.EmbedBuilder.new()
	local responseMessage = DiscordLuau.MessageBuilder.new()
	local isHeads = math.random() > 0.5

	responseEmbed:setTitle(`Here you go;`)
	responseEmbed:setDescription(`You got a '{isHeads and "HEADS" or "TAILS"}'!`)
	responseEmbed:setColor(0xffffff)
	responseEmbed:setImage({
		imageUrl = isHeads and HEADS_IMAGE_URL or TAILS_IMAGE_URL
	})

	responseMessage:addEmbed(responseEmbed)

	interaction:sendMessageAsync(responseMessage)
end

return Flip