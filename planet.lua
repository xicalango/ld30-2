

Planet = Entity:subclass("Planet")

function Planet:initialize( x, y, props )

	self.x = x
	self.y = y
	
	self.props = props
	
	self.imageScale = self.props.size/100
	
	self.graphics = Graphics:new("assets/planet1.png")
	self.graphics.scale = {self.imageScale, self.imageScale}
	self.graphics.offset = {50, 50}

end

function Planet:orbitFn()
	return function( pos )
		return self.x + (self.props.size + 10) * math.cos( pos  * math.pi ), self.y + (self.props.size + 10) * math.sin( pos  * math.pi )
	end
end

