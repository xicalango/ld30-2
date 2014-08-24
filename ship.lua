
Ship = Entity:subclass("Ship")

function Ship:initialize( )
	Entity.initialize( self, 0, 0 )
	
	self.ox = 0
	self.oy = 0
	
	self.ax = 0
	self.ay = 0
	
	self.graphics = Graphics:new("assets/rocket.png")
	self.graphics.offset = {11, 25}
	
	self.orbitFn = nil
	self.orbitPos = 0
	
	self.weight = 1
	
	self.letgo = false
	
	self.lastPlanet = nil
	self.lastHomePlanet = nil
	self.homePlanet = nil
	
	self.accel = false
	self.rotLeft = false
	self.rotLeft = false
	
	self.rot = -math.pi/2
	
	self.speed = 200
	
	self.rotSpeed = 2
	
	self.fuel = 10
	
	self.firePs = love.graphics.newParticleSystem( love.graphics.newImage("assets/spark.png"), 256 )
	
	self.firePs:setEmitterLifetime(0.1)
	self.firePs:setParticleLifetime(0.5,1)
	self.firePs:setEmissionRate(50)
	self.firePs:setSpread(0.5)
	self.firePs:setSpeed(100, 300)
	self.firePs:setPosition(0, 10)
	self.firePs:setColors( 
		255, 255, 255, 255, 
		255, 255, 0, 255,
		255, 0, 0, 255,
		255, 0, 0, 0 )
	self.firePs:stop()
	
	self.lineLength = 2000
	
	self.boosterForce = 1
	
	self.connection = nil
end

function Ship:update(dt, state)
		
	if self.rotLeft then
		self.rot = self.rot - dt * self.rotSpeed
	elseif self.rotRight then
		self.rot = self.rot + dt * self.rotSpeed
	end

	if self.homePlanet then
	
		if self.letgo then
			self.letgo = false
			self.lastHomePlanet = self.homePlanet
			self.lastPlanet = self.homePlanet
			self.vx, self.vy = signum(self.x - self.ox) * self.speed , signum(self.y - self.oy)  * self.speed
			self.homePlanet = nil
			state:onLetGo(self)
		else
			self.ox, self.oy = self.x, self.y
			self.x, self.y = self.orbitFn( self.orbitPos )
			self.orbitPos = self.orbitPos + dt
		end
	
	else
		
		local forceX = 0
		local forceY = 0
		
		if self.accel and self.fuel >= 1 then
			local dirX, dirY = toCart( self.boosterForce, self.rot )
			forceX = forceX + dirX
			forceY = forceY + dirY
			
			self.firePs:setDirection(self.rot + math.pi)
			self.firePs:start()
			
			self.fuel = self.fuel - dt
		end

		
		for i,p in ipairs(state.universe.planets) do
			local fx = 0
			local fy = 0
			
			local dx, dy = p.x - self.x, p.y - self.y
			
			local n = math.pow(math.sqrt(dx * dx + dy * dy), 3)
			
			fx = p.props.mass * dx / n
			fy = p.props.mass * dy / n
			
			forceX = forceX + fx
			forceY = forceY + fy
		end
		
		self.vx = self.vx + forceX
		self.vy = self.vy + forceY
	
		self.x = self.x + self.vx * dt
		self.y = self.y + self.vy * dt
		
		if self.lastHomePlanet ~= nil then
			if not self.lastHomePlanet:inOrbit(self) then
				self.lastHomePlanet = nil
			end
		end
		
		for i,p in ipairs(state.universe.planets) do
			if p ~= self.lastHomePlanet and p:inOrbit(self) then
				self:setHomePlanet(p)
				state:onFoundPlanet(self,p)
				break
			end
		end
	
		if self.connection:length() >= self.lineLength then
			gameStateManager:changeState(GameOverState, state.universe, state.playerMoney)
		end
	end
	
	self.firePs:update(dt)

			
	self.graphics.rotation = self.rot + math.pi/2
end

function Ship:refuel(n)
	self.fuel = self.fuel + n
end

function Ship:reline(n)
	self.lineLength = self.lineLength + n
end

function Ship:draw(planets)
	love.graphics.draw(self.firePs, self.x, self.y)

	Entity.draw(self)
	
	
	if self.homePlanet == nil then
		--love.graphics.line( self.x, self.y, self.x + self.vx, self.y + self.vy )

		for i,p in ipairs(planets) do
			local r, phi = self:dirTo(p)
			
			if r <= 3000 then
			
				local xx, yy = toCart( r/10, phi )

				love.graphics.setColor(  (255 * (r/3000)), 255 - (255 * (r/3000)), 0, 128)
				love.graphics.line( self.x, self.y, self.x + xx, self.y + yy )
				
				love.graphics.print( math.floor(r),  self.x + xx, self.y + yy)
				
			end
		end

	end
end

function Ship:remainingLength()
	return self.lineLength - self.connection:length()
end

function Ship:setHomePlanet(planet)
	self.homePlanet = planet
	self.orbitFn = planet:orbitFn()
	self.orbitPos = 0
	self.firePs:reset()
end

function Ship:keypressed(key)
	if key ==  keyconfig.player[0].up then
		self.accel = true
	elseif key ==  keyconfig.player[0].left then
		self.rotLeft = true
	elseif key ==  keyconfig.player[0].right then
		self.rotRight = true
	elseif key == keyconfig.player[0].letgo then
		self.letgo = true
	elseif key == "t" then
		self.lineLength = 0
	end
end

function Ship:keyreleased(key)
	if key ==  keyconfig.player[0].up then
		self.accel = false
	elseif key ==  keyconfig.player[0].left then
		self.rotLeft = false
	elseif key ==  keyconfig.player[0].right then
		self.rotRight = false
	end
end
