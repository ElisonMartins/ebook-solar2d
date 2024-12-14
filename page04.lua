local composer = require("composer")
local physics = require("physics")
physics.start()
physics.setGravity(0, 0.5)

local scene = composer.newScene()

local darwin, lamarck
local backgroundAudio -- Variável para armazenar o áudio
local audioPlaying = false -- Estado inicial do áudio
local audioControlText -- Texto do botão de áudio
local rectangleBoundary -- Retângulo delimitador

local function resetPositions()
    darwin.x = display.contentCenterX - 80
    darwin.y = display.contentCenterY + 80
    lamarck.x = display.contentCenterX + 80
    lamarck.y = display.contentCenterY + 80

    darwin:setLinearVelocity(0, 0)
    lamarck:setLinearVelocity(0, 0)
end

function scene:create(event)
    local sceneGroup = self.view

    -- Fundo
    local background = display.newImageRect(
        sceneGroup,
        "assets/p4/page4.png",
        display.contentWidth,
        display.contentHeight
    )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Retângulo delimitador
    rectangleBoundary = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY + 90, 260, 160)
    rectangleBoundary:setFillColor(0, 0, 0, 0.1) -- Retângulo semi-transparente
    rectangleBoundary.strokeWidth = 2
    rectangleBoundary:setStrokeColor(0, 0, 0)

    -- Texto de instrução
    local instructionText = display.newText({
        parent = sceneGroup,
        text = "Toque nas imagens para se chocarem dentro da área.",
        x = rectangleBoundary.x,
        y = rectangleBoundary.y - rectangleBoundary.height / 2 - 10,
        width = rectangleBoundary.width,
        font = native.systemFont,
        fontSize = 11, -- Tamanho menor
        align = "center",
    })
    instructionText:setFillColor(0, 0, 0)

    -- Elementos interativos (Darwin e Lamarck)
    darwin = display.newImageRect(sceneGroup, "assets/p4/darwin.png", 60, 60) -- Tamanho reduzido
    lamarck = display.newImageRect(sceneGroup, "assets/p4/lamarck.png", 60, 60) -- Tamanho reduzido

    physics.addBody(darwin, { radius = 30, bounce = 0.7 })
    physics.addBody(lamarck, { radius = 30, bounce = 0.7 })

    darwin:setLinearVelocity(0, 0)
    lamarck:setLinearVelocity(0, 0)

    -- Paredes internas do retângulo
    local topWall = display.newRect(sceneGroup, rectangleBoundary.x, rectangleBoundary.y - rectangleBoundary.height / 2, rectangleBoundary.width, 10)
    local bottomWall = display.newRect(sceneGroup, rectangleBoundary.x, rectangleBoundary.y + rectangleBoundary.height / 2, rectangleBoundary.width, 10)
    local leftWall = display.newRect(sceneGroup, rectangleBoundary.x - rectangleBoundary.width / 2, rectangleBoundary.y, 10, rectangleBoundary.height)
    local rightWall = display.newRect(sceneGroup, rectangleBoundary.x + rectangleBoundary.width / 2, rectangleBoundary.y, 10, rectangleBoundary.height)

    physics.addBody(topWall, "static")
    physics.addBody(bottomWall, "static")
    physics.addBody(leftWall, "static")
    physics.addBody(rightWall, "static")

    -- Adicionar evento para mover Darwin
    darwin:addEventListener("tap", function()
        darwin:setLinearVelocity(150, math.random(-100, 100))
    end)

    -- Adicionar evento para mover Lamarck
    lamarck:addEventListener("tap", function()
        lamarck:setLinearVelocity(-150, math.random(-100, 100))
    end)

    -- Botão de Controle de Áudio
    local buttonBackground = display.newRect(
        sceneGroup,
        display.contentCenterX,
        display.contentHeight - 40,
        120,
        40
    )
    buttonBackground:setFillColor(0.8, 0.8, 0.8)
    buttonBackground.strokeWidth = 2
    buttonBackground:setStrokeColor(0, 0, 0)

    audioControlText = display.newText({
        parent = sceneGroup,
        text = "Audio Off",
        x = buttonBackground.x,
        y = buttonBackground.y,
        font = native.systemFontBold,
        fontSize = 14,
        align = "center",
    })
    audioControlText:setFillColor(0, 0, 0)

    buttonBackground:addEventListener("tap", function()
        if audioPlaying then
            -- Parar o áudio
            audio.stop()
            audioPlaying = false
            audioControlText.text = "Audio Off"
        else
            -- Reiniciar o áudio do começo
            audio.stop()
            audioPlaying = true
            audioControlText.text = "Audio On"
            audio.play(backgroundAudio, { loops = 0 }) -- Toca o áudio do início, sem loop
        end
    end)

    -- Botão "Próximo"
    local btnNext = display.newGroup()
    local nextButtonBackground = display.newImage(btnNext, "assets/BtnNext.png")
    nextButtonBackground.x = display.contentWidth - 45
    nextButtonBackground.y = display.contentHeight - 40
    nextButtonBackground:scale(0.5, 0.5)
    local nextButtonText = display.newText(btnNext, "Próximo", nextButtonBackground.x, nextButtonBackground.y + 30, native.systemFontBold, 12)
    nextButtonText:setFillColor(0, 0, 0)
    sceneGroup:insert(btnNext)

    btnNext:addEventListener("tap", function(event)
        composer.gotoScene("page05", { effect = "fade" })
    end)

    -- Botão "Anterior"
    local btnPrev = display.newGroup()
    local prevButtonBackground = display.newImage(btnPrev, "assets/BtnLeft.png")
    prevButtonBackground.x = 40
    prevButtonBackground.y = display.contentHeight - 40
    prevButtonBackground:scale(0.5, 0.5)
    local prevButtonText = display.newText(btnPrev, "Anterior", prevButtonBackground.x, prevButtonBackground.y + 30, native.systemFontBold, 12)
    prevButtonText:setFillColor(0, 0, 0)
    sceneGroup:insert(btnPrev)

    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene("page03")
    end)
end

function scene:show(event)
    if event.phase == "will" then
        resetPositions()

        -- Carregar o áudio ao entrar na cena
        backgroundAudio = audio.loadStream("assets/p4/Audio-p4.mp3")
        audioPlaying = false
        audioControlText.text = "Audio Off"
    end
end

function scene:hide(event)
    if event.phase == "will" then
        -- Parar o áudio ao sair da cena
        if audioPlaying then
            audio.stop()
            audioPlaying = false
        end
    end
end

function scene:destroy(event)
    -- Liberar o áudio da memória
    if backgroundAudio then
        audio.dispose(backgroundAudio)
        backgroundAudio = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
