Dungeon = class('Dungeon')
local Point = sonnet.Point

function Dungeon:initialize(w,h)
    self.rooms = sonnet.Map(w,h)
    self.current_room = nil -- current room location
    self.player_location = nil
end

function Dungeon:addRoom(pt, ...)
    local map, player = self:newRoom(...)
    self.rooms:at(pt, map)
    
    if player then
        self.player_location = player
        self.current_room = pt
    end
end

-- returns a map of {objects, terrain}
-- The player point may be nil, if the player isn't in this room
function Dungeon:newRoom(...)
    local map = sonnet.Map.new_from_strings{...}
    local player = nil

    for pt, val in map:each() do
        local cell = {objects=table()}
        if val == '+' then -- door
            val = '.'
            cell.objects:insert{ type='door', solid=true }
        elseif val == '@' then -- player
            val = '.'
            player = pt
        end

        cell.terrain = val
        map:at(pt, cell)
    end

    return map, player
end

function Dungeon:roomAt(pt)
    return self.rooms:at(pt)
end

function Dungeon:currentRoom()
    assert(self.current_room)
    return self:roomAt(self.current_room)
end

function Dungeon:currentRoomLocation()
    return self.current_room
end

function Dungeon:setRoom(location)
    local new_room = self:roomAt(location)
    assert(new_room)
    self.current_room = location

    return self:currentRoom()
end

-- player start location
function Dungeon:playerLocation()
    return self.player_location
end