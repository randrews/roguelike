Door = class('Door', Object)

function Door:initialize()
    Object.initialize(self)
    self.solid = true
    self.quad = Tiles.door
end

function Door:bump(player_location)
    self:open()
    return true
end

function Door:open()
    self.solid = false
    self.quad = Tiles.door_open
end