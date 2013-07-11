require('sonnet')
require('DungeonScene')

love.keyboard.setKeyRepeat( 0.35, 0.1 )

ds = DungeonScene(
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
    "   #..#######.........#  ",
    "   ####     ###########  ",
    "                         "
)

sonnet.Scene.push(ds)