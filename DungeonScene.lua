local Point = sonnet.Point

DungeonScene = class('DungeonScene', sonnet.Scene)

local tilesheet = love.graphics.newImage('tiles.png')
local tiles = {
    wall_front = love.graphics.newQuad(0, 0, 32, 48, 320, 48),
    floor = love.graphics.newQuad(32, 0, 32, 48, 320, 48),
    wall = love.graphics.newQuad(64, 0, 32, 48, 320, 48),
    floor_shadow = love.graphics.newQuad(96, 0, 32, 48, 320, 48),
    player = love.graphics.newQuad(128, 0, 32, 48, 320, 48),
    door = love.graphics.newQuad(160, 0, 32, 48, 320, 48),
    door_open = love.graphics.newQuad(192, 0, 32, 48, 320, 48),
}

function DungeonScene:initialize(dungeon)
    self.frozen = false -- if frozen, ignore kbd input
    sonnet.Scene.initialize(self)
    self.dungeon = dungeon
    self.player = {}
    self:setRoom(dungeon:currentRoom())
    self.player.location = dungeon:playerLocation()
    assert(self.player.location)
end

function DungeonScene:setRoom(room)
    -- We'll store some quads and things in the room structure itself
    -- and have the scene init them the first time we see the room
    if not room.visited then -- Set up some stuff for easy drawing
        self:setQuads(room)
        room.visited = true
    end

    self.room = room
end

--- Set the quads to draw for everything in this room
function DungeonScene:setQuads(room)
    for pt, cell in room:each() do
        -- Terrain quad:
        if cell.terrain == '#' then -- wall or wall_front
            local south = room:at(pt+Point.south)

            if south and south.terrain ~= '#' then
                cell.terrain_quad = tiles.wall_front
            else
                cell.terrain_quad = tiles.wall
            end

        elseif cell.terrain == '.' then -- floor or floor_shadow
            local north = room:at(pt+Point.north)

            if north and north.terrain == '#' then
                cell.terrain_quad = tiles.floor_shadow
            else
                cell.terrain_quad = tiles.floor
            end
        end -- else nothing

        -- Add quads to objects
        for _, obj in ipairs(cell.objects) do
            if tiles[obj.type] then -- The most common case; quad is named after the type
                obj.quad = tiles[obj.type]
            end
        end

    end
end

function DungeonScene:draw()
    if self.scroll then
        local w, h = self.room.width*32, self.room.height*48
        local v = self.scroll.tween.value
        local new = nil -- where to draw the new room
        local old = nil -- where to draw the old room

        if self.scroll.dir == Point.south then
            new = Point(0, h*v)
            old = Point(0, h*v-h)
        elseif self.scroll.dir == Point.north then
            new = Point(0, h*v*-1)
            old = Point(0, h*v*-1+h)
        elseif self.scroll.dir == Point.east then
            new = Point(w*v, 0)
            old = Point(w*v-w, 0)
        elseif self.scroll.dir == Point.west then
            new = Point(w*v*-1, 0)
            old = Point(w*v*-1+w, 0)
        end

        love.graphics.push()
        love.graphics.translate(new())
        self:drawRoom(self.room)
        love.graphics.pop()
        love.graphics.push()
        love.graphics.translate(old())
        self:drawRoom(self.scroll.old_room)
        love.graphics.pop()
        
    else
        self:drawRoom(self.room)
    end

    self:fps()
end

function DungeonScene:drawRoom(room)
    for pt, cell in room:each() do
        local x, y = pt.x * 32, pt.y * 48

        if cell.terrain_quad then
            love.graphics.drawq(tilesheet, cell.terrain_quad, x, y)
        end

        for _, obj in ipairs(cell.objects) do
            if obj.quad then
                love.graphics.drawq(tilesheet, obj.quad, x, y)
            end
        end

    end

    if room == self.room then -- draw player
        love.graphics.drawq(tilesheet, tiles.player,
                            self.player.location.x*32,
                            self.player.location.y*48)
    end
end

function DungeonScene:keypressed(key)
    if key == 'escape' then
        love.event.quit()
        return
    end

    if self.frozen then return end

    local dir = Point.from_key(key)
    if dir then
        local target = self.player.location + dir
        if self:allowMove(target) then
            self.player.location = target
        elseif not self.room:inside(target) then
            self:changeRooms(dir)
        else
            local obj = self:getSolid(target)
            local reaction = false
            if obj then
                reaction = self:bump(obj, target, self.player.location)
            end
            if not reaction then
                sonnet.effects.Dim()
            end
        end
    end
end

function DungeonScene:allowMove(to)
    local inside = self.room:inside(to)
    local not_wall = inside and self.room:at(to).terrain == '.'
    local not_solid = not self:getSolid(to)
    return inside and not_wall and not_solid
end

function DungeonScene:getSolid(pt)
    local cell = self.room:at(pt)
    if not cell or not cell.objects then return false end

    for _, obj in ipairs(cell.objects) do
        if obj.solid then return obj end
    end
end

function DungeonScene:bump(object, location, player_location)
    if object.type == 'door' then
        self:openDoor(object)
        return true
    end
end

function DungeonScene:openDoor(object)
    object.type = 'door_open'
    object.quad = tiles.door_open
    object.solid = false
end

function DungeonScene:changeRooms(dir)
    local old_loc = self.dungeon:currentRoomLocation()
    local new_room = self.dungeon:setRoom(old_loc + dir)
    assert(new_room)
    
    if dir == Point.south then
        self.player.location.y = 0
    elseif dir == Point.north then
        self.player.location.y = self.room.height-1
    elseif dir == Point.east then
        self.player.location.x = 0
    elseif dir == Point.west then
        self.player.location.x = self.room.width-1
    end

    local old_room = self.room
    self:setRoom(new_room)

    -- Often, the player will be standing on
    -- a door when she first enters the room. Open it,
    -- if so.
    local obj = self:getSolid(self.player.location)
    if obj and obj.type == 'door' then self:openDoor(obj) end

    -- Animate the transition
    -- This has a tween that we'll multiply the direction by,
    -- to get the place to draw the new room
    self.scroll = {
        tween = sonnet.Tween(1, 0, 0.3),
        dir = dir,
        old_room = old_room
    }

    self.frozen = true -- Freeze while scrolling

    -- Unfreeze when done scrolling
    self.scroll.tween:promise():add(function()
                                        self.frozen = false
                                        self.scroll = nil
                                    end)
end