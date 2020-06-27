local GameObject = require "game.object"
local Passenger = GameObject:extend()

-- AI Phases
local stop = -1
local goingToMiddle = 0
local walkingThroughMiddle = 1
local goingToSeat = 2
local seatingDown = 3
local goingToPole = 4
local grabbingPole = 5
local goingToLeftDoor = 6
local goingToRightDoor = 7

local function sign(x)
  if x > 0 then
    return 1
  elseif x < 0 then
    return -1
  else
    return 0
  end
end

local function dist2(x, y, x2, y2)
  return math.pow(x - x2, 2) + math.pow(x - y2, 2)
end

function Passenger:new(x, y, train)
  self.train = train
  self.world = train.world

  self.body = self.world:newCircleCollider(x, y, 10)
  self.body:setLinearDamping(0.2)
  self.leavingIn = 2

  self:checkInsideTrain()

  self.middleYmin = self.train.y + self.train.cart_height / 3
  self.middleYmax = self.train.y + self.train.cart_height * 2 / 3
  self.middleY = self.train.y + self.train.cart_height / 2

  self.maxSpeed = love.math.random(5, 200)
end

function Passenger:directionTo(toX, toY)
  local x, y = self.body:getX(), self.body:getY()

  local vecX, vecY = toX - x, toY - y
  local dist = math.sqrt(dist2(x, y, toX, toY))

  return vecX / dist, vecY / dist
end

function Passenger:update(dt)
  if not self.inTrain then
    self:checkInsideTrain()
  end

  if self.inTrain then
    -- We have to route ourselves to a seat...
    -- We set an X and a Y, we also set the phase

    if not self.phase then
      self:findASeat()
      self.phase = goingToMiddle
    end
  end

  self.body:setLinearVelocity(0, 0)

  if self.phase == goingToMiddle then
    -- We keep our x and move up/down
    if self.body:getY() < self.middleYmin or self.body:getY() > self.middleYmax then
      self.body:setLinearVelocity(0, sign(self.middleY - self.body:getY()) * self.maxSpeed)
    else
      -- OK we're at the middle, what now? Well, we go towards our thing!
      if self.goingTo and self.goingTo[1] == "seat" then
        self.phase = walkingThroughMiddle
      else
        self.phase = stop
      end
    end
  end

  if self.phase == walkingThroughMiddle then
    -- We are walking to our seat
    local seatX, seatY = self.train:getSeatEntrance(self.train.seats[self.goingTo[2]])
    local vx, vy = self:directionTo(seatX, seatY)
    self.body:setLinearVelocity(vx * self.maxSpeed, vy * self.maxSpeed)

    -- TODO find another spot if you don't get it!
  end
end

function Passenger:findASeat()
  -- Okay, time to decide what we're going to do!
  -- We have three options:
  -- 1. Find a seat (ideally the closest)
  -- 2. If that fails, find a pole (ideally the closest)
  -- 3. If that fails, stand up, or do something else idk
  local closestFree, closeX, closeY
  for i, seat in ipairs(self.train.seats) do
    local freeSeats = 3 - #self.train.seatsOccupied[i]
    -- TODO this should calculate the seat entrance position!
    local x, y = self.train:getSeatCoords(seat)

    if freeSeats > 0 then
      if not closestFree then
        closestFree = i
        closeX = x
        closeY = y
      else
        if dist2(x, y, self.body:getX(), self.body:getY()) < dist2(closeX, closeY, self.body:getX(), self.body:getY()) then
          closestFree = i
          closeX = x
          closeY = y
        end
      end
    end
  end

  if closestFree then
    -- TODO lock in our position in the seat!
    -- Some will randomly disrespect that!
    -- So you get seat thiefs, which may break out violence or smth idk

    self.goingTo = { "seat", closestFree }
  end
end

function Passenger:draw()
  
end

-- Checks if we are inside the train
function Passenger:checkInsideTrain()
  self.inTrain = self.body:getX() > self.train.x and
    self.body:getY() > self.train.y and
    self.body:getX() < self.train.x + self.train.cart_width and
    self.body:getY() < self.train.y + self.train.cart_height
end

return Passenger
