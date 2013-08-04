Cell = class('Cell')

function Cell:initialize(location)
    self.location = location
    self.objects = table()
    self.quad = nil
    self.solid = false
end

function Cell:getSolid()
    for _, obj in ipairs(self.objects) do
        if obj.solid then return obj end
    end
end

function Cell:addObject(obj)
    if obj.solid and self:getSolid() then
        error("Only one solid object per cell")
    end
    obj.location = self.location
    self.objects:insert(obj)
end

function Cell:canEnter()
    return not(self.solid or self:getSolid())
end

function Cell:tryEnter()
    if self.solid then
        return false, 'dim'
    elseif self:getSolid() then
        return false, 'bump'
    else
        return true
    end
end

function Cell:draw()
    local x, y = self.location.x * 32, self.location.y * 48

    if self.quad then
        love.graphics.drawq(Tilesheets.house, self.quad, x, y)
    end

    self.objects:method_map('draw', self.location)
end

-- draws all objects with the "overlay" property, meaning that
-- they sit on top of mobs. So, this is only called on spaces
-- that contain mobs.
function Cell:draw_overlay()
    for _, o in self.objects:each() do
        if o.overlay then o:draw(self.location) end
    end
end