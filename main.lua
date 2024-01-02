
function lerp(a,b,t)
  return a * (1-t) + b * t
end

local function inverseLerp(a, b, x)
  return (x-a)/(b-a)
end

player = {}

function love.load()
  chopperimg = love.graphics.newImage("chopper.png")

  player.x = 200
  player.y = 100
end

function love.update(dt)
end

function love.draw()
  love.graphics.print('hgt: '.. love.graphics.getHeight())

  love.graphics.draw(chopperimg, player.x, player.y)
end
