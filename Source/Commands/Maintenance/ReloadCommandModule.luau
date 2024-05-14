local FileSystem = require("@lune/fs")
local Task = require("@lune/task")

local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommands = require("../../Systems/SlashCommands")

local SlashCommandPermissions = DiscordLuau.DiscordPermissions.new()
	:addPermission(DiscordLuau.DiscordPermissions.Permissions.UseApplicationCommands)

local ReloadCommandModule = SlashCommand.new(
	DiscordLuau.ApplicationCommand.new()
		:setName("reload-command-module")
		:setDescription("Update all commands under a command module.")
		:setGuildPermissions(SlashCommandPermissions)
		:addContext(DiscordLuau.ApplicationCommand.Context.Guild)
		:setType(DiscordLuau.ApplicationCommand.Type.ChatInput)
)

function ReloadCommandModule:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local discordEmbed = DiscordLuau.DiscordEmbed.new()
		
	discordEmbed:setTitle("Reload Command Module")
	discordEmbed:setColor(0xffffff)
	discordEmbed:setDescription("Reloaded all of the following application commands;")

	for commandModuleIndex, commandModule in FileSystem.readDir("Source/Commands") do
		discordEmbed:addField({
			name = commandModule,
			value = `{#FileSystem.readDir(`Source/Commands/{commandModule}`)} Commands`
		})

		SlashCommands:_loadCommandModule(commandModule)
	end

	discordEmbed:setFooter({
		text = "You may need to reload your Discord client to see the updated commands! (ctrl + r)"
	})

	SlashCommands:_syncCommands()

	interaction:deferAsync()

	Task.wait(15)

	interaction:editMessageAsync({
		embeds = { discordEmbed }
	})
end

return ReloadCommandModule