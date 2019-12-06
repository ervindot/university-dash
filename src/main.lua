function love.load()
	g = love.graphics
	k = love.keyboard

	character = require("character")
	background = require("background")
	entities = require("entities")
	hud = require("hud")

	background.load()
	hud.load()
	character.load()

	timer = 30
	distanceTravelled = 0
	distanceRequired = 10000

end

function love.draw()
	background.draw()
	hud.draw(background.x)
	entities.draw()
	character.draw()
end

function love.update(dt)

	if timer > 0 and distanceTravelled < distanceRequired then

		if k.isDown("s") then
			character.study()
		else
			character.notStudy()
		end

		background.update(character.speedX, dt)
		hud.update()
		entities.update(dt, character.speedX)

		if k.isDown("down") then
			character.slide(dt)
		elseif k.isDown("up") then
			character.jump(dt)
		else
			character.noInputNextState(dt)
		end

		timer =  timer - dt

	end
end