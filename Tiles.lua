local function q(x, y)
    return love.graphics.newQuad(x*32, y*48, 32, 48, 320, 96)
end

Tiles = {
    house = {
        wall_front = q(0,0),
        wall = q(1,0),
        floor = q(2,0),
        tile = q(3,0),
        door = q(4,0),
        door_open = q(5,0),
        rug = q(6,0),
        bed = q(7,0),
        wardrobe = q(8,0),
        chair_r = q(9,0),

        fireplace = q(0, 1),
        fire1 = q(1, 1),
        fire2 = q(2, 1),
        pot = q(3, 1),
        player1 = q(4, 1),
        player2 = q(5, 1),

        empty1 = q(6, 1),
        empty2 = q(7, 1),

        table = q(8, 1),
        chair_l = q(9,1)        
    }
}

TileCodes = {
    house = {
        'wall_front',
        'wall',
        'floor',
        'tile',
        'door',
        'door_open',
        'rug',
        'bed',
        'wardrobe',
        'chair_r',

        'fireplace',
        'fire1',
        'fire2',
        'pot',
        'player1',
        'player2',

        'empty1',
        'empty2',

        'table',
        'chair_l'
    }
}

Tilesheets = {
    house = love.graphics.newImage('tiles/house.png')
}

GameFont = love.graphics.newImageFont('font.png',
                                      ' abcdefghijklmnopqrstuvwxyz' ..
                                          'ABCDEFGHIJKLMNOPQRSTUVWXYZ' ..
                                          '0123456789' ..
                                          '!@#$%^&*()-=+[]{}:;\'"<>,.?/\\')

love.graphics.setFont(GameFont)