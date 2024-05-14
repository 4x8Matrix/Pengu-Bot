local Net = require("@lune/net")

local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.DiscordPermissions.new()
	:addPermission(DiscordLuau.DiscordPermissions.Permissions.UseApplicationCommands)

local Dog = SlashCommand.new(
	DiscordLuau.ApplicationCommand.new()
		:setName("dog")
		:setDescription("Fetch a Dog from a repository of dog photos!")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.ApplicationCommand.Context.Guild)
		:setType(DiscordLuau.ApplicationCommand.Type.ChatInput)
)

function Dog:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	interaction:deferAsync():await()

	local responseEmbed = DiscordLuau.DiscordEmbed.new()
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

	interaction:sendMessageAsync({
		embeds = { responseEmbed }
	})
end

return Dog