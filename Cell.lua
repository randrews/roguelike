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