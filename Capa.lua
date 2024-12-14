local composer = require("composer") -- Importa o composer
local scene = composer.newScene() -- Cria uma cena com o composer

local backgroundAudio -- Variável para armazenar o áudio
local audioPlaying = false -- Estado inicial do áudio

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Fundo
    local background = display.newImageRect(
        sceneGroup,
        "assets/capa.png", -- Caminho da imagem
        display.contentWidth, -- Largura da tela
        display.contentHeight -- Altura da tela
    )
    background.x = display.contentCenterX -- Centraliza horizontalmente
    background.y = display.contentCenterY -- Centraliza verticalmente

    -- Botão "Próximo"
    local btnNext = display.newGroup() -- Cria um grupo para o botão e texto
    local nextButtonBackground = display.newImage(btnNext, "assets/BtnNext.png") -- Adiciona a imagem do botão
    nextButtonBackground.x = display.contentWidth - 45
    nextButtonBackground.y = display.contentHeight - 40
    nextButtonBackground:scale(0.5, 0.5)
    local nextButtonText = display.newText(btnNext, "Próximo", nextButtonBackground.x, nextButtonBackground.y + 25, native.systemFontBold, 12) -- Texto abaixo
    nextButtonText:setFillColor(0, 0, 0)
    sceneGroup:insert(btnNext)

    btnNext:addEventListener("tap", function(event)
        composer.gotoScene("page02", { effect = "fade" })
    end)

    -- Botão de Controle de Áudio
    local btnAudioGroup = display.newGroup() -- Cria um grupo para o botão de áudio
    local audioButtonBackground = display.newRect(
        btnAudioGroup,
        80, -- X
        display.contentHeight - 40, -- Y
        80, -- Largura (reduzida)
        30 -- Altura (reduzida)
    )
    audioButtonBackground:setFillColor(0.8, 0.8, 0.8)
    audioButtonBackground.strokeWidth = 1.5 -- Borda mais fina
    audioButtonBackground:setStrokeColor(0, 0, 0)

    local audioControlText = display.newText({
        parent = btnAudioGroup,
        text = "Audio Off",
        x = audioButtonBackground.x,
        y = audioButtonBackground.y,
        font = native.systemFontBold,
        fontSize = 10, -- Texto menor
        align = "center",
    })
    audioControlText:setFillColor(0, 0, 0)

    btnAudioGroup:addEventListener("tap", function()
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

    sceneGroup:insert(btnAudioGroup)
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Carregar o áudio ao entrar na cena
        backgroundAudio = audio.loadStream("assets/capa/Audio-capa.mp3")
        audioPlaying = false
    elseif phase == "did" then
        -- Executado quando a cena aparece completamente
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Parar o áudio ao sair da cena
        if audioPlaying then
            audio.stop()
            audioPlaying = false
        end
    elseif phase == "did" then
        -- Código aqui é executado quando a cena desaparece totalmente
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    -- Liberar o áudio da memória
    if backgroundAudio then
        audio.dispose(backgroundAudio)
        backgroundAudio = nil
    end
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
