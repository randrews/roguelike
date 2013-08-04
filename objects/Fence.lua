local Fence = class('Fence', Object)
local Point = sonnet.Point

function Fence:initialize(quad, side)
    self:setup()
    self.solid = false
    self.quad = quad
    self.dir = sonnet.Point[side] -- a direction you can't enter / leave by
    assert(self.dir)
end

function Fence:enter(player_location)
    return self.location + self.dir ~= player_location
end

function Fence:leave(target)
    return self.location + self.dir ~= target
end

return Fence