local GameObject = require "game.object"
local Seat = GameObject:extend()

function Seat:new(x, y, dir, train)
  self.x = x
  self.y = y
  self.dir = dir

  self.train = train

  self[1] = x
  self[2] = y
  self[3] = dir
end

function Seat:getCoords()

end

function Seat:update(dt)

end

function Seat:draw()
end

return Seat
