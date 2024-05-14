local FileSystem = require("@lune/fs")

local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommands = require("../../Systems/SlashCommands")

local SlashCommandPermissions = DiscordLuau.DiscordPermissions.new()
	:addPermission(DiscordLuau.DiscordPermissions.Permissions.UseApplicationCommands)

local HotReloadCommandModules = SlashCommand.new(
	DiscordLuau.ApplicationCommand.new()
		:setName("hot-reload-command-module")
		:setDescription("Update the code references to all commands under a command module.")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.ApplicationCommand.Context.Guild)
		:setType(DiscordLuau.ApplicationCommand.Type.ChatInput)
)

function HotReloadCommandModules:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local discordEmbed = DiscordLuau.DiscordEmbed.new()
		
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

	interaction:sendMessageAsync({
		embeds = { discordEmbed }
	})
end

return HotReloadCommandModules