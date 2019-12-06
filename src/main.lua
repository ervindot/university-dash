	gameStarted = false

function love.load()

	g = love.graphics
	k = love.keyboard

	timer = 60
	distanceTravelled = 0
	distanceRequired = 20000
	groundY = 450

	character = require("character")
	background = require("background")
	entities = require("entities")
	hud = require("hud")

	background.load()
	hud.load()
	character.load()
	entities.load()

end

function love.draw()
	if gameStarted then
		background.draw()
		hud.draw(character.score, 1000)
		entities.draw()
		character.draw()
	else
		img = love.graphics.newImage("resources/splash.png")
		love.graphics.draw(img, 0, 0)
	end
end

function love.update(dt)

	if gameStarted then

		if timer > 0 and distanceTravelled < distanceRequired then

			if k.isDown("s") then
				character.study(dt)
			else
				character.notStudy()
			end

			background.update(character.speedX, dt)
			hud.update()
			entities.update(dt, character.speedX)

			if entities.checkCollision(character) then
				character.stumble()
			end
			
			if k.isDown("down") then
				character.slide(dt)
			elseif k.isDown("up") then
				character.jump(dt)
			else
				character.noInputNextState(dt)
			end

			timer =  timer - dt

		end

		if k.isDown('r') then
			--gameStarted = false
			love.load()
		end
	else
		if k.isDown('r') then
			gameStarted = true
		end
	end

end