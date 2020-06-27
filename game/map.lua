local Map = require("lib.classic"):extend()

local streetNames = {
  "Street one",
  "Street two",
  "Somewhere alley",
  "Hah!",
  "That guy's stop",
  "Hello",
  "Welcome to this game :D",
  "Stop #4"
}

function Map:new()
  self.stations = streetNames
  self.currentStation = 1
end

function Map:draw()
  love.graphics.setColor(1, 59 / 255, 68 / 255)

  love.graphics.push()
  
  love.graphics.translate(math.floor(love.graphics.getWidth() / 2 + (self.currentStation - 1) * 400), love.graphics.getHeight() / 6)
  love.graphics.rectangle("fill", 0, -12.5, #self.stations * 400, 25)

  for i, station in ipairs(self.stations) do
    love.graphics.setColor(1, 59 / 255, 68 / 255)
    love.graphics.circle("fill", (i - 1) * 400, 0, 25)
    -- TODO better color!
    love.graphics.setColor(0.8, 0.8, 0.8)
    love.graphics.circle("fill", (i - 1) * 400, 0, 10)

    local tw = font:getWidth(station)
    love.graphics.print(station, math.floor((i - 1) * 400 - tw / 2), -60)
  end

  love.graphics.pop()
end

return Map
