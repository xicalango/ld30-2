
Ship = Entity:subclass("Ship")

function Ship:initialize( )
	Entity.initialize( self, 0, 0 )
	
	self.ox = 0
	self.oy = 0
	
	self.ax = 0
	self.ay = 0
	
	self.graphics = Graphics:new("assets/rocket.png")
	self.graphics.offset = {30, 30}
	
	self.orbitFn = nil
	self.orbitPos = 0
	
	self.weight = 1
	
	self.letgo = false
	
	self.lastHomePlanet = nil
	self.homePlanet = nil
end

function Ship:update(dt, state)

	if self.homePlanet then
	
		if self.letgo then
			self.letgo = false
			self.lastHomePlanet = self.homePlanet
			self.vx, self.vy = signum(self.x - self.ox) * 200, signum(self.y - self.oy) * 200
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
			if dstSq(self.x, self.y, self.lastHomePlanet.x, self.lastHomePlanet.y) > 100 * 100 then
				self.lastHomePlanet = nil
			end
		end
		
		for i,p in ipairs(state.universe.planets) do
			if p ~= self.lastHomePlanet  and dstSq(self.x, self.y, p.x, p.y) < 100 * 100 then
				self:setHomePlanet(p)
				state:onFoundPlanet(self,p)
				break
			end
		end
		

	end
end

function Ship:setHomePlanet(planet)
	self.homePlanet = planet
	self.orbitFn = planet:orbitFn()
	self.orbitPos = 0
end

function Ship:keypressed(key)
	if key == keyconfig.player[0].letgo then
		self.letgo = true
	end
end
