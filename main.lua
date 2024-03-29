
function lerp(a,b,t)
  return a * (1-t) + b * t
end

function inverseLerp(a, b, x)
  return (x-a)/(b-a)
end

-- Generate a random bright RGB color
local function generateRandomColor()
  local r = math.random(0, 255)
  local g = math.random(0, 255)
  local b = math.random(0, 255)

  -- Ensure the color is bright
  local brightness = (r + g + b) / 3
  if brightness < 128 then
    -- Increase the brightness by adding a random value
    local increase = math.random(0, 127)
    r = math.min(r + increase, 255)
    g = math.min(g + increase, 255)
    b = math.min(b + increase, 255)
  end

  return r, g, b
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

players = {}
grav = 5 -- p/s/s
accelx = 5 -- p/s/s
termvelx = 25
termvely = 50
cooldown_time = 0.2 -- 10 bullets each second

bullets = {}
bullet_speed_x = 9

blips = {}

function love.load()
  love.window.setMode(0, 0, {fullscreen=true})

  chopperimg = love.graphics.newImage("chopper.png")
  choppermid = chopperimg:getWidth() / 2

  bulletimg = love.graphics.newImage("bullet.png")
  bulletmid = bulletimg:getWidth() / 2


  -- preload all the blips
  -- Retrieve a list of files and directories in the specified directory
  local items = love.filesystem.getDirectoryItems("blips")

  -- Iterate over the items
  for _, item in ipairs(items) do
    local file_path = "blips/" .. item

    -- Check if the item is a file and ends with ".ogg"
    if love.filesystem.getInfo(file_path, "file") and item:match("%.ogg$") then
      blip = love.audio.newSource(file_path, "static")
      table.insert(blips, blip)
    end
  end

  local player = {}
  player.x = 200
  player.y = 100
  player.sx = 0
  player.sy = 0
  player.dir = 1
  player.color = { love.math.colorFromBytes(255, 10, 10) }
  player.cooldown_left = 0
  player.control = { left="a", right="d", up = "w", fire = "space" }

  table.insert(players, player)

  local player = {}
  player.x = 600
  player.y = 200
  player.sx = 0
  player.sy = 0
  player.dir = -1
  player.cooldown_left = 0
  player.color = { love.math.colorFromBytes(10, 10, 255) }
  player.control = { left="left", right="right", up = "up", fire = "rctrl" }

  table.insert(players, player)
end

function love.update(dt)

  -- update bullets
  for i, bullet in ipairs(bullets) do
    bullet.y = bullet.y + bullet.sy
    bullet.x = bullet.x + bullet.sx
    -- screen boundaries
    if bullet.y < 0 or bullet.y > love.graphics.getHeight() then
      bullet.sy = -bullet.sy
    end

    if bullet.x < 0 or bullet.x > love.graphics.getWidth() then
      bullet.sx = -bullet.sx
    end
  end

  -- update players
  for i, player in ipairs(players) do
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

    if love.keyboard.isDown(player.control.fire) and player.cooldown_left <= 0 then
      -- player.sx = limit(player.sx + accelx * dt, termvelx)

      local bullet = {}
      bullet.x = player.x
      bullet.y = player.y
      bullet.sx = player.sx + bullet_speed_x * player.dir
      bullet.sy = player.sy
      -- bullet.color = player.color
      bullet.color = { love.math.colorFromBytes(generateRandomColor()) }
      table.insert(bullets, bullet)

      player.cooldown_left = cooldown_time

      -- random blip
      local randomIndex = math.random(#blips)
      local randomBlip = blips[randomIndex]
      randomBlip:play()
    end

    -- screen boundaries
    if player.y < 0 or player.y > love.graphics.getHeight() then
      player.sy = -player.sy
    end

    if player.x < 0 or player.x > love.graphics.getWidth() then
      player.sx = -player.sx
    end

    if player.cooldown_left > 0 then
      player.cooldown_left = player.cooldown_left - dt
    end
  end
end

function love.draw()
  -- love.graphics.print('sx: '.. players[1].sx)

  for i, player in ipairs(players) do
    love.graphics.setColor(player.color)
    love.graphics.draw(chopperimg, player.x, player.y, 0, player.dir, 1, choppermid, choppermid)
    love.graphics.reset()
  end

  for i, bullet in ipairs(bullets) do
    love.graphics.setColor(bullet.color)
    love.graphics.draw(bulletimg, bullet.x, bullet.y, 0, bullet.dir, 1, bulletmid, bulletmid)
    love.graphics.reset()
  end
end
