local Net = require("@lune/net")

local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommandPermissions = DiscordLuau.DiscordPermissions.new()
	:addPermission(DiscordLuau.DiscordPermissions.Permissions.UseApplicationCommands)

local Cat = SlashCommand.new(
	DiscordLuau.ApplicationCommand.new()
		:setName("cat")
		:setDescription("Fetch a Cat from a repository of cat photos!")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.ApplicationCommand.Context.Guild)
		:setType(DiscordLuau.ApplicationCommand.Type.ChatInput)
)

function Cat:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	interaction:deferAsync():await()

	local responseEmbed = DiscordLuau.DiscordEmbed.new()
	local request = Net.request({
		url = "https://api.thecatapi.com/v1/images/search?format=json",
		method = "GET"
	})

	if not request.ok then
		responseEmbed:setTitle("The cats are sleeping..")
		responseEmbed:setDescription(`Error: '{request.statusMessage}'`)
		responseEmbed:setFooter({ text = "Request to fetch cat image failed.." })
		responseEmbed:setColor(0xff0000)
	else
		local requestBodyJsonDecoded = Net.jsonDecode(request.body)

		responseEmbed:setTitle(`A Random Cat!`)
		responseEmbed:setFooter({ text = "Thank you api.thecatapi.com!" })
		responseEmbed:setColor(0xffffff)
		responseEmbed:setImage({
			imageUrl = requestBodyJsonDecoded[1].url,
			width = requestBodyJsonDecoded[1].width,
			height = requestBodyJsonDecoded[1].height
		})
	end

	interaction:sendMessageAsync({
		embeds = { responseEmbed }
	})
end

return Cat