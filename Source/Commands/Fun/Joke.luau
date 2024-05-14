local Net = require("@lune/net")

local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.DiscordPermissions.new()
	:addPermission(DiscordLuau.DiscordPermissions.Permissions.UseApplicationCommands)

local Joke = SlashCommand.new(
	DiscordLuau.ApplicationCommand.new()
		:setName("joke")
		:setDescription("Fetch a funny joke to share on Discord")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.ApplicationCommand.Context.Guild)
		:setType(DiscordLuau.ApplicationCommand.Type.ChatInput)
)

function Joke:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	interaction:deferAsync():await()

	local responseEmbed = DiscordLuau.DiscordEmbed.new()
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

	interaction:sendMessageAsync({
		embeds = { responseEmbed }
	})
end

return Joke