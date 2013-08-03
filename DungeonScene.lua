local Point = sonnet.Point

DungeonScene = class('DungeonScene', sonnet.Scene)

local instance_id = 1

function DungeonScene:initialize(start_area, start_location)
    self.frozen = false -- if frozen, ignore kbd input
    sonnet.Scene.initialize(self)
    self.area = start_area
    self.player_location = start_location
    assert(self.player_location)
    self.state = 'dungeonscene_'..instance_id
    self.sidebar = Sidebar(self)
end

function DungeonScene:on_install()
    loveframes.SetState(self.state)
end
DungeonScene.on_resume = DungeonScene.on_install

function DungeonScene:on_pause()
    loveframes.SetState(nil)
end

function DungeonScene:draw()
    if self.scroll then
        -- local w, h = self.room.width*32, self.room.height*48
        -- local v = self.scroll.tween.value
        -- local new = nil -- where to draw the new room
        -- local old = nil -- where to draw the old room

        -- if self.scroll.dir == Point.south then
        --     new = Point(0, h*v)
        --     old = Point(0, h*v-h)
        -- elseif self.scroll.dir == Point.north then
        --     new = Point(0, h*v*-1)
        --     old = Point(0, h*v*-1+h)
        -- elseif self.scroll.dir == Point.east then
        --     new = Point(w*v, 0)
        --     old = Point(w*v-w, 0)
        -- elseif self.scroll.dir == Point.west then
        --     new = Point(w*v*-1, 0)
        --     old = Point(w*v*-1+w, 0)
        -- end

        -- love.graphics.push()
        -- love.graphics.translate(new())
        -- self:drawRoom(self.room)
        -- love.graphics.pop()
        -- love.graphics.push()
        -- love.graphics.translate(old())
        -- self:drawRoom(self.scroll.old_room)
        -- love.graphics.pop()
        
    else
        self:drawArea(self.area)
    end

    self:fps()
end

function DungeonScene:drawArea(area)
    for pt, cell in area:each() do
        local x, y = pt.x * 32, pt.y * 48

        if cell.quad then
            love.graphics.drawq(Tilesheets.house, cell.quad, x, y)
        end

        for _, obj in cell.objects:each() do
            if obj.quad then
                love.graphics.drawq(Tilesheets.house, obj.quad, x, y)
            end
        end

    end

    if area == self.area then -- draw player
        love.graphics.drawq(Tilesheets.house, Tiles.house.player1,
                            self.player_location.x*32,
                            self.player_location.y*48)
    end
end

function DungeonScene:keypressed(key)
    if key == 'escape' then
        love.event.quit()
        return
    elseif key == ' ' then
        self.area:tickEvent(self.player.location)
    end

    if self.frozen then return end

    local dir = Point.from_key(key)

    if dir then
        local target = self.player_location + dir
        local cell = self.area:at(target)

        if not cell then -- Off the screen, change rooms
            self:changeRooms(dir)

        else
            local can_move, result = cell:tryEnter()

            if can_move then
                self.area:leaveEvent(self.player_location, target)
                self.player_location = target
                self.area:enterEvent(self.player_location)
                self.area:tickEvent(self.player_location)

            elseif result == 'dim' then
                sonnet.effects.Dim()

            elseif result == 'bump' then
                local obj = cell:getSolid()
                local reaction = obj:bump(self.player_location)

                if not reaction then -- it didn't react to the bump
                    sonnet.effects.Dim()
                else -- It did, tick
                    self.area:tickEvent(self.player_location)
                end
            end
        end
    end
end

function DungeonScene:changeRooms(dir)
    local old_loc = self.dungeon:currentRoomLocation()
    local new_room = self.dungeon:setRoom(old_loc + dir)
    assert(new_room)

    self.room:leaveRoomEvent(self.player.location)
    
    if dir == Point.south then
        self.player.location.y = 0
    elseif dir == Point.north then
        self.player.location.y = self.room.height-1
    elseif dir == Point.east then
        self.player.location.x = 0
    elseif dir == Point.west then
        self.player.location.x = self.room.width-1
    end

    local old_room = self.room
    self:setRoom(new_room)

    self.room:enterRoomEvent(self.player.location)

    -- Often, the player will be standing on
    -- a door when she first enters the room. Open it,
    -- if so.
    local cell = new_room:at(self.player.location)
    local obj = cell and cell:getSolid()
    if obj and instanceOf(objects.Door, obj) then obj:open() end

    -- Animate the transition
    -- This has a tween that we'll multiply the direction by,
    -- to get the place to draw the new room
    self.scroll = {
        tween = sonnet.Tween(1, 0, 0.3),
        dir = dir,
        old_room = old_room
    }

    self.frozen = true -- Freeze while scrolling

    -- Unfreeze when done scrolling
    self.scroll.tween:promise():add(function()
                                        self.frozen = false
                                        self.scroll = nil
                                    end)
end
