Object = class('Object')

function Object:initialize()
    self:setup()
end

function Object:setup()
    self.solid = false
    self.location = nil
    self.quad = nil
end

--- ## Event handlers

--- These each take a player location (point) and return
--- a boolean. If they did something with the event,
--- responded in some way, they return true.

function Object:bump(player_location) return false end
function Object:enter(player_location) return false end
function Object:leave(player_location) return false end
function Object:enter_room(player_location) return false end
function Object:leave_room(player_location) return false end
function Object:tick(player_location) return false end
