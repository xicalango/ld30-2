

InGameState = GameState:subclass("InGameState")

function InGameState:initialize()
	self.camera = Camera:new(0, 0, 800, 600)
	self.viewport = {x = 0, y = 0, w = love.window.getWidth(), h = love.window.getHeight()}
	
	self.overviewCamera = Camera:new(0, 0, 16000, 12000)
	self.overviewViewport = {x = 0, y = 0, w = 133, h = 100}
	
	self.mapBig = false
end

function InGameState:onActivation(universe)
	self.universe = universe

	self.playerMoney = 1000
	
	self.universe.ship.lastPlanet = self.universe.ship.homePlanet
	self:onFoundPlanet(self.universe.ship, self.universe.ship.homePlanet)
	
	self.mapBig = false
end

function InGameState:update(dt)
	self.universe:update(dt, self)
	
	self.camera:update(dt)
end

function InGameState:draw()
	if not self.mapBig then
		self.camera:draw( self.viewport, self.universe )
		love.graphics.setColor( 255, 255, 255 )
		love.graphics.print( "Fuel: " .. math.floor(self.universe.ship.fuel), 600, 10 )
		love.graphics.print( "Line length: " .. math.floor(self.universe.ship:remainingLength()), 600, 25 )
		love.graphics.print( "Money: " .. math.floor(self.playerMoney), 600, 40 )
	end
	
	if self.universe.ship.homePlanet ~= nil then
		self.overviewCamera:draw( self.overviewViewport, self.universe, self.mapBig )
		if not self.mapBig then
			love.graphics.printf( "Press [M] to see the map.\nPress [L] to buy a line of length 100 (100 money).\nPress [F] to buy 2 units of fuel (100 money).\nPress [B] to buy a booster upgrade.(1000 money)", 300, 470, 360 )
		end
	end
	
	love.graphics.setColor( 255, 255, 255 )
	

end

function InGameState:keypressed(key)
	if self.universe.ship.homePlanet ~= nil then
		if key == "m" then
			self.mapBig = not self.mapBig
			
			if self.mapBig then
				self.overviewViewport.w = love.window.getWidth()
				self.overviewViewport.h = love.window.getHeight()
			else
				self.overviewViewport.w = 133
				self.overviewViewport.h = 100
			end
		
		elseif key == "l" then
			if self.playerMoney >= 100 then
				self.playerMoney = self.playerMoney - 100
				self.universe.ship:reline(200)
			end
		elseif key == "f" then
			if self.playerMoney >= 100 then
				self.playerMoney = self.playerMoney - 100
				self.universe.ship:refuel(2)
			end
		elseif key == "b" then
			if self.playerMoney >= 1000 then
				self.playerMoney = self.playerMoney - 1000
				self.universe.ship.boosterForce = self.universe.ship.boosterForce + 1
			end
		end
	end

	self.universe.ship:keypressed(key)
end

function InGameState:keyreleased(key)
	self.universe.ship:keyreleased(key)
end

function InGameState:onLetGo(ship)
	self.camera:follow(ship)
	self.camera:zoomDst( 2 )
end

function InGameState:onFoundPlanet(ship, p)
	self.camera:follow(p)
	self.camera:zoomDst( 1 )
	
	if ship.lastPlanet ~= p then
		if not self.universe:connectionPresent( p, ship.lastPlanet ) then
			ship.connection.end_point = p
			
			ship.lineLength = ship.lineLength - ship.connection:length()
			if ship.lineLength < 0 then ship.lineLength = p:getOrbitSize() + 10 end
			
			local c = self.universe:addConnection( p, ship )
			ship.connection = c
			
			self.playerMoney = self.playerMoney + p.props.money
		end
	end
	
	ship.connection.begin_point = p
	
end
