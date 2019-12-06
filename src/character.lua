local g = love.graphics
local k = love.keyboard

local Character = {}

--Movement States:
--sprint 0
--walk 1
--slide 2
--fall 3
--stumble 4

Character.moveState = 1
Character.animState = 0

Character.speedX = 0
Character.speedY = 0


local gravity = 2500
local groundFriction = 0.1

local groundY = 300
Character.x = 300
Character.y = groundY
Character.width = 30
Character.height = 30


Character.studying = false
Character.grounded = true
local moveTimer = 0


local function draw()
    g.setBackgroundColor(1,1,1)
    g.setColor(0,0,0)
    g.rectangle('fill', Character.x, Character.y, Character.width, Character.height)
    g.print(Character.speedY, 20, 20)
    g.print(Character.y, 30,30)
    g.print(string.format("%s", Character.grounded), 40,40)

end

local function canStudy()
    return (Character.moveState == 2 or Character.moveState == 3)
end

local function study()
    return 0
end

local function sprint(deltaTime)
    if Character.grounded then
        if(not Character.moveState == 0) then
            moveTimer = 0
        end
        Character.animState = 0
        Character.moveState = 0

        moveTimer = moveTimer + deltaTime
        Character.speedX = math.max(moveTimer, 5)
    end
end

local function fall(deltaTime, fallSpeed)
    if not Character.grounded then
        Character.animState = 0
        Character.speedY = Character.speedY + gravity * deltaTime * fallSpeed
        Character.y = Character.y + Character.speedY * deltaTime
        if(Character.y > groundY) then
            Character.grounded = true
            Character.speedY = 0
            Character.y = groundY
        end
    end
end

local function walk()
    Character.animState = 0
    Character.moveState = 1
    Character.speedX = 2
end

local function slide(deltaTime)
    if Character.grounded then
        if(not Character.moveState == 2) then
            moveTimer = 0
        end
        Character.animState = 0
        Character.moveState = 2
        moveTimer = moveTimer + deltaTime
        Character.speedX = math.max(Character.speedX - groundFriction * moveTimer, 0)
    elseif not Character.grounded then
        fall(deltaTime, 5)
    end
end

local function jump(deltaTime)
    if Character.grounded then
        Character.animState = 0
        Character.moveState = 3
        Character.speedY = -1000
        Character.grounded = false
        Character.y = groundY + deltaTime * Character.speedY
    end
end

local function stumble()
    Character.animState = 0
    Character.moveState = 4
    Character.speedY = 5
end

local function noInputNextState(dt)
    sprint(dt)
    fall(dt,1)
end

Character.draw = draw
Character.noInputNextState = noInputNextState
Character.slide = slide
Character.jump = jump


return Character




