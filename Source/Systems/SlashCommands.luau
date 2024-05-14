local FileSystem = require("@lune/fs")

local DiscordBot = require("../DiscordBot")

local Console = require("../Vendor/Console")

local System = require("../Classes/System")

local SlashCommand = System.new("SlashCommand", DiscordBot)

local reporter = Console.new("🍀 SlashCommands")

local slashCommands = {}

function SlashCommand._loadCommandModule(self: SlashCommand, commandModule: string)
	for _, commandModuleName in FileSystem.readDir(`Source/Commands/{commandModule}`) do
		reporter:debug(`Loading command: '{commandModuleName}'`)

		local fileContent = FileSystem.readFile(`Source/Commands/{commandModule}/{commandModuleName}`)
		local fileName = `{commandModuleName}.{math.random()}.luau`
		local filePath = `Source/Commands/{commandModule}/{fileName}`

		if slashCommands[`Source/Commands/{commandModule}/{commandModuleName}`] then
			slashCommands[`Source/Commands/{commandModule}/{commandModuleName}`]:destroy()
		end

		FileSystem.writeFile(filePath, fileContent)

		slashCommands[`Source/Commands/{commandModule}/{commandModuleName}`] = require(`../Commands/{commandModule}/{fileName}`)

		FileSystem.removeFile(filePath)
	end
end

function SlashCommand._syncCommands(self: SlashCommand, commandModule: string)
	local slashCommandsArray = {}

	for _, slashCommand in slashCommands do
		table.insert(slashCommandsArray, slashCommand.command)
	end

	DiscordBot.discordClient.discordApplication:setSlashCommandsAsync(slashCommandsArray):after(function()
		reporter:debug(`Synced command modules to the Discord API`)
	end)
end

function SlashCommand.onReady(self: SlashCommand)
	for _, commandModule in FileSystem.readDir("Source/Commands") do
		reporter:debug(`Loading command module: '{commandModule}'`)

		self:_loadCommandModule(commandModule)
	end

	self:_syncCommands()
end

export type SlashCommand = typeof(SlashCommand)

return SlashCommand