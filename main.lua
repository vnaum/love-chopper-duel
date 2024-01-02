
function lerp(a,b,t)
  return a * (1-t) + b * t
end

function inverseLerp(a, b, x)
  return (x-a)/(b-a)
end

function limit(val, absmax)
  if val > absmax then
    return absbax
  elseif val < -absmax then
    return -absmax
  else
    return val
  end
end

player = {}
grav = 5 -- p/s/s
accelx = 5 -- p/s/s
termvelx = 50
termvely = 100

function love.load()
  chopperimg = love.graphics.newImage("chopper.png")
  choppermid = chopperimg:getWidth() / 2

  player.x = 200
  player.y = 100
  player.sx = 0
  player.sy = 0
  player.dir = 1
  player.control = { left="a", right="d", up = "w", fire = "space" }
end

function love.update(dt)
  if love.keyboard.isDown(player.control.left) then
    player.sx = limit(player.sx - accelx * dt, termvelx)
    player.dir = -1
  end

  if love.keyboard.isDown(player.control.right) then
    player.sx = limit(player.sx + accelx * dt, termvelx)
    player.dir = 1
  end

  if love.keyboard.isDown(player.control.up) then
    player.sy = limit(player.sy - accelx * dt, termvely)
  else
    player.sy = limit(player.sy + grav * dt, termvely)
  end

  player.y = player.y + player.sy
  player.x = player.x + player.sx

  -- screen boundaries
  if player.y < 0 or player.y > love.graphics.getHeight() then
    player.sy = -player.sy
  end

  if player.x < 0 or player.x > love.graphics.getWidth() then
    player.sx = -player.sx
  end
end

function love.draw()
  -- love.graphics.print('hgt: '.. love.graphics.getHeight())

  love.graphics.draw(chopperimg, player.x, player.y, 0, player.dir, 1, choppermid, choppermid)
end
