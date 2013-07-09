function love.draw()
    local g = love.graphics
    g.setColor(120, 120, 160)
    for y = 0, 14 do
        for x = 0, 28 do
            if (x+y)%2 == 0 then
                g.rectangle('fill', x*32, y*48, 32, 48)
            end
        end
    end
end