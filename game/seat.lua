local GameObject = require "game.object"
local Seat = GameObject:extend()

function Seat:new(y, x, dir, train)
  self.x = x
  self.y = y
  self.dir = dir

  self.train = train

  self[1] = y
  self[2] = x
  self[3] = dir

  self.occupied = {}
end

function Seat:update(dt)
end

function Seat:getBoundaries()
  local seatX, seatY = self.train:getSeatCoords(self)

  local sx, sy, ex, ey

  if self.dir == 1 then
    sx = seatX + 10
    sy = seatY
    ex = 40
    ey = self.train.cart_height / 3
  else
    sx = seatX - 40
    sy = seatY
    ex = 40
    ey = self.train.cart_height / 3
  end

  return sx, sy, ex, ey
end

function Seat:getPosition(id)
  local x, y, w, h = self:getBoundaries()

  if self.y == 0 then
    return x + w / 2, y + h * id / 3 - h / 6
  else
    return x + w / 2, y + h  -  h * id / 3 + h / 6
  end
end

function Seat:draw()
  local x, y, w, h = self:getBoundaries()
  
  love.graphics.setLineWidth(1)
  love.graphics.setColor(1, 1, 0)
  love.graphics.rectangle("line", self:getBoundaries())

  if #self.occupied == 3 then
    love.graphics.rectangle("fill", self:getBoundaries())
  end

  love.graphics.line(x, y + h / 3, x + w, y + h / 3)
  love.graphics.line(x, y + h * 2 / 3, x + w, y + h * 2 / 3)
end

return Seat
