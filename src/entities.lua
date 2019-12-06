local g = love.graphics

local Entities = {}

-- A list of the entities we have
Entities.entities = {}

-- create a dicitonary of the entity fields
local function addEntity(posX, posY, speedX, speedY, width, height)
	local entity = {}
	entity.x = posX
	entity.y = posY
	entity.speedX = speedX
	entity.speedY = speedY
	entity.width = width
	entity.height = height

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
	love.graphics.rectangle("fill", entity.x, entity.y, entity.width, entity.height)
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

--make it public
Entities.update = updateEntities

-- --------------------------------------------
addEntity(500, 50, 0, 0, 10, 30)
addEntity(300, 200, 0, 0, 70, 10)

return Entities