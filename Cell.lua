Cell = class('Cell')

function Cell:initialize(location)
    self.location = location
    self.objects = table()
    self.terrain = nil -- character, like '#' or '.'
end

function Cell:getSolid()
    for _, obj in ipairs(self.objects) do
        if obj.solid then return obj end
    end
end

function Cell:getObjects()
    return self.objects
end

function Cell:addObject(obj)
    if obj.solid and self:getSolid() then
        error("Only one solid object per cell")
    end
    obj.location = self.location
    self.objects:insert(obj)
end

function Cell:setTerrain(char)
    self.terrain = char
end

function Cell:canEnter()
    return self.terrain == '.'
end