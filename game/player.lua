local GameObject = require "game.object"
local Control = require "lib.control"
local Player = GameObject:extend()

local function clamp(val, min, max)
  return math.max(min, math.min(val, max))
end

function Player:new(train)
  self.train = train

  self.body = train.world:newCircleCollider(train.x + 20, train.y + 20, 10)
  self.body:setCollisionClass('Player')

  self.control = Control:new(1)
  self.control:addAxis("x", {{"a", "left"}, {"d", "right"}}, { {1}, {}, {}})
  self.control:addAxis("y", {{"w", "up"}, {"s", "down"}}, { {2}, {}, {}})

  self.energy = 100

  train.player = self
end

function Player:update(dt)
  self.body:setLinearVelocity(self.control:getAxis("x") * 150, self.control:getAxis("y") * 150)

  if not self:checkInSeat() then
    self.energy = self.energy - 10 * dt
  else
    self.energy = self.energy + 10 * dt
  end


  self.energy = clamp(self.energy, 0, 100)
end

function Player:checkInSeat()
  -- AAAAA, I say, with only a few hours left, and still no gameplay
  local x, y = self.body:getX(), self.body:getY()
  for i, seat in ipairs(self.train.seats) do
    local sx, sy, w, h = seat:getBoundaries()

    local testX = x
    local testY = y

    if x < sx then
      testX = sx
    elseif x > sx + w then
      testX = sx + w
    end

    if y < sy then
      testY = sy
    elseif y > sy + h then
      testY = sy + h
    end

    local distX = x - testX
    local distY = y - testY
    local dist = math.sqrt(distX*distX + distY*distY)

    if dist <= 10 then
      if #seat.occupied < 3 and not self.seat then
        self.seat = seat

        print("A!")
        table.insert(self.seat.occupied, self)

        self.body:setPosition(self.seat:getPosition(#self.seat.occupied))

        return true
      end
    end
  end

  self.seat = nil
  return false
end

function Player:draw()

end

function Player:drawEnergy()
  love.graphics.print(math.floor(self.energy))
end

return Player
