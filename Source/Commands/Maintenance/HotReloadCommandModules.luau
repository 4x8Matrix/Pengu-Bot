local FileSystem = require("@lune/fs")

local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommands = require("../../Systems/SlashCommands")

local SlashCommandPermissions = DiscordLuau.PermissionsBuilder.new()
	:addPermission(DiscordLuau.PermissionsBuilder.Permissions.UseApplicationCommands)

local HotReloadCommandModules = SlashCommand.new(
	DiscordLuau.CommandBuilder.new()
		:setName("hot-reload-command-module")
		:setDescription("Update the code references to all commands under a command module.")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.CommandBuilder.Context.Guild)
		:setType(DiscordLuau.CommandBuilder.Type.ChatInput)
)

function HotReloadCommandModules:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local discordEmbed = DiscordLuau.EmbedBuilder.new()
	local responseMessage = DiscordLuau.MessageBuilder.new()
		
	discordEmbed:setTitle("Hot Reload Command Module")
	discordEmbed:setColor(0xffffff)
	discordEmbed:setDescription("Reloading all Lua(u) code references to various command modules listed below.")

	for commandModuleIndex, commandModule in FileSystem.readDir("Source/Commands") do
		discordEmbed:addField({
			name = commandModule,
			value = `{#FileSystem.readDir(`Source/Commands/{commandModule}`)} Commands`
		})

		SlashCommands:_loadCommandModule(commandModule)
	end

	responseMessage:addEmbed(discordEmbed)

	interaction:sendMessageAsync(responseMessage)
end

return HotReloadCommandModules