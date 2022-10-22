-- ecs.lua is a simple entity component system implementation for löve.

-- World:
--  A world acts like a container for the entities and systems.
-- Entity:
--  An entity should contain any data pretaining to it
--  When entities are added to the world, The following fields are added to them automatically
--  _INDEX: The index of the entity in the entity table. Used for deleting entities
--  world: The world the entity lives in.
--
-- Component:
--  As far as this module is concerned, Any data in an entity is a component.
-- System:
--  A system needs to at minumum have a method called "process" and a method called "filter".
--      The "process" method gets an entity as an argument, And should process said entity accordingly
--      The "filter" method gets an entity as an argument, And should return a truthy value if said entity should be processed by the system
--
-- System sorting: 
--  Sometimes the order in which the systems process entities is important. To ensure the proper order, You can sort the systems with the "sortSystems" method.
--  It takes a sorting function as an argument. Creating the sorting function is left up to the end user.
--
-- System updating
--  Each system keeps track of the entities that it should process.
--  To update the systems internal entity list, world:refresh() needs to be called. This is called
--  automatically anytime an entity or system is added and removed, But needss to be manually called when an entity
--  is changed in such a way the systems processing it change.
--
-- Reusable components
--  A component can be more than a simple variable. While you can create these components yourself, ecs.lua
--  can facilitate that funcionality. You can call "world:defineComponent(componentName, component)"  to define a new compnent
--  Then in your entity, Or wherever you feel like you can call "world:newComponent(componentName, properties)" to get a copy
--  of a given component
--  
-- bump.lua integration
--  ecs.lua can integrate with bump.lua in a very minimal way. To enable that integration, You need to load bump.lua into your project, Then pass it to
--  ecs.lua via ecs:importBump(bump). Once you do that, Any world you create will also contain a bump world stored in world.bumpWorld
--  Managing that world is up to you after that point!

local function copyTable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[copyTable(orig_key)] = copyTable(orig_value)
        end
        setmetatable(copy, copyTable(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

local ecs = {
    component = {}
}
local _ecs = {__index = ecs}

-- Shorthands
local insert = table.insert
local remove = table.remove
local fs = love.filesystem
local f = string.format

-- This function imports bump.lua into ecs.lua. "bump" should refer to bump.
function ecs:importBump(bump)
    self.bump = bump
end

function ecs.newWorld()
    local world =  setmetatable({
        entity = {},
        system = {},
        debug = {
            updateTime = 0,
            iterationsPerUpdate = 0
        }
    }, _ecs)

    if ecs.bump then
        world.bumpWorld = ecs.bump.newWorld() 
    end

    return world
end

-- Defines a component
function ecs:defineComponent(componentName, component)
    assert(self.component[componentName] == nil, f("The component '%s' already exists!", componentName))
    self.component[componentName] = component
end

-- Returns a new component
function ecs:newComponent(componentName, properties)
    assert(self.component[componentName], f("The component '%s' doesn't exists!", componentName))
    local component = copyTable(self.component[componentName])
    if properties then
        for key, value in pairs(properties) do
            component[key] = value
        end
    end
    return component
end

-- Adds a new entity to the world
-- Can either take a string thats a path to a file or a table
function ecs:newEntity(path)
    local entity
    -- Checking if the provided argument is a table or path
    if type(path) == "string" then
        assert(fs.getInfo(path), f("'%s' doesn't exist!", path))
        entity = fs.load(path)()
    elseif type(path) == "table" then
        entity = path 
    end

    -- Calling load function if one exists
    if type(entity.init) == "function" then
        entity:init()
    end

    -- Adding some ecs.lua fields
    entity._INDEX = #self.entity + 1
    entity.world = self

    -- Adding to ecs world
    self.entity[entity._INDEX] = entity
    self:refresh()
    return self.entity[entity._INDEX]
end

-- Removes an entity from the world
function ecs:removeEntity(entity)
    -- Removing the entity from the bump world if its there
    if self.bump then
        if self.bumpWorld:hasItem(entity) then
            self.bumpWorld:remove(entity)
        end
    end
    remove(self.entity, entity._INDEX)
    self:refresh()
    return self
end

function ecs:newSystem(path)
    local system
    if type(path) == "string" then
        assert(fs.getInfo(path), f("'%s' doesn't exist!", path))
        system = fs.load(path)()
    elseif type(path) == "table" then
        system = path 
    end
    system.filter = system.filter or function() return true end
    system._INDEX = #self.system + 1
    system._ENTITY = {}
    self.system[system._INDEX] = system
    self:refresh()
    return self, self.system[system._INDEX]
end

function ecs:sortSystems(sortingFunction)
    table.sort(self.system, sortingFunction)
    return self
end

-- Refreshes the entity tables for each system
function ecs:refresh()
    for _, system in ipairs(self.system) do
        system._ENTITY = {}
        for _, entity in ipairs(self.entity) do
            if system.filter(entity) then
                insert(system._ENTITY, entity)
            end
        end
    end
    return self
end

-- Processes all the systems and entities
function ecs:update(filter, dt)
    local start = love.timer.getTime()
    self.debug.iterationsPerUpdate = 0
    filter = filter or function() return true end
    dt = dt or love.timer.getDelta()
    for _, system in ipairs(self.system) do
        self.debug.iterationsPerUpdate = self.debug.iterationsPerUpdate + 1
        if filter(system) then
            for _, entity in ipairs(system._ENTITY) do
                self.debug.iterationsPerUpdate = self.debug.iterationsPerUpdate + 1
                if system.filter(entity) then
                    system.process(entity, dt)
                end
            end
        end
    end
    self.debug.updateTime = love.timer.getTime() - start
end

return ecs