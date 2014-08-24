

TitleState = GameState:subclass("TitleState")

function TitleState:initialize()
	self.image = love.graphics.newImage("assets/yocast.png")
end

function TitleState:draw()
	love.graphics.draw( self.image, 145, 69 )
	
	love.graphics.printf( "You are one of yocast!s employee and your job is to connect all worlds in the universe! Visit different planets and connect them.\n\nPay attention to the length of your line. You can buy supllies at each planet.\n\n Press [space] to start.", 176, 250, 431 )
	
	
end

function TitleState:keypressed(key)
	if key == " " then
		setupNewGame()
	end
end


