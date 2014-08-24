-- Paddle Game - #LD30 -- by <weldale@gmail.com>

class = require("lib/middleclass")

require("lib/slam")

require("lib/gamestate")
require("lib/graphics")

require("lib/util")

require("entity")

require("universe")
require("planet")
require("ship")
require("connection")

require("camera")

require("state_ingame")
require("state_gameover")
require("state_title")


keyconfig = require("keyconfig")

global = {
	takeScreenshot = false,
	fullscreen = false
}

function setupNewGame()
	love.graphics.setFont(stdFont)
	
	local ship = Ship:new()
	
	local universe = Universe:new(ship)
	
	ship:setHomePlanet(universe.planets[1])
	
	local c = universe:addConnection( universe.planets[1], ship )
	
	ship.connection = c 
	
	gameStateManager:changeState(InGameState, universe)
end

function love.load()

	stdFont = love.graphics.getFont()

	gameStateManager = GameStateManager:new()
	
	gameStateManager:registerState(InGameState)
	gameStateManager:registerState(GameOverState)
	gameStateManager:registerState(TitleState)

	gameStateManager:changeState(TitleState)
end


function love.draw()
	gameStateManager:draw()
	
	if global.takeScreenshot then
		global.takeScreenshot = false
		local screenshot = love.graphics.newScreenshot()
		screenshot:encode( "pg_" .. love.timer.getTime() .. ".png" )
	end
end

function love.update(dt)
	gameStateManager:update(dt)
end

function love.keypressed(key)
	if key == "f12" then
		global.takeScreenshot = true
  	elseif key == "f5" then
    	if love.window.setFullscreen(not fullscreen, "desktop") then
			fullscreen = not fullscreen
		end
	elseif key == "escape" then
		love.event.push('quit')
	end

	gameStateManager:keypressed(key)
end

function love.keyreleased(key)
	gameStateManager:keyreleased(key)
end
