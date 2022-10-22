local plugin = {
    loaded = {}
}
plugin.__mt = {__index = plugin}

local fs = love.filesystem
local f = string.format

function plugin:iterate(func)
    for _, plugin in pairs(self.loaded) do
        func(plugin)
    end
end

function plugin:load(path)
    assert(fs.getInfo(path), f("The file '%s' does not exists.", path))
    local name = path:match(".+%."):sub(1, -2) 
    self.loaded[name] = fs.load(path)()

    -- Calling the plugins load function if one exists
    if type(self.loaded[name].load) == "function" then
        self.loaded[name]:load(self.vecs) 
    end

    return self.loaded[name]
end

function plugin:onEntityAdd(entity)
    self:iterate(function(plugin)
        if type(plugin.onEntityAdd) == "function" then
            plugin.onEntityAdd(entity)
        end
    end) 
end

function plugin:onEntityRemove(entity)
    self:iterate(function(plugin)
        if type(plugin.onEntityAdd) == "function" then
            plugin.onEntityRemove(entity)
        end
    end) 
end

function plugin:onSystemAdd(system)
    self:iterate(function(plugin)
        if type(plugin.onEntityAdd) == "function" then
            plugin.onSystemAdd(system)
        end
    end) 
end

function plugin:onSystemRemove(system)
    self:iterate(function(plugin)
        if type(plugin.onEntityAdd) == "function" then
            plugin.onSystemRemove(system)
        end
    end) 
end

function plugin:onClear()
    self:iterate(function(plugin)
        if type(plugin.onEntityAdd) == "function" then
            plugin.onClear()
        end
    end) 
end

function plugin:onRefresh()
    self:iterate(function(plugin)
        if type(plugin.onEntityAdd) == "function" then
            plugin.onRefresh()
        end
    end) 
end

return setmetatable(plugin, {
    __call = function(_, ...)
        return plugin:load(...)
    end
})