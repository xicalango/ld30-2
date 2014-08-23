

Universe = class("Universe")

function Universe:initialize(ship)

	self.planets = {}
	
	for i = 1, 10 do
		local x = love.math.random(0, 2000)
		local y = love.math.random(0, 2000)
		
		local size = love.math.random(10, 200)
		
		table.insert(self.planets, Planet:new( x, y, {size = size, mass = size * 1000} ) )
	end

	self.ship = ship
	
end

function Universe:update(dt, state)
	for i,o in ipairs(self.planets) do
		o:update(dt, state)
	end
	
	self.ship:update(dt, state)
end
