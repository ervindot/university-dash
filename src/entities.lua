local g = love.graphics

local Entities = {}

-- A list of the entities we have
Entities.entities = {}

-- Table of entity images
Entities.images = {}

-- create a dicitonary of the entity fields
local function addEntity(posX, posY, speedX, speedY, width, height, imageName, scaleX, scaleY, offsetX, offsetY)
	local entity = {}
	entity.x = posX
	entity.y = posY
	entity.speedX = speedX
	entity.speedY = speedY
	entity.width = width
	entity.height = height
	entity.scaleX = scaleX
	entity.scaleY = scaleY
	entity.offsetX = offsetX
	entity.offsetY = offsetY
	entity.imageName = imageName

	table.insert(Entities.entities, entity)
end

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
local function CheckEntityCollision(entity1, entity2)
  return entity1.x < entity2.x+entity2.width and
         entity2.x < entity1.x+entity1.width and
         entity1.y < entity2.y+entity2.height and
         entity2.y < entity1.y+entity1.height
end

--are there any collisions?
local function checkCollision(player)
	for i=1,#Entities.entities do
		if CheckEntityCollision(Entities.entities[i], player) == true then
			return true
		end
	end
	return false
end

--make it public
Entities.checkCollision = checkCollision

-- draw one particular entity
local function drawEntity(entity)
	--love.graphics.rectangle("fill", entity.x, entity.y, entity.width, entity.height)
	g.draw(Entities.images[entity.imageName], entity.x + entity.offsetX, entity.y + entity.offsetY, 0, entity.scaleX, entity.scaleY)
end

-- main drawing function
local function draw()
	for i=1,#Entities.entities do
		drawEntity(Entities.entities[i])
	end
end

--make it public
Entities.draw = draw

local function updateEntity(entity, dt, vx)
	entity.x = entity.x + entity.speedX * dt - vx * dt
	entity.y = entity.y + entity.speedY * dt
end

local function updateEntities(dt, vx)
	for i=1,#Entities.entities do
		updateEntity(Entities.entities[i], dt, vx)
	end
end

local function load()
	Entities.entities = {}
	Entities.images["cyclist"] = g.newImage("resources/entity-cyclist.png")
	Entities.images["tourists1"] = g.newImage("resources/entity-tourists1.png")
	Entities.images["bird"] = g.newImage("resources/entity-bird.png")

		-- x, y, speedx, speedy, width, height
	addEntity(1000, groundY, 0, 0, 30, 30, "cyclist", 0.15, 0.15, 0, -125)
	addEntity(2000, groundY - 150, -200, 00, 40, 40, "bird", 0.2, 0.2, 0, 0)
	addEntity(3000, groundY, 0, 0, 125, 175, "tourists1", 0.35, 0.35, 0, -125)
	addEntity(4500, groundY, 0, 0, 40, 40, "cyclist", 0.15, 0.15, 0, -125)
	addEntity(5000, groundY, 300, 0, 40, 40, "cyclist", 0.15, 0.15, 0, -125)
	addEntity(7000, groundY, 0, 0, 40, 40, "tourists1", 0.35, 0.35, 0, -125)
	addEntity(9500, groundY - 150, -100, 0, 40, 40, "bird", 0.2, 0.2, 0, 0)
	addEntity(12000, groundY, 0, 0, 40, 40, "tourists1", 0.35, 0.35, 0, -125)
	addEntity(15000, groundY - 150, -150, 0, 40, 40, "bird", 0.2, 0.2, 0, 0)
	addEntity(16000, groundY, 0, 0, 40, 40, "tourists1", 0.35, 0.35, 0, -125)
	addEntity(19000, groundY, -400, 0, 40, 40, "cyclist", 0.15, 0.15, 0, -125)
	addEntity(22000, groundY - 150, 50, 0, 40, 40, "bird", 0.2, 0.2, 0, 0)

end

--make it public
Entities.update = updateEntities
Entities.load = load

-- --------------------------------------------



return Entities