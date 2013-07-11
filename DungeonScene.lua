DungeonScene = class('DungeonScene', sonnet.Scene)
local Point = sonnet.Point

local tilesheet = love.graphics.newImage('tiles.png')
local tiles = {
    wall_front = love.graphics.newQuad(0, 0, 32, 48, 320, 48),
    floor = love.graphics.newQuad(32, 0, 32, 48, 320, 48),
    wall = love.graphics.newQuad(64, 0, 32, 48, 320, 48),
    floor_shadow = love.graphics.newQuad(96, 0, 32, 48, 320, 48),
    player = love.graphics.newQuad(128, 0, 32, 48, 320, 48),
}

function DungeonScene:initialize(...)
    sonnet.Scene.initialize(self)
    self.map = sonnet.Map.new_from_strings{...}
    self:preprocess_map(self.map)
    self.walls = self:make_wall_sprite_batch(self.quad_map)
end

function DungeonScene:preprocess_map(map)
    self.player = {
        location = map:find_value('@')[1]
    }
    assert(self.player.location)
    map:at(self.player.location, '.')

    local newmap = sonnet.Map(map.width, map.height)
    for pt, val in map:each() do
        if val == '#' then -- wall or wall_front

            if map:at(pt+Point.south) ~= '#' then
                newmap:at(pt, tiles.wall_front)
            else
                newmap:at(pt, tiles.wall)
            end

        elseif val == '.' then -- floor or floor_shadow

            if map:at(pt+Point.north) == '#' then
                newmap:at(pt, tiles.floor_shadow)
            else
                newmap:at(pt, tiles.floor)
            end

        end -- else nothing
    end

    self.quad_map = newmap
end

function DungeonScene:make_wall_sprite_batch(map)
    local batch = love.graphics.newSpriteBatch(tilesheet, map.width*map.height, 'dynamic')

    for pt, quad in map:each() do
        if quad ~= 0 then
            batch:addq(quad,
                       pt.x*32, pt.y*48)
        end
    end

    return batch
end

function DungeonScene:draw()
    love.graphics.draw(self.walls)
    love.graphics.drawq(tilesheet, tiles.player,
                        self.player.location.x*32,
                        self.player.location.y*48)
    self:fps()
end

function DungeonScene:keypressed(key)
    if key == 'escape' then
        love.event.quit()
        return
    end

    local pt = Point.from_key(key)
    if pt then self.player.location = self.player.location + pt end
end