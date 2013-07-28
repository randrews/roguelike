local Eventer = class('Eventer', Object)

function Eventer:initialize()
    self:setup()
    self.solid = false
    self.quad = Tiles.tree
end

function Eventer:bump(player_location)
    print("bump")
    return true
end

function Eventer:enter(player_location)
    print("enter")
    return true
end

function Eventer:leave(player_location)
    print("leave")
    return true
end

function Eventer:enter_room(player_location)
    print("enter_room")
    return true
end

function Eventer:leave_room(player_location)
    print("leave_room")
    return true
end

function Eventer:tick(player_location)
    print("tick")
    return true
end


return Eventer