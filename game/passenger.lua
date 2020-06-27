local GameObject = require "game.object"
local Passenger = GameObject:extend()

function Passenger:new(x, y, world)
  self.world = world

  self.body = self.world:newCircleCollider(x, y, 10)
end

return Passenger
