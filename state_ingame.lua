

InGameState = GameState:subclass("InGameState")

function InGameState:initialize()
	self.camera = Camera:new(0, 0, 800, 600)
	self.viewport = {x = 0, y = 0, w = love.window.getWidth(), h = love.window.getHeight()}
end

function InGameState:onActivation(universe)
	self.universe = universe
	
	self:onFoundPlanet(self.universe.ship, self.universe.ship.homePlanet)
end

function InGameState:update(dt)
	self.universe:update(dt, self)
	
	self.camera:update(dt)
end

function InGameState:draw()
	self.camera:draw( self.viewport, self.universe )
end

function InGameState:keypressed(key)
	self.universe.ship:keypressed(key)
end

function InGameState:onLetGo(ship)
	self.camera:follow(ship)
	self.camera:zoomDst( 4 )
end

function InGameState:onFoundPlanet(ship, p)
	self.camera:follow(p)
	--self.camera:resetZoom()
	--self.camera:zoomDst( .5 )
end
