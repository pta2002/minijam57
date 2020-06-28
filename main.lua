local Control = require "lib.control"
local Map = require "game.map"
local Train = require "game.train"

function love.load()
  love.window.setMode(800, 600, {
    vsync = true,
    msaa = 4,
    display = 2
  })
  
  ----------------------
  -- Global Resources --
  ----------------------
  -- TODO this is bad --
  ----------------------
  font = love.graphics.newFont("res/OpenSans-Bold.ttf", 24)
  love.graphics.setFont(font)

  playerCtl = Control:new(1)

  -- TODO d-pad
  Control:addAxis("x", {{"a", "left"}, {"d", "right"}}, { {1}, {}, {}})
  Control:addAxis("y", {{"w", "up"}, {"s", "down"}}, { {2}, {}, {}})

  train = Train()

  player_x = train.x + 20
  player_y = train.y + 20

  -- Player
  player = train.world:newCircleCollider(player_x, player_y, 10)
  player:setCollisionClass('Player')

  map = Map()
end

function love.update(dt)
  train:update(dt)
  
  player:setLinearVelocity(playerCtl:getAxis("x") * 150, playerCtl:getAxis("y") * 150)
end

function love.draw()
  map:draw()
  train:draw()
end

  -- TODO
  -- 1. Mapa em cima com as paragens, tem de ser minimamente realista, fazer scroll
  -- 2. Gráficos do metro de jeito, era fixe se tivesse as paragens mesmo e se mostrasse as outras carruagens
  -- 3. PERSONAGENS
