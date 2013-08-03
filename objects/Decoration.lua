local Decoration = class('Decoration', Object)

function Decoration:initialize(quad, solid)
    self:setup()
    self.solid = solid or false
    self.quad = quad
end

return Decoration