function love.load()
	g = love.graphics
	k = love.keyboard
	character = require("character")
	background = require("background")
	entities = require("entities")
	background.load()
end

function love.draw()
	background.draw()
	entities.draw()
	character.draw()
end

function love.update(dt)
	background.update(character.speedX, dt)
	entities.update(dt, character.speedX)
	if k.isDown("down") then
		character.slide(dt)
	elseif k.isDown("up") then
		character.jump(dt)
	else
		character.noInputNextState(dt)
	end
end