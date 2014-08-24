-- Yocast - #LD30 -- by <weldale@gmail.com>

function love.conf(t)
  t.title = "Yocast"
  t.identity = "Yocast"
  t.author = "Alexander Weld <weldale@gmail.com>"
  t.modules.physics = false -- don't need that

  t.window.width      = 800
  t.window.height     = 600

  t.console = false
end