local Net = require("@lune/net")

local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.PermissionsBuilder.new()
	:addPermission(DiscordLuau.PermissionsBuilder.Permissions.UseApplicationCommands)

local Joke = SlashCommand.new(
	DiscordLuau.CommandBuilder.new()
		:setName("joke")
		:setDescription("Fetch a funny joke to share on Discord")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.CommandBuilder.Context.Guild)
		:setType(DiscordLuau.CommandBuilder.Type.ChatInput)
)

function Joke:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	interaction:deferAsync():await()

	local responseEmbed = DiscordLuau.EmbedBuilder.new()
	local responseMessage = DiscordLuau.MessageBuilder.new()
	local request = Net.request({
		url = "https://v2.jokeapi.dev/joke/Any?safe-mode&type=single&format=json",
		method = "GET"
	})

	if not request.ok then
		responseEmbed:setTitle("I'm all out of jokes..")
		responseEmbed:setDescription(`Error: '{request.statusMessage}'`)
		responseEmbed:setFooter({ text = "Request to fetch joke failed.." })
		responseEmbed:setColor(0xff0000)
	else
		local requestBodyJsonDecoded = Net.jsonDecode(request.body)

		responseEmbed:setTitle(`Here you go;`)
		responseEmbed:setFooter({ text = "Thank you v2.jokeapi.dev!" })
		responseEmbed:setColor(0xffffff)
		responseEmbed:setDescription(requestBodyJsonDecoded.joke)
	end

	responseMessage:addEmbed(responseEmbed)

	interaction:sendMessageAsync(responseMessage)
end

return Joke