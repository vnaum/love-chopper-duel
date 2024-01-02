
function lerp(a,b,t)
  return a * (1-t) + b * t
end

local function inverseLerp(a, b, x)
  return (x-a)/(b-a)
end

player = {}
grav = 5 -- p/s/s
termvelx = 50
termvely = 100

function love.load()
  chopperimg = love.graphics.newImage("chopper.png")
  choppermid = chopperimg:getWidth() / 2

  player.x = 200
  player.y = 100
  player.dir = 1
  player.control = { left="a", right="d", up = "w" }
end

function love.update(dt)
  if love.keyboard.isDown(player.control.left) then
    player.dir = -1
  end
  if love.keyboard.isDown(player.control.right) then
    player.dir = 1
  end
end

function love.draw()
  love.graphics.print('hgt: '.. love.graphics.getHeight())

  love.graphics.draw(chopperimg, player.x, player.y, 0, player.dir, 1, choppermid, choppermid)
end
