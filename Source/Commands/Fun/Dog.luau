local Net = require("@lune/net")

local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.PermissionsBuilder.new()
	:addPermission(DiscordLuau.PermissionsBuilder.Permissions.UseApplicationCommands)

local Dog = SlashCommand.new(
	DiscordLuau.CommandBuilder.new()
		:setName("dog")
		:setDescription("Fetch a Dog from a repository of dog photos!")
		:setGuildPermissions(SlashCommandPermissions)
		:setType(DiscordLuau.CommandBuilder.Type.ChatInput)
		:addContext(DiscordLuau.CommandBuilder.Context.Guild)
		:addContext(DiscordLuau.CommandBuilder.Context.PrivateChannel)
		:addContext(DiscordLuau.CommandBuilder.Context.BotDM)
		:addIntegration(DiscordLuau.CommandBuilder.IntegrationType.GuildCommand)
		:addIntegration(DiscordLuau.CommandBuilder.IntegrationType.UserCommand)
)

function Dog:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	interaction:deferAsync()

	local responseEmbed = DiscordLuau.EmbedBuilder.new()
	local responseMessage = DiscordLuau.MessageBuilder.new()
	local request = Net.request({
		url = "https://dog.ceo/api/breeds/image/random",
		method = "GET"
	})

	if not request.ok then
		responseEmbed:setTitle("The dogs are sleeping..")
		responseEmbed:setDescription(`Error: '{request.statusMessage}'`)
		responseEmbed:setFooter({ text = "Request to fetch dog image failed.." })
		responseEmbed:setColor(0xff0000)
	else
		local requestBodyJsonDecoded = Net.jsonDecode(request.body)

		responseEmbed:setTitle(`A Random Doggo!`)
		responseEmbed:setFooter({ text = "Thank you dog.ceo!" })
		responseEmbed:setColor(0xffffff)
		responseEmbed:setImage({
			imageUrl = requestBodyJsonDecoded.message
		})
	end

	responseMessage:addEmbed(responseEmbed)

	interaction:sendMessageAsync(responseMessage)
end

return Dog