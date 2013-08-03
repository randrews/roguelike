require('sonnet')
require('loveframes')
require('Tiles')
require('RogueSkin')
require('Player')
require('Object')
require('Area')
require('Cell')
require('DungeonScene')
require('Sidebar')

objects = {}
objects.Eventer = require('objects.Eventer')
objects.Decoration = require('objects.Decoration')
objects.Door = require('objects.Door')

love.keyboard.setKeyRepeat( 0.35, 0.1 )

local start_area, player_start_loc = Area.load("maps.house")
local ds = DungeonScene(start_area, player_start_loc)

sonnet.Scene.push(ds)