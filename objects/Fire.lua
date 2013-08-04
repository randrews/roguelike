local Fire = class('Fire', Object)

function Fire:initialize()
    Object.initialize(self)
    self.quad = Tiles.house.fire1
    self.clock = sonnet.Clock(0.25, self.change_quad, self)
    self.clock.elapsed = math.random() / 4
end

function Fire:change_quad()
    if self.quad == Tiles.house.fire1 then
        self.quad = Tiles.house.fire2
    else
        self.quad = Tiles.house.fire1
    end
end

return Fire