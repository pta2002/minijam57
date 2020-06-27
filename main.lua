local Control = require "lib.control"
local Map = require "game.map"
local wf = require "windfield"

function love.load()
  love.window.setMode(800, 600, {
    vsync = true,
    msaa = 4
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

  subway_width = 500
  subway_height = 200
  
  subway_x = math.floor(love.graphics.getWidth() / 2 - subway_width / 2)
  subway_y = math.floor(love.graphics.getHeight() / 2 - subway_height / 2)

  player_x = subway_x + 20
  player_y = subway_y + 20


  -------------
  -- Physics --
  -------------
  world = wf.newWorld(0, 0, true)

  -- Walls
  wall_top = world:newRectangleCollider(subway_x - 5, subway_y - 5, subway_width + 10, 10)
  wall_bottom = world:newRectangleCollider(subway_x - 5, subway_y + subway_height - 5, subway_width + 10, 10)
  wall_left = world:newRectangleCollider(subway_x - 5, subway_y - 5, 10, subway_height + 10)
  wall_right = world:newRectangleCollider(subway_x + subway_width - 5, subway_y - 5, 10, subway_height + 10)

  wall_top:setType('static')
  wall_left:setType('static')
  wall_bottom:setType('static')
  wall_right:setType('static')

  -- Player
  player = world:newCircleCollider(player_x, player_y, 10)

  map = Map()
end

function love.update(dt)
  world:update(dt)
  
  player:setLinearVelocity(playerCtl:getAxis("x") * dt * 10000, playerCtl:getAxis("y") * dt * 10000)
end

function love.draw()
  -- love.graphics.circle("fill", player.x, player.y, 10)

  -- Subway cart boundaries!
  -- love.graphics.rectangle("line", subway_x, subway_y, subway_width, subway_height)

  love.graphics.setColor(1,1,1)

  map:draw()
  world:draw()
end

  -- TODO
  -- 1. Mapa em cima com as paragens, tem de ser minimamente realista, fazer scroll
  -- 2. Gráficos do metro de jeito, era fixe se tivesse as paragens mesmo e se mostrasse as outras carruagens
  -- 3. PERSONAGENS
