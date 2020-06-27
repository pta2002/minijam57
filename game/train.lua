local wf = require "windfield"
local GameObject = require "game.object"
local Passenger = require "game.passenger"
local Train = GameObject:extend()

-- The train holds the world
function Train:new()
  self.cart_width = 500
  self.cart_height = 200
  
  self.x = math.floor(love.graphics.getWidth() / 2 - self.cart_width / 2)
  self.y = math.floor(love.graphics.getHeight() / 2 - self.cart_height / 2)

  -------------
  -- Physics --
  -------------
  self.world = wf.newWorld(0, 0, true)

  self.seats = { -- {side, x, dir}
    {0, 3, -1}, {0, 2, -1}, {0, 4, 1}, {0, 6, -1}, {1, 4, -1}
  }

  self.poles = {
    {2, 3}, {2, 9}
  }

  self:setWalls()

  self.passengers = {}
  for i = 0, 10 do
    table.insert(self.passengers, Passenger(love.math.random(self.x + 20, self.x + self.cart_width - 20), love.math.random(self.y + 20, self.y + self.cart_height - 20), self.world))
  end
end

function Train:setWalls()
  local wall_top = self.world:newRectangleCollider(self.x - 5, self.y - 5, self.cart_width + 10, 10)
  wall_top:setType('static')
  local wall_bottom = self.world:newRectangleCollider(self.x - 5, self.y + self.cart_height - 5, self.cart_width + 10, 10)
  wall_bottom:setType('static')
  local wall_left = self.world:newRectangleCollider(self.x - 5, self.y - 5, 10, self.cart_height + 10)
  wall_left:setType('static')
  local wall_right = self.world:newRectangleCollider(self.x + self.cart_width - 5, self.y - 5, 10, self.cart_height + 10)
  wall_right:setType('static')

  for i, pole in ipairs(self.poles) do
    local pole = self.world:newCircleCollider(self.x + self.cart_width * pole[2]/ 12, self.y + self.cart_height * pole[1] / 4, 2)
    pole:setType('static')
  end

  for i, seat in ipairs(self.seats) do
    local seat = self.world:newRectangleCollider(self.x + seat[2] * self.cart_width / 12 - 5, self.y + (self.cart_height * 2 / 3) * seat[1], 10, self.cart_height / 3)
    seat:setType('static')
  end
end

function Train:update(dt)
  self.world:update(dt)
end

function Train:draw()
  love.graphics.push()
  
  local c1x = love.math.noise(love.timer.getTime())
  local c1y = love.math.noise(love.timer.getTime() + 100)
  love.graphics.translate(c1x * 5, c1y * 5)
  self:carriageOutline()

  love.graphics.setLineWidth(0.5)

  self.world:draw()
  love.graphics.pop()

  -- Other carriages

  love.graphics.push()
  local c2x = love.math.noise(love.timer.getTime() + 10)
  local c2y = love.math.noise(love.timer.getTime() + 110)
  love.graphics.translate(- self.cart_width - 80 + c2x * 5, c2y * 5)
  self:carriageOutline()
  love.graphics.pop()

  love.graphics.push()
  local c3x = love.math.noise(love.timer.getTime() + 20)
  local c3y = love.math.noise(love.timer.getTime() + 120)
  love.graphics.translate(c3x * 5 + self.cart_width + 80, c3y * 5)
  self:carriageOutline()
  love.graphics.pop()


end

function Train:carriageOutline()
  love.graphics.setLineWidth(5)
  love.graphics.setColor(139 / 255, 155 / 255, 180 / 255)
  love.graphics.rectangle("fill", self.x, self.y, self.cart_width, self.cart_height)
  love.graphics.setColor(18 / 255, 78 / 255, 137 / 255)
  love.graphics.rectangle("line", self.x, self.y, self.cart_width, self.cart_height)
end

return Train
