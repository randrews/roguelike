require('sonnet')
require('loveframes')
require('Tiles')
require('RogueSkin')
require('Player')
-- require('Skill')
require('Object')
require('Cell')
require('Room')
require('Dungeon')
require('DungeonScene')
require('Sidebar')
require('maze')
require('dungeon_generator')

objects = {}
objects.Eventer = require('objects.Eventer')
objects.Door = require('objects.Door')

love.keyboard.setKeyRepeat( 0.35, 0.1 )

local d = dungeon_generator.generate(5, 5)
local ds = DungeonScene(d)

sonnet.Scene.push(ds)