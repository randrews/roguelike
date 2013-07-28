Tiles = {
    wall_front = love.graphics.newQuad(0, 0, 32, 48, 320, 48),
    floor = love.graphics.newQuad(32, 0, 32, 48, 320, 48),
    wall = love.graphics.newQuad(64, 0, 32, 48, 320, 48),
    floor_shadow = love.graphics.newQuad(96, 0, 32, 48, 320, 48),
    player = love.graphics.newQuad(128, 0, 32, 48, 320, 48),
    door = love.graphics.newQuad(160, 0, 32, 48, 320, 48),
    door_open = love.graphics.newQuad(192, 0, 32, 48, 320, 48),
    tree = love.graphics.newQuad(224, 0, 32, 48, 320, 48),
}

Tilesheet = love.graphics.newImage('tiles.png')

GameFont = love.graphics.newImageFont('font.png',
                                      ' abcdefghijklmnopqrstuvwxyz' ..
                                          'ABCDEFGHIJKLMNOPQRSTUVWXYZ' ..
                                          '0123456789' ..
                                          '!@#$%^&*()-=+[]{}:;\'"<>,.?/\\')

love.graphics.setFont(GameFont)