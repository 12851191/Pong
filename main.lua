WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- size we're trying to emulate with push
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
PADDLE_WIDTH = 8
PADDLE_HEIGHT = 32
PADDLE_SPEED = 140  

BALL_SIZE = 4

push = require 'push'

ball = {
    x = VIRTUAL_WIDTH/2 - BALL_SIZE/2,
    y = VIRTUAL_HEIGHT/2 - BALL_SIZE/2,
    dx = 0, dy = 0
}

player1 = {
    x = 10, y = 10, score = 0
}

player2 = {
    x = VIRTUAL_WIDTH  - 10 - PADDLE_WIDTH, y = VIRTUAL_HEIGHT - PADDLE_HEIGHT - 10, score = 0
}


LARGE_FONT = love.graphics.newFont(32)
SMALL_FONT = love.graphics.newFont(16)

gameState = 'title'


function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)

    ball.dx = math.random(60) + 60
        if math.random(2) == 1 then
            ball.dx = -ball.dx
        end
    ball.dy = math.random(60) + 30
        if math.random (2) == 1 then
            ball.dy = -ball.dy
        end
end

function love.update(dt)
    if gameState == 'play' then
        ball.x = ball.x + ball.dx * dt
        ball.y = ball.y + ball.dy * dt

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end
        if ball.y >= VIRTUAL_HEIGHT - BALL_SIZE then
            ball.y = VIRTUAL_HEIGHT - BALL_SIZE
            ball.dy = -ball.dy
        end

        if ball.x <= 0 then
            player2.score = player2.score + 1
            resetBall()
            gameState = 'serve'
        elseif ball.x >= VIRTUAL_WIDTH - BALL_SIZE then
            player1.score = player1.score + 1
            resetBall()
            gameState = 'serve'
        end

    end
    if love.keyboard.isDown('w') then
        player1.y = player1.y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        player1.y = player1.y + PADDLE_SPEED * dt
    end


    if love.keyboard.isDown('up') then
        player2.y = player2.y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2.y = player2.y + PADDLE_SPEED * dt
    end  


    if collides(player1, ball) then
        ball.dx = -ball.dx
        ball.x = player1.x + PADDLE_WIDTH
    elseif collides(player2, ball) then
        ball.dx = -ball.dx
        ball.x = player2.x - BALL_SIZE
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'enter' or key == 'return' then
        if gameState == 'title' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        end
    end
end

function love.draw()
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    push:start()

    if gameState == 'title' then
        love.graphics.setFont(LARGE_FONT)
        love.graphics.printf('Pong', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf('Press enter to play', 10, VIRTUAL_HEIGHT - 32, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf('Press Enter to serve', 0, 10, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.setFont(LARGE_FONT)
    love.graphics.print(player1.score, VIRTUAL_WIDTH / 2 - 36, VIRTUAL_HEIGHT / 2 - 16)
    love.graphics.print(player2.score, VIRTUAL_WIDTH / 2 + 16, VIRTUAL_HEIGHT / 2 - 16)
    love.graphics.setFont(SMALL_FONT)

    love.graphics.rectangle('fill', ball.x, ball.y, BALL_SIZE, BALL_SIZE)
    love.graphics.rectangle('fill', player1.x, player1.y, PADDLE_WIDTH, PADDLE_HEIGHT)
    love.graphics.rectangle('fill', player2.x, player2.y, PADDLE_WIDTH, PADDLE_HEIGHT)
    push:finish()
end

function resetBall()
    ball.x = VIRTUAL_WIDTH/2 - BALL_SIZE/2
    ball.y = VIRTUAL_HEIGHT/2 - BALL_SIZE/2
    ball.dx = math.random(60) + 60
        if math.random(2) == 1 then
            ball.dx = -ball.dx
        end
    ball.dy = math.random(60) + 30
        if math.random (2) == 1 then
            ball.dy = -ball.dy
        end
    
end

function collides(p, b)
    return not(p.x > b.x  + BALL_SIZE or p.y > b.y + BALL_SIZE or b.x > p.x + PADDLE_WIDTH or b.y > p.y + PADDLE_HEIGHT)
end