local FileSystem = require("@lune/fs")
local Task = require("@lune/task")

local DiscordLuau = require("../../../DiscordLuau")

local SlashCommand = require("../../Classes/SlashCommand")

local SlashCommands = require("../../Systems/SlashCommands")

local SlashCommandPermissions = DiscordLuau.PermissionsBuilder.new()
	:addPermission(DiscordLuau.PermissionsBuilder.Permissions.UseApplicationCommands)

local ReloadCommandModule = SlashCommand.new(
	DiscordLuau.CommandBuilder.new()
		:setName("reload-command-module")
		:setDescription("Update all commands under a command module.")
		:setGuildPermissions(SlashCommandPermissions)
		:setType(DiscordLuau.CommandBuilder.Type.ChatInput)
		:addContext(DiscordLuau.CommandBuilder.Context.Guild)
		:addContext(DiscordLuau.CommandBuilder.Context.PrivateChannel)
		:addContext(DiscordLuau.CommandBuilder.Context.BotDM)
		:addIntegration(DiscordLuau.CommandBuilder.IntegrationType.GuildCommand)
		:addIntegration(DiscordLuau.CommandBuilder.IntegrationType.UserCommand)
)

function ReloadCommandModule:onInvoked(interaction: DiscordLuau.DiscordInteraction)
	local discordEmbed = DiscordLuau.EmbedBuilder.new()
	local responseMessage = DiscordLuau.MessageBuilder.new()
		
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

	responseMessage:addEmbed(discordEmbed)

	SlashCommands:_syncCommands()

	interaction:deferAsync()

	Task.wait(15)

	interaction:editMessageAsync(responseMessage)
end

return ReloadCommandModule