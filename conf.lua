function love.conf(t)
    t.title = "Roguelike"
    t.author = "Ross Andrews"

    t.identity = nil            -- The name of the save directory (string)
    t.version = "0.8.0"         -- The LÖVE version this game was made for (string)
    t.release = false           -- Enable release mode (boolean)

    t.screen.width = 1280
    t.screen.height = 720

    t.modules.joystick = false
    t.modules.physics = false
end