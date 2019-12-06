local Hud = {}

local function load()

    Hud.font = love.graphics.newFont("resources/kindergarten.ttf", 30)

end

local function update()

end

local function draw(score, maxScore)

    -- Timer
    love.graphics.setFont(Hud.font)
    love.graphics.print('TIME: ' .. math.abs(math.ceil(timer)), 20, 60)


    -- Distance progress bar
    love.graphics.print('DISTANCE: ', 20, 20)

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', 175, 20, 150, 30)

    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle('fill', 176, 21, (distanceTravelled / distanceRequired) * 148, 28)


    -- Studying progress bar
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('STUDYING: ', 475, 20)

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', 630, 20, 150, 30)

    if score < maxScore/3 then
        love.graphics.setColor(1, 0, 0)
    elseif score > maxScore*2/3 then
        love.graphics.setColor(0, 1, 0)
    else
        love.graphics.setColor(1, 1, 0)
    end
    
    love.graphics.rectangle('fill', 631, 21, math.min(score/maxScore*148, 148), 28)

    love.graphics.setColor(0, 0, 0)
    love.graphics.line(680, 20, 680, 50)
    love.graphics.line(730, 20, 730, 50)

    love.graphics.setColor(1, 1, 1)

end

Hud.load = load
Hud.update = update
Hud.draw = draw

return Hud