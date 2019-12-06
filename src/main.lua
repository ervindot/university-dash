function love.load()
	g = love.graphics
	k = love.keyboard
	character = require("character")

end

function love.draw()
	character.draw()
end

function love.update(dt)
	if k.isDown("down") then
		character.slide(dt)
	elseif k.isDown("up") then
		character.jump(dt)
	else
		character.noInputNextState(dt)
	end
end