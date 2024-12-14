local composer = require("composer")
local scene = composer.newScene()

local currentImageIndex = 1
local giraffeImages = {
    "assets/p3/girafa1.png",
    "assets/p3/girafa2.png",
    "assets/p3/girafa3.png",
    "assets/p3/girafa4.png"
}
local giraffeImage
local instructionText
local backgroundAudio -- Variável para armazenar o áudio
local audioPlaying = false -- Estado inicial do áudio
local audioControlText -- Texto do botão de áudio

local function resetToFirstImage()
    currentImageIndex = 1 

    if giraffeImage then
        giraffeImage:removeSelf()
    end

    giraffeImage = display.newImageRect(
        scene.view,
        giraffeImages[currentImageIndex],
        150,
        200
    )
    giraffeImage.x = display.contentCenterX
    giraffeImage.y = display.contentHeight - 150 
end

local function changeImage()
    currentImageIndex = currentImageIndex + 1
    if currentImageIndex > #giraffeImages then
        currentImageIndex = 1
    end

    if giraffeImage then
        giraffeImage:removeSelf()
    end

    giraffeImage = display.newImageRect(
        scene.view,
        giraffeImages[currentImageIndex],
        150,
        200 
    )
    giraffeImage.x = display.contentCenterX
    giraffeImage.y = display.contentHeight - 150
end

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Fundo
    local background = display.newImageRect(
        sceneGroup,
        "assets/p3/page3.png", 
        display.contentWidth,
        display.contentHeight
    )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Texto de instruções
    instructionText = display.newText({
        parent = sceneGroup,
        text = "Balance a tela para ver as próximas gerações da girafa.",
        x = display.contentCenterX,
        y = display.contentHeight - 280, -- Posicionando acima da imagem
        width = display.contentWidth - 40,
        font = native.systemFont,
        fontSize = 12,
        align = "center",
    })
    instructionText:setFillColor(0, 0, 0)

    -- Reset da imagem inicial
    resetToFirstImage()

    -- Botão de Controle de Áudio (Botão com borda e texto)
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
        composer.gotoScene("page04", { effect = "fade" })
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
        composer.gotoScene("page02")
    end)
end

-- show()
function scene:show(event)
    if event.phase == "will" then
        -- Carregar o áudio ao entrar na cena
        backgroundAudio = audio.loadStream("assets/p3/Audio-p3.mp3")
        audioPlaying = false
        audioControlText.text = "Audio Off"
    elseif event.phase == "did" then
        local shakeListener = function(event)
            if event.isShake then
                changeImage()
            end
        end

        -- Adiciona o listener para detectar o shake
        Runtime:addEventListener("accelerometer", shakeListener)
        self.shakeListener = shakeListener
    end
end

-- hide()
function scene:hide(event)
    if event.phase == "will" then
        -- Remove o listener do shake ao sair da cena
        if self.shakeListener then
            Runtime:removeEventListener("accelerometer", self.shakeListener)
            self.shakeListener = nil
        end

        -- Parar o áudio ao sair da cena
        if audioPlaying then
            audio.stop()
            audioPlaying = false
        end
    end
end

-- destroy()
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
