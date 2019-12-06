local Background = {}


local function load()
	love.math.setRandomSeed(os.time())
	Background.x = 0

	Background.images = {}
    Background.images[1] = love.graphics.newImage("resources/background.jpg")
    Background.images[2] = love.graphics.newImage("resources/background2.jpg")
    Background.images[3] = love.graphics.newImage("resources/background3.jpg")

    for i = 4, 15, 1 do
    	Background.images[i] = Background.images[love.math.random(1, 3)]
    end	
    
end

local function update(speed)

	Background.x = Background.x - speed

end

local function draw()

	for i = 1, #Background.images, 1 do
    	love.graphics.draw(Background.images[i], ((i - 1) * Background.images[i]:getWidth()) + Background.x, 0)
    end

end

Background.load = load
Background.update = update
Background.draw = draw

return Background