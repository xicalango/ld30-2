

GameOverState = GameState:subclass("GameOverState")

function GameOverState:initialize()
	self.camera = Camera:new(0, 0, 16000, 12000)
	self.viewport = {x = 0, y = 0, w = love.window.getWidth(), h = love.window.getHeight()}
	
	self.bigFont = love.graphics.newFont(72)
	self.smallFont = love.graphics.newFont(48)
end

function GameOverState:onActivation(universe, money)
	self.universe = universe
	self.money = money
	self.universe.ship.homePlanet = self.universe.ship.lastPlanet
end

function GameOverState:draw()
	self.camera:draw( self.viewport, self.universe )
	
	love.graphics.setFont(self.bigFont)
	
	love.graphics.print( "GameOver", 200, 145 )
	
	love.graphics.setFont(self.smallFont)
	
	love.graphics.print( "Connected worlds: " .. #self.universe.connections - 1, 130, 320)
	love.graphics.print( "Money: " .. self.money - 1, 130,400)

	love.graphics.setFont(stdFont)
	
	love.graphics.printf( "Press [Space] to restart.\nPress [Esc] to quit.", 130,469, 200)
	
end

function GameOverState:keypressed(key)
	if key == " " then
		setupNewGame()
	else
		print(love.mouse.getPosition())
	end
end
