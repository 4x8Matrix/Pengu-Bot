local Task = require("@lune/task")

local System = {}

System.Prototype = {}
System.Interface = {}

function System.Prototype.invokeLifecycle(self: System, lifecycleName: string, ...)
	if (self :: {})[lifecycleName] then
		Task.spawn((self :: {})[lifecycleName], self, ...)
	end
end

function System.Interface.new(systemName: string)
	return setmetatable({
		name = systemName
	}, {
		__index = System.Prototype
	})
end

export type System = typeof(System.Prototype) & {
	name: string
}

return System.Interface