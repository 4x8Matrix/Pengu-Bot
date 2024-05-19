local FileSystem = require("@lune/fs")

local DiscordLuau = require("../DiscordLuau")

local Future = require("Vendor/Future")

local Console = require("Vendor/Console")

local System = require("Classes/System")

local Env = require("../.env")

local discordIntents = DiscordLuau.DiscordIntents.fromAll()
local discordSettings = DiscordLuau.DiscordSettings.new(Env.DISCORD_BOT_AUTHENTICATION_TOKEN, discordIntents)

local discordClient = DiscordLuau.DiscordClient.new(discordSettings)

local reporter = Console.new("🤖 DiscordBot")

local DiscordBot = {}

DiscordBot.Prototype = {}
DiscordBot.Interface = {}

discordClient:setVerbose(true)

function DiscordBot.Prototype._invokeLifecycle(self: DiscordBot, lifecycleName: string, ...)
	for _, system in self.systems :: { System.System } do
		system:invokeLifecycle(lifecycleName, ...)
	end
end

function DiscordBot.Prototype._loadSystemsAsync(self: DiscordBot)
	return Future.try(function()
		for _, systemName in FileSystem.readDir("Source/Systems") do
			reporter:debug(`Initializing discord bot system 'Systems/{systemName}'!`)

			local systemObject = require(`Systems/{systemName}`)

			table.insert(self.systems, systemObject)
		end
	end)
end

function DiscordBot.Prototype._connectAsync(self: DiscordBot)
	reporter:debug(`Connecting to discord Websocket..`)

	return Future.try(function()
		self.discordClient:connectAsync():await()

		reporter:debug(`Connected to the discord websocket!`)
	end)
end

function DiscordBot.Prototype._initializeAsync(self: DiscordBot)
	return Future.try(function()
		reporter:log(`Initializing..`)

		local readyConnection

		discordClient.eventManager.onReady:connect(function()
			readyConnection:disconnect()
			readyConnection = nil

			self:_invokeLifecycle("onReady")
		end)

		self:_loadSystemsAsync():await()
		self:_invokeLifecycle("onInit")
		self:_connectAsync():await()
		self:_invokeLifecycle("onConnected")
	end)
end

function DiscordBot.Interface.new()
	return setmetatable({
		discordClient = discordClient,
		startTime = os.time(),

		systems = {}
	}, {
		__index = DiscordBot.Prototype
	})
end

export type DiscordBot = typeof(DiscordBot.Prototype) & {
	discordClient: typeof(discordClient),

	systems: { System.System }
}

return DiscordBot.Interface.new()