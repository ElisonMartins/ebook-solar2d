local composer = require("composer")
local scene = composer.newScene()

local backgroundAudio -- Variável para armazenar o áudio
local audioPlaying = false -- Estado inicial do áudio
local audioControlButton -- Botão de controle de áudio
local birds = {} -- Lista de pássaros

local function dragBird(event)
    local bird = event.target

    if event.phase == "began" then
        display.getCurrentStage():setFocus(bird)
        bird.isFocus = true
        bird.xStart = bird.x
        bird.yStart = bird.y
    elseif event.phase == "moved" and bird.isFocus then
        bird.x = event.x
        bird.y = event.y
    elseif event.phase == "ended" or event.phase == "cancelled" then
        if bird.isFocus then
            display.getCurrentStage():setFocus(nil)
            bird.isFocus = false

            if bird.name == "passaro_grande" and bird.x < display.contentCenterX then
                native.showAlert("Acerto!", "Este ambiente é ideal para pássaros com bicos fortes!", { "OK" })
                bird.x = display.contentCenterX - 80
                bird.y = display.contentCenterY + 30
            elseif bird.name == "passaro_pequeno" and bird.x > display.contentCenterX then
                native.showAlert("Acerto!", "Este ambiente é ideal para pássaros com bicos delicados!", { "OK" })
                bird.x = display.contentCenterX + 80
                bird.y = display.contentCenterY + 30
            else
                transition.to(bird, { x = bird.xStart, y = bird.yStart, time = 300 })
            end
        end
    end
    return true
end

local function resetBirdPositions()
    for _, bird in ipairs(birds) do
        if bird.name == "passaro_grande" then
            bird.x = display.contentCenterX - 100
            bird.y = display.contentHeight - 150
        elseif bird.name == "passaro_pequeno" then
            bird.x = display.contentCenterX + 100
            bird.y = display.contentHeight - 150
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view

    -- Fundo
    local background = display.newImageRect(
        sceneGroup,
        "assets/p5/page5.png",
        display.contentWidth,
        display.contentHeight
    )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Texto de instrução geral
    local instructionText = display.newText({
        parent = sceneGroup,
        text = "Arraste cada pássaro para o ambiente que corresponde ao formato de seu bico. Observe como o bico influencia a capacidade de sobrevivência em diferentes ambientes.",
        x = display.contentCenterX,
        y = 175,
        width = display.contentWidth - 40,
        font = native.systemFont,
        fontSize = 11, -- Tamanho menor
        align = "center",
    })
    instructionText:setFillColor(0, 0, 0)

    -- Ambiente 1
    local environment1 = display.newText({
        parent = sceneGroup,
        text = "Sementes grandes\ne duras no chão.",
        x = display.contentCenterX - 90,
        y = display.contentCenterY - 20,
        font = native.systemFont,
        fontSize = 14,
        align = "center",
    })
    environment1:setFillColor(0, 0, 0)

    -- Ambiente 2
    local environment2 = display.newText({
        parent = sceneGroup,
        text = "Frutas pequenas\nem árvores.",
        x = display.contentCenterX + 90,
        y = display.contentCenterY - 20,
        font = native.systemFont,
        fontSize = 14,
        align = "center",
    })
    environment2:setFillColor(0, 0, 0)

    -- Pássaro 1
    local bird1 = display.newImageRect(sceneGroup, "assets/p5/passaro_grande.png", 80, 80)
    bird1.x = display.contentCenterX - 100
    bird1.y = display.contentHeight - 150
    bird1.name = "passaro_grande"
    bird1:addEventListener("touch", dragBird)
    table.insert(birds, bird1)

    -- Pássaro 2
    local bird2 = display.newImageRect(sceneGroup, "assets/p5/passaro_pequeno.png", 80, 80)
    bird2.x = display.contentCenterX + 100
    bird2.y = display.contentHeight - 150
    bird2.name = "passaro_pequeno"
    bird2:addEventListener("touch", dragBird)
    table.insert(birds, bird2)

    -- Botão Próximo
    local btnNext = display.newImage(sceneGroup, "assets/BtnNext.png")
    btnNext.x = display.contentWidth - 45
    btnNext.y = display.contentHeight - 40
    btnNext:scale(0.5, 0.5)

    btnNext:addEventListener("tap", function(event)
        composer.gotoScene("page06", { effect = "fade" })
    end)

    -- Botão Anterior
    local btnPrev = display.newImage(sceneGroup, "assets/BtnLeft.png")
    btnPrev.x = 45
    btnPrev.y = display.contentHeight - 40
    btnPrev:scale(0.5, 0.5)

    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene("page04", { effect = "fade" })
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

    local audioControlText = display.newText({
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
            audio.stop()
            audioPlaying = false
            audioControlText.text = "Audio Off"
        else
            audio.stop()
            audioPlaying = true
            audioControlText.text = "Audio On"
            audio.play(backgroundAudio, { loops = 0 }) -- Toca o áudio do início
        end
    end)
end

function scene:show(event)
    if event.phase == "will" then
        -- Resetar posições dos pássaros ao entrar na cena
        resetBirdPositions()

        -- Carregar o áudio ao entrar na cena
        backgroundAudio = audio.loadStream("assets/p5/Audio-p5.mp3")
        audioPlaying = false
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
