

Camera = class("Camera")

function Camera:initialize( x, y, w, h )
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	
	self.baseW = w
	self.baseH = h
	
	self.dw = nil
	self.dh = nil
	
	self.dx = nil
	self.dy = nil
	
	self.followEty = nil
end

function Camera:zoom( f )
	self:setZoom( self.baseW * f, self.baseH * f )
end

function Camera:resetZoom( )
	self:setZoom( self.baseW , self.baseH  )
	self.dw = nil
	self.dh = nil
end

function Camera:zoomDst( f )
	self:setZoomDst( self.baseW * f, self.baseH * f )
end

function Camera:setZoom( w, h )
	self.x = self.x - w / 2
	self.y = self.y - h / 2
	self.w = w
	self.h = h
end

function Camera:setZoomDst( dw, dh )
	self.dw = dw
	self.dh = dh
end

function Camera:midpoint()
	return self.x + self.w / 2, self.y + self.h / 2
end

function Camera:center( x, y )
	self.x = x - self.w / 2
	self.y = y - self.h / 2
end

function Camera:update(dt)
	if self.dw ~= nil and self.dh ~= nil then
		if dstSq(self.w, self.h, self.dw, self.dh) < 1 then
			self:setZoom(self.dw, self.dh)
			self.dw = nil
			self.dh = nil
		else
			local w = self.w + dt * signum(self.dw - self.w) * 800
			local h = self.h + dt * signum(self.dh - self.h) * 600
			
			self:setZoom( w, h )
		end
	end

	if self.followEty then
		self:center( self.followEty.x, self.followEty.y )
	end
end

function Camera:follow( e )
	self.followEty = e
end

function Camera:draw( viewport, universe )
	
	local scaleX = viewport.w / self.w
	local scaleY = viewport.h / self.h
	
	love.graphics.push()
	
	love.graphics.scale( scaleX, scaleY )
	
	love.graphics.translate( -self.x, -self.y )
	love.graphics.translate( viewport.x, viewport.y )
	
	
	for i,o in ipairs(universe.planets) do
		o:draw()
	end
	
	universe.ship:draw()
	
	love.graphics.pop()
	
end


