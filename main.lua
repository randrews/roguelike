require('sonnet')
require('Dungeon')
require('DungeonScene')

love.keyboard.setKeyRepeat( 0.35, 0.1 )

local d = Dungeon(3,3)

d:addRoom(sonnet.Point(0,0),
    "                         ",
    "   #######  ######       ",
    "   #.....#  #....#       ",
    "   #.....####....#       ",
    "   #.............####    ",
    "   ####.............#    ",
    "      #....@......###    ",
    "      #...........#      ",
    "   ####......######      ",
    "   #.........#           ",
    "   #.........##########  ",
    "   #..................#  ",
    "   #..#####...........#  ",
    "   ####   ##.##########  ",
    "           #+#           "
)

local ds = DungeonScene(d)

sonnet.Scene.push(ds)