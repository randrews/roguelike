local Door = class('Door', Object)

function Door:initialize()
    Object.initialize(self)
    self.solid = true
    self.overlay = true
    self.quad = Tiles.house.door
end

function Door:bump(player_location)
    self:open()
    return true
end

function Door:open()
    self.solid = false
    self.quad = Tiles.house.door_open
end

return Door