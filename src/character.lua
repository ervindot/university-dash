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

local groundY = 450

local function loadSprites()

    --jump sprites
    Character.jumpSprite = {}
    for i=0, 3 do
        Character.jumpSprite[i] = g.newImage("resources/jump-" .. i .. ".png")
        Character.jumpSprite[i]:setFilter("nearest", "nearest")
    end

    --jump book sprites
    Character.bookJumpSprite = {}
    for i=0,3 do
        Character.bookJumpSprite[i] = g.newImage("resources/book-jump-" .. i .. ".png")
        Character.bookJumpSprite[i]:setFilter("nearest", "nearest")
    end

    --fall sprites
    Character.fallSprite = {}
    for i=0,1 do
        Character.fallSprite[i] = g.newImage("resources/fall-" .. i .. ".png")
        Character.fallSprite[i]:setFilter("nearest", "nearest")
    end

    --book fall sprites
    Character.bookFallSprite = {}
    for i=0,1 do
        Character.bookFallSprite[i] = g.newImage("resources/book-fall-" .. i .. ".png")
        Character.bookFallSprite[i]:setFilter("nearest", "nearest")
    end

    --book run sprites
    Character.bookRunSprite = {}
    for i=0,5 do
        Character.bookRunSprite[i] = g.newImage("resources/book-run-" .. i .. ".png")
        Character.bookRunSprite[i]:setFilter("nearest", "nearest")
    end

    --run sprites
    Character.runSprite = {}
    for i=0,5 do
        Character.runSprite[i] = g.newImage("resources/run-" .. i .. ".png")
        Character.runSprite[i]:setFilter("nearest", "nearest")
    end

    --slide sprites
    Character.slideSprite = {}
    for i=0,1 do
        Character.slideSprite[i] = g.newImage("resources/slide-" .. i .. ".png")
        Character.slideSprite[i]:setFilter("nearest", "nearest")
    end

    --book slide sprites
    Character.bookSlideSprite = {}
    for i=0,1 do
        Character.bookSlideSprite[i] = g.newImage("resources/book-slide-" .. i .. ".png")
        Character.bookSlideSprite[i]:setFilter("nearest", "nearest")
    end
end

local function load()
    Character.moveState = 1
    Character.animState = 0

    --number of diffrenet images
    Character.runs = 5
    Character.slides = 2
    Character.falls = 2


    -- love.graphocs.newImage("file")
    -- :setFilter("nearest", "nearest")
    loadSprites()

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

    local offset = 65
    local scale = 3
    local delayFactor = 60
    -- regular running
    if (Character.moveState == 0) and not Character.stuyding then
        g.draw(Character.runSprite[math.ceil(Character.animState / delayFactor) % Character.runs],
             Character.x - offset, Character.y-offset, 0, scale, scale)
    -- book running
    elseif Character.moveState == 1 then
        g.draw(Character.bookRunSprite[math.ceil(Character.animState / (delayFactor * 3)) % Character.runs],
             Character.x - offset, Character.y-offset, 0, scale, scale)
    --jump up
    elseif Character.moveState == 3 and Character.speedY < 0 and not Character.studying then
        g.draw(Character.jumpSprite[2],
             Character.x - offset, Character.y-offset, 0, scale, scale)
    
    --jump up study
    elseif Character.moveState == 3 and Character.speedY < 0 and Character.studying then
        g.draw(Character.bookJumpSprite[2],
             Character.x - offset, Character.y-offset, 0, scale, scale)
    
    --fall down    
    elseif Character.moveState == 3 and Character.speedY > 0 and not Character.studying then
        g.draw(Character.fallSprite[math.ceil(Character.animState / delayFactor) % Character.falls],
             Character.x - offset, Character.y-offset, 0, scale, scale)
    
    --fall down study
    elseif Character.moveState == 3 and Character.speedY > 0 and Character.studying then
        g.draw(Character.bookFallSprite[math.ceil(Character.animState / delayFactor) % Character.falls],
             Character.x - offset, Character.y-offset, 0, scale, scale)
    --slide with book
    elseif Character.moveState == 2 and Character.studying then
       g.draw(Character.bookSlideSprite[math.ceil(Character.animState / delayFactor) % Character.slides],
             Character.x - offset, Character.y-offset, 0, scale, scale)
    --slide without book
    elseif Character.moveState == 2 and not Character.studying then
       g.draw(Character.slideSprite[math.ceil(Character.animState / delayFactor) % Character.slides],
             Character.x - offset, Character.y-offset, 0, scale, scale)
    end
 
    --g.rectangle('fill', Character.x, Character.y, Character.width, Character.height)
    --g.print(Character.score, 10, 20)
    --g.print(Character.speedX, 10, 30)
    -- g.print(Character.studying, 30,40)
    g.print(string.format("%s", Character.studying, 40,60))

end

local function canStudy()
    return (Character.moveState == 0 or Character.moveState == 1 or Character.moveState == 2 or Character.moveState == 3)
end

local function study()
    if canStudy() then
        Character.score = Character.score + 1
        Character.studying = true
    end
end

local function notStudy()
    Character.studying = false
end

local function studyWalk()
    Character.animState = Character.animState + 1
    Character.moveState = 1
    Character.speedX = 100
end

local function sprint(deltaTime)
    if Character.grounded and not Character.studying then
        if not (Character.moveState == 0) then
            moveTimer = 0
            animState = 0
        end
        Character.animState = Character.animState + 1
        Character.moveState = 0

        moveTimer = moveTimer + deltaTime
        Character.speedX = math.min(Character.speedX + 6-math.min(moveTimer, 6), 600)
    elseif Character.grounded then
        studyWalk()
    end
end

local function fall(deltaTime, fallSpeed)
    if not Character.grounded then
        Character.animState = Character.animState + 1
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
    Character.speedX = 50
end

Character.draw = draw
Character.stumble = stumble
Character.noInputNextState = noInputNextState
Character.slide = slide
Character.jump = jump
Character.load = load
Character.study = study
Character.notStudy = notStudy

return Character




