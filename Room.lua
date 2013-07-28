Room = class('Room', sonnet.Map)

function Room:getObjects()
    local objs = table()

    for pt, cell in self:each() do
        for _, obj in ipairs(cell:getObjects()) do
            objs:insert(obj)
        end
    end

    return objs
end

function Room:leaveRoomEvent(player_location)
    for _, obj in ipairs(self:getObjects()) do
        obj:leave_room(player_location)
    end
end

function Room:enterRoomEvent(player_location)
    for _, obj in ipairs(self:getObjects()) do
        obj:enter_room(player_location)
    end
end

function Room:tickEvent(player_location)
    for _, obj in ipairs(self:getObjects()) do
        obj:tick(player_location)
    end
end

function Room:enterEvent(player_location)
    local cell = self:at(player_location)
    for _, obj in ipairs(cell:getObjects()) do
        obj:enter(player_location)
    end
end

function Room:leaveEvent(player_location, target)
    local cell = self:at(player_location)
    for _, obj in ipairs(cell:getObjects()) do
        obj:leave(target)
    end
end
