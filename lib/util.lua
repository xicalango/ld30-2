function intersectRect( r1x1, r1y1, r1x2, r1y2, r2x1, r2y1, r2x2, r2y2 )
	return not ( 
		r1x2 < r2x1 or 
		r2x2 < r1x1 or
		r2y1 > r1y2 or
		r1y1 > r2y2)
end

function signum( x )
	if x < 0 then
		return -1
	elseif x > 0 then
		return 1
	else
		return 0
	end
end

function dstSq( x1, y1, x2, y2 )
	local dx = x2-x1
	local dy = y2-y1
	return (dx*dx) + (dy*dy)
end

function toPol( x, y )
	return math.sqrt(x*x + y*y), math.atan2(y,x)
end

function toCart( r, phi )
	return r * math.cos(phi), r * math.sin(phi)
end

function dirToCart( dir)
	if dir == "up" then
		return 0, -1
	elseif dir == "down" then
		return 0, 1
	elseif dir == "left" then
		return -1, 0
	elseif dir == "right" then
		return 1, 0
	end
end

function randomDir()
	dirs = {"up", "down", "left", "right"}
	return dirs[love.math.random(1,4)]
end