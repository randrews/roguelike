module(..., package.seeall)

function generate(w, h)
    local room_map, start = maze.generate(w, h)
    local dungeon = Dungeon(w, h)

    for pt, exits in room_map:each() do
        local room = make_room(parse_exits(exits), pt == start)
        dungeon:addRoom(pt, room)
    end

    return dungeon
end

-- exits is a table of points, start is a boolean (if the player starts here)
-- rooms are all 31x15
function make_room(exits, start)
    local room = sonnet.Map(31, 15, '.')
    local edges = room:find(function(_, pt)
                                return pt.x == 0 or pt.y == 0 or pt.x == 30 or pt.y == 14
                            end)

    for _, pt in ipairs(edges) do room:at(pt, '#') end
    for _, pt in ipairs(exits) do room:at(pt, '+') end
    if start then room:at(sonnet.Point(15, 8), '@') end

    return room
end


-- n e s w
-- 1 2 4 8
function parse_exits(val)
    local exits = table()

    if val >= 8 then exits:insert(sonnet.Point(0, 8)) ; val = val - 8 end
    if val >= 4 then exits:insert(sonnet.Point(15, 14)) ; val = val - 4 end
    if val >= 2 then exits:insert(sonnet.Point(30, 8)) ; val = val - 2 end
    if val >= 1 then exits:insert(sonnet.Point(15, 0)) ; val = val - 1 end

    return exits
end