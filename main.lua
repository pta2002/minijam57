local Map = require "game.map"
local Player = require "game.player"
local Train = require "game.train"

function love.load()
  love.window.setMode(800, 600, {
    vsync = true,
    msaa = 4,
    display = 2,
  })
  
  ----------------------
  -- Global Resources --
  ----------------------
  -- TODO this is bad --
  ----------------------
  font = love.graphics.newFont("res/OpenSans-Bold.ttf", 24)
  love.graphics.setFont(font)

  train = Train()

  map = Map()

  player = Player(train)
end

function love.update(dt)
  train:update(dt)
  player:update(dt)
end

function love.draw()
  map:draw()

  train:draw()

  player:drawEnergy()
end

  -- TODO
  -- 1. Mapa em cima com as paragens, tem de ser minimamente realista, fazer scroll
  -- 2. Gráficos do metro de jeito, era fixe se tivesse as paragens mesmo e se mostrasse as outras carruagens
  -- 3. PERSONAGENS
