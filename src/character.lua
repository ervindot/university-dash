local g = love.graphics

local Character = {}

--Movement States:
--sprint 0
--walk 1
--slide 2
--fall 3
--stumble 4

local gravity = 2500
local groundFriction = 1

local groundY = 300



local function load()
    Character.moveState = 1
    Character.animState = 0

    moveTimer = 0


    Character.speedX = 0
    Character.speedY = 0

    Character.x = 300
    Character.y = groundY
    Character.width = 30
    Character.height = 30

    Character.score = 0
    Character.studying = false
    Character.grounded = true
end

local function draw()
    --g.setBackgroundColor(1,1,1)
    g.setColor(1,1,1)
    g.rectangle('fill', Character.x, Character.y, Character.width, Character.height)
    g.print(Character.score, 10, 20)
    g.print(Character.speedX, 10, 30)
    g.print(Character.y, 30,40)
    g.print(string.format("%s", Character.moveState == 2), 40,60)

end

local function canStudy()
    return (Character.moveState == 0 or Character.moveState == 1 or Character.moveState == 2 or Character.moveState == 3)
end

local function study()
    if canStudy() then
        Character.score = Character.score + 1
        studying = true
    end
end

local function notStudy()
    studying = false
end

local function studyWalk()
    Character.animState = 0
    Character.moveState = 1
    Character.speedX = 100
end

local function sprint(deltaTime)
    if Character.grounded and not studying then
        if not (Character.moveState == 0) then
            moveTimer = 0
        end
        Character.animState = 0
        Character.moveState = 0

        moveTimer = moveTimer + deltaTime
        Character.speedX = math.min(Character.speedX + 6-math.min(moveTimer, 6), 600)
    elseif Character.grounded then
        studyWalk()
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

local function slide(deltaTime)
    if Character.grounded then
        if not (Character.moveState == 2) then
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

local function noInputNextState(deltaTime)
    sprint(deltaTime)
    fall(deltaTime,1)
end

local function jump(deltaTime)
    if Character.grounded then
        Character.animState = 0
        Character.moveState = 3
        Character.speedY = -1000
        Character.grounded = false
        Character.y = groundY + deltaTime * Character.speedY
    else
        Character.noInputNextState(deltaTime)
    end
end

local function stumble()
    Character.animState = 0
    Character.moveState = 4
    Character.speedY = 5
end

Character.draw = draw
Character.noInputNextState = noInputNextState
Character.slide = slide
Character.jump = jump
Character.load = load
Character.study = study
Character.notStudy = notStudy

return Character




