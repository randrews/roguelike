module(..., package.seeall)
local Map = sonnet.Map
local Point = sonnet.Point

function generate(w, h)
    local map = Map(w, h)
    local start = map:random(on_edge)
    local current = start

    while map:find_value(0)[1] do
        random_walk(map, current)
        current = map:find(has_empty_neighbor):random()
    end

    return map, start
end

function on_edge(map, pt)
    local neighbors = map:neighbors(pt)
    return #neighbors == 3
end

function has_empty_neighbor(map, pt)
    local empty_neighbors = map:neighbors(pt, 0)
    return #empty_neighbors > 0
end

function random_walk(map, current)
    if not has_empty_neighbor(map, current) then return
    else
        local n = map:neighbors(current, 0):random()
        connect(map, current, n)
        random_walk(map, n)
    end
end

-- n e s w
-- 1 2 4 8
function connect(map, a, b)
    local av = map:at(a)
    local bv = map:at(b)

    if b == a + Point.north then
        av = av + 1
        bv = bv + 4
    elseif b == a + Point.east then
        av = av + 2
        bv = bv + 8
    elseif b == a + Point.south then
        av = av + 4
        bv = bv + 1
    elseif b == a + Point.west then
        av = av + 8
        bv = bv + 2
    end

    map:at(a, av)
    map:at(b, bv)
end