

Universe = class("Universe")

function Universe:initialize(ship)

	self.planets = {}
	
	for i = 1, 20 do
		local x = love.math.random(0, 16000)
		local y = love.math.random(0, 12000)
		
		local size = love.math.random(10, 200)

		local money = size * love.math.random(10, 20)
		
		table.insert(self.planets, Planet:new( x, y, {size = size, mass = size * 1000, money = money} ) )
	end

	self.ship = ship
	
	self.connections = {}
	
	self.bigFont = love.graphics.newFont( 200 )
	
end

function Universe:update(dt, state)
	for i,o in ipairs(self.planets) do
		o:update(dt, state)
	end
	
	self.ship:update(dt, state)
end

function Universe:draw(big)
		
	for i,o in ipairs(self.connections) do
		o:draw()
	end
	
		for i,o in ipairs(self.planets) do
			o:draw()
			if big then
				local d = math.floor(math.sqrt(self.ship:dstSqTo(o))/100) * 100
				love.graphics.setColor( 255, 255, 255 )
				local of = love.graphics.getFont()
				love.graphics.setFont(self.bigFont)
				love.graphics.print( "DST: " .. d, o.x + 10, o.y + 10 )
				love.graphics.print( "Money: " .. o.props.money, o.x + 100, o.y + 200 )
				love.graphics.setFont(of)
			end
			
		end
	
	self.ship:draw(self.planets)
end

function Universe:addConnection( begin_point, end_point )
	local c = Connection:new(begin_point, end_point)
	
	table.insert(self.connections, c)
	
	return c
end

function Universe:connectionPresent( a, b )
	for i,c in ipairs(self.connections) do
		if (c.begin_point == a and c.end_point == b) or (c.begin_point == b and c.end_point == a) then
			return true
		end
	end
	
	return false
end
