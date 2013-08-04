Area = class('Area', sonnet.Map)

function Area.static.load(modname)
    local map = require(modname)
    assert(map, "Map " .. modname .. " not found")

    local wall_layer = map.layers[1]
    local obj_layer = map.layers[2]
    local area = Area(31, 15)
    local player_loc = nil

    for n = 0, 31*15-1 do
        local x = n % 31
        local y = math.floor(n / 31)
        local wall_code = wall_layer.data[n+1] -- Tiled GIDs for the first and second layer
        local obj_code = obj_layer.data[n+1]
        local wall_type = TileCodes.house[wall_code] -- Meaningful names for the GIDs
        local obj_type = TileCodes.house[obj_code]
        local cell = Cell(sonnet.Point(x, y))

        -- set up the wall layer stuff
        cell.quad = Tiles.house[wall_type]
        if wall_type == 'wall_front' or wall_type == 'wall' or wall_type == 'fireplace' then
            cell.solid = true
        elseif wall_type == 'grass1' or wall_type == 'grass2' then
            if math.random(2) == 1 then
                cell.quad = Tiles.house.grass1
            else
                cell.quad = Tiles.house.grass2
            end

            if math.random(10) == 1 then
                cell:addObject(objects.Decoration(Tiles.house.weed, false))
            end
        end

        -- Create an object if there is one
        if obj_type == 'door' then
            cell:addObject(objects.Door())
        elseif obj_type == 'door_open' then
            local door = objects.Door()
            door:open()
            cell:addObject(door)
        elseif obj_type == 'rug' then
            cell:addObject(objects.Decoration(Tiles.house.rug, false))
        elseif obj_type == 'bed' then
            cell:addObject(objects.Decoration(Tiles.house.bed, true))
        elseif obj_type == 'wardrobe' then
            cell:addObject(objects.Decoration(Tiles.house.wardrobe, true))
        elseif obj_type == 'chair_r' then
            cell:addObject(objects.Decoration(Tiles.house.chair_r, true))
        elseif obj_type == 'chair_l' then
            cell:addObject(objects.Decoration(Tiles.house.chair_l, true))
        elseif obj_type == 'table' then
            cell:addObject(objects.Decoration(Tiles.house.table, true))
        elseif obj_type == 'pot' then
            cell:addObject(objects.Decoration(Tiles.house.pot, true))
        elseif obj_type == 'fence' then
            cell:addObject(objects.Fence(Tiles.house.fence, 'south'))
        end

        -- The player may be here
        if obj_type == 'player1' or obj_type == 'player2' then
            player_loc = sonnet.Point(x, y)
        end

        -- Add cell to map
        area:at(sonnet.Point(x, y), cell)
    end

    return area, player_loc
end

function Area:getObjects()
    local objs = table()

    for pt, cell in self:each() do
        for _, obj in ipairs(cell.objects) do
            objs:insert(obj)
        end
    end

    return objs
end

function Area:leaveRoomEvent(player_location)
    for pt, cell in self:each() do
        cell.objects:method_map('leave_room', player_location)
    end
end

function Area:enterRoomEvent(player_location)
    for pt, cell in self:each() do
        cell.objects:method_map('enter_room', player_location)
    end
end

function Area:tickEvent(player_location)
    for pt, cell in self:each() do
        cell.objects:method_map('tick', player_location)
    end
end

function Area:enterEvent(player_location, target)
    local cell = self:at(target)
    local results = cell.objects:method_map('enter', player_location)
    return self:checkObjectsAllow(results)
end

function Area:leaveEvent(player_location, target)
    local cell = self:at(player_location)
    local results = cell.objects:method_map('leave', target)
    return self:checkObjectsAllow(results)
end

function Area:checkObjectsAllow(results)
    for _, r in results:each() do -- For each response..
        if not r then -- If any said we can't, then we can't.
            return r
        end
    end

    return true -- Otherwise, we can
end