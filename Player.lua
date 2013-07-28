Player = class('Player')

function Player:initialize()
    self.health = 10
    self.skills = table()
    self.inventory = table()
end