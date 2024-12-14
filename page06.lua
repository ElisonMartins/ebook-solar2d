local composer = require("composer")
local scene = composer.newScene()

local backgroundAudio -- Variável para armazenar o áudio
local audioPlaying = false -- Estado inicial do áudio
local audioControlText -- Texto do botão de controle de áudio

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Fundo
    local background = display.newImageRect(
        sceneGroup,
        "assets/p6/page6.png",
        display.contentWidth,
        display.contentHeight
    )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Imagem do DNA
    local dnaImage = display.newImageRect(
        sceneGroup,
        "assets/p6/dna.png",
        150, 150
    )
    dnaImage.x = display.contentCenterX
    dnaImage.y = display.contentCenterY + 50

    -- Texto que será exibido ao dar zoom
    local dnaText = display.newText({
        parent = sceneGroup,
        text = "",
        x = display.contentCenterX,
        y = display.contentCenterY + 200,
        width = display.contentWidth - 40,
        font = native.systemFont,
        fontSize = 14,
        align = "center",
    })
    dnaText:setFillColor(0, 0, 0)

    -- Botão "Próximo"
    local btnNextGroup = display.newGroup()
    local btnNext = display.newImage(btnNextGroup, "assets/BtnNext.png")
    btnNext.x = display.contentWidth - 45
    btnNext.y = display.contentHeight - 40
    btnNext:scale(0.5, 0.5)

    local nextText = display.newText({
        parent = btnNextGroup,
        text = "Próximo",
        x = btnNext.x,
        y = btnNext.y + 25,
        font = native.systemFontBold,
        fontSize = 12,
        align = "center",
    })
    nextText:setFillColor(0, 0, 0)

    btnNextGroup:addEventListener("tap", function(event)
        composer.gotoScene("contraCapa", { effect = "fade" })
    end)
    sceneGroup:insert(btnNextGroup)

    -- Botão "Anterior"
    local btnPrevGroup = display.newGroup()
    local btnPrev = display.newImage(btnPrevGroup, "assets/BtnLeft.png")
    btnPrev.x = 40
    btnPrev.y = display.contentHeight - 40
    btnPrev:scale(0.5, 0.5)

    local prevText = display.newText({
        parent = btnPrevGroup,
        text = "Anterior",
        x = btnPrev.x,
        y = btnPrev.y + 25,
        font = native.systemFontBold,
        fontSize = 12,
        align = "center",
    })
    prevText:setFillColor(0, 0, 0)

    btnPrevGroup:addEventListener("tap", function(event)
        composer.gotoScene("page05")
    end)
    sceneGroup:insert(btnPrevGroup)

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

-- show()
function scene:show(event)
    if event.phase == "will" then
        -- Carregar o áudio ao entrar na cena
        backgroundAudio = audio.loadStream("assets/p6/Audio-p6.mp3")
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

-- Eventos da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
