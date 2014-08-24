

Connection = class("Connection")

function Connection:initialize( begin_point, end_point, max_length )
	self.begin_point = begin_point
	self.end_point = end_point
	self.max_length = max_length
end

function Connection:draw()
	love.graphics.setColor( 255, 255, 255, 255 )
	love.graphics.line( self.begin_point.x, self.begin_point.y, self.end_point.x, self.end_point.y )
end

function Connection:length()
	return math.sqrt(dstSq( self.begin_point.x, self.begin_point.y, self.end_point.x, self.end_point.y ))
end
