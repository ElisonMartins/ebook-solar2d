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
        "assets/ContraCapa.png", -- Caminho da imagem
        display.contentWidth, -- Largura da tela
        display.contentHeight -- Altura da tela
    )
    background.x = display.contentCenterX -- Centraliza horizontalmente
    background.y = display.contentCenterY -- Centraliza verticalmente

    -- Botão "Anterior"
    local btnPrev = display.newGroup() -- Cria um grupo para o botão e texto
    local prevButtonBackground = display.newImage(btnPrev, "assets/BtnLeft.png") -- Adiciona a imagem do botão
    prevButtonBackground.x = 45
    prevButtonBackground.y = display.contentHeight - 40
    prevButtonBackground:scale(0.5, 0.5)
    local prevButtonText = display.newText(btnPrev, "Anterior", prevButtonBackground.x, prevButtonBackground.y + 25, native.systemFontBold, 12) -- Texto abaixo
    prevButtonText:setFillColor(0, 0, 0)
    sceneGroup:insert(btnPrev)

    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene("page05", { effect = "fade" })
    end)

    -- Botão de Controle de Áudio
    local btnAudioGroup = display.newGroup() -- Cria um grupo para o botão de áudio
    local audioButtonBackground = display.newRect(
        btnAudioGroup,
        display.contentWidth - 60, -- X
        display.contentHeight - 40, -- Y
        80, -- Largura
        30 -- Altura
    )
    audioButtonBackground:setFillColor(0.8, 0.8, 0.8)
    audioButtonBackground.strokeWidth = 1.5 -- Borda
    audioButtonBackground:setStrokeColor(0, 0, 0)

    local audioControlText = display.newText({
        parent = btnAudioGroup,
        text = "Audio Off",
        x = audioButtonBackground.x,
        y = audioButtonBackground.y,
        font = native.systemFontBold,
        fontSize = 10,
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

    -- Botão "Voltar para capa"
    local btnHome = display.newGroup() -- Cria um grupo para o botão e texto
    local homeButtonBackground = display.newImage(btnHome, "assets/Home.png") -- Adiciona a imagem do botão
    homeButtonBackground.x = display.contentWidth - 45
    homeButtonBackground.y = 40
    homeButtonBackground:scale(0.5, 0.5)
    local homeButtonText = display.newText(btnHome, "Voltar para capa", homeButtonBackground.x, homeButtonBackground.y + 25, native.systemFontBold, 12) -- Texto abaixo
    homeButtonText:setFillColor(0, 0, 0)
    sceneGroup:insert(btnHome)

    btnHome:addEventListener("tap", function(event)
        composer.gotoScene("capa", { effect = "fade" })
    end)
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Carregar o áudio ao entrar na cena
        backgroundAudio = audio.loadStream("assets/contracapa/Audio-contracapa.mp3")
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
