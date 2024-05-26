local Task = require("@lune/task")

local DiscordLuau = require("../../DiscordLuau")
local DiscordBot = require("../DiscordBot")

local Console = require("../Vendor/Console")

local System = require("../Classes/System")

local ACTIVITY_DURATION = 60 * 30
local RANDOM_ACTIVITY_NAME_LIST = table.freeze({
	"AsyncMatrix program at 3AM",
	"Lua(u)'s Repository for any/all updates!",
	"Youtube on my totally real bot phone",
	"Some inspirational quotes",
	"DevComp try to write a bootloader"
})

local Presense = System.new("Presense")

local reporter = Console.new("🎯 Presense")

function Presense:onReady()
	local discordPresence = DiscordLuau.PresenceBuilder.new()
	local discordActivity = DiscordLuau.ActivityBuilder.new()

	while true do
		discordActivity:setActivityName(RANDOM_ACTIVITY_NAME_LIST[math.random(#RANDOM_ACTIVITY_NAME_LIST)])
		discordActivity:setActivityType(DiscordLuau.ActivityBuilder.Type.Watching)

		discordPresence:setStatus(DiscordLuau.PresenceBuilder.Status.Idle)
		discordPresence:addActivity(discordActivity)
		discordPresence:setSince(0)

		DiscordBot.discordClient:updatePresenceAsync(discordPresence):after(function()
			reporter:log(`Updated bot '{DiscordBot.discordClient.discordUser.username}' presense to '{discordActivity.name}'!`)
		end)

		Task.wait(ACTIVITY_DURATION)
	end
end

return Presense