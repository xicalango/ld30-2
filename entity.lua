-- Paddle Game - #LD30 -- by <weldale@gmail.com>

Entity = class("Entity")

function Entity:initialize(x, y, state)
	self.x = x or 0
	self.y = y or 0
	
	self.state = state
	
	self.graphics = nil
	
	self.vx = 0
	self.vy = 0
	
	self.remove = false
	
end

function Entity:update(dt) 
end

function Entity:draw()
	if self.graphics then
		self.graphics:draw(self.x, self.y)
	end
end

function Entity:keypressed(key)
	return false
end

function Entity:keyreleased(key)
	return false
end

function Entity:dstSqTo(e)
	return dstSq( e.x - self.x, e.y - self.y )
end