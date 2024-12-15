local composer = require("composer")
local scene = composer.newScene()

local dnaImage, dnaText
local backgroundAudio -- Variável para armazenar o áudio
local audioPlaying = false -- Estado inicial do áudio
local audioControlText -- Texto do botão de controle de áudio

system.activate("multitouch") -- Ativa o suporte multitouch

local finger1, finger2
local initialDistance
local isZooming = false
local zoomOccurred = false

local zoomTexts = {
    [1.0] = "O DNA é composto por nucleotídeos organizados em dupla hélice.",
    [2.0] = "Mutações podem gerar características vantajosas ou prejudiciais.",
}

local function calculateDistance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

local function updateZoomText(scale)
    local closestScale = 1.0
    for key, _ in pairs(zoomTexts) do
        if scale >= key then
            closestScale = key
        end
    end
    dnaText.text = zoomTexts[closestScale]
end

local function resetImageScale()
    dnaImage.xScale = 1
    dnaImage.yScale = 1
    dnaText.text = ""
    dnaText.isVisible = false
    zoomOccurred = false -- Reseta o estado de zoom
end

local function onTouch(event)
    if event.phase == "began" then
        if not finger1 then
            finger1 = event
        elseif not finger2 then
            finger2 = event
            isZooming = true
            initialDistance = calculateDistance(finger1.x, finger1.y, finger2.x, finger2.y)
        end
    elseif event.phase == "moved" and isZooming then
        if finger1 and finger2 and event.id == finger1.id then
            finger1 = event
        elseif finger1 and finger2 and event.id == finger2.id then
            finger2 = event
        end

        if finger1 and finger2 then
            local currentDistance = calculateDistance(finger1.x, finger1.y, finger2.x, finger2.y)
            local scale = currentDistance / initialDistance
            local newScaleX = dnaImage.xScale * scale
            local newScaleY = dnaImage.yScale * scale

            -- Limitar escala
            if newScaleX <= 2.5 and newScaleX >= 0.7 then
                dnaImage.xScale = newScaleX
                dnaImage.yScale = newScaleY
                zoomOccurred = true -- Marca que houve um zoom

                -- Atualiza o texto com base no nível de zoom
                updateZoomText(dnaImage.xScale)
                dnaText.isVisible = true
            end

            initialDistance = currentDistance
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        if event.id == finger1.id then
            finger1 = nil
        elseif event.id == finger2.id then
            finger2 = nil
        end

        if not finger1 or not finger2 then
            isZooming = false
        end
    end
    return true
end

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
    dnaImage = display.newImageRect(
        sceneGroup,
        "assets/p6/dna.png",
        150, 150
    )
    dnaImage.x = display.contentCenterX
    dnaImage.y = display.contentCenterY + 50

    -- Texto descritivo (inicialmente invisível)
    dnaText = display.newText({
        parent = sceneGroup,
        text = "",
        x = dnaImage.x,
        y = dnaImage.y + dnaImage.height / 2 + 20,
        width = display.contentWidth - 40,
        font = native.systemFont,
        fontSize = 10,
        align = "center",
    })
    dnaText:setFillColor(0, 0, 0)
    dnaText.isVisible = false

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
    local buttonBackground = display.newRect(sceneGroup, display.contentCenterX, display.contentHeight - 40, 120, 40)
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
            audio.play(backgroundAudio, { loops = 0 })
        end
    end)
end

function scene:show(event)
    if event.phase == "will" then
        Runtime:addEventListener("touch", onTouch)
        backgroundAudio = audio.loadStream("assets/p6/Audio-p6.mp3")
        audioPlaying = false
        audioControlText.text = "Audio Off"
    end
end

function scene:hide(event)
    if event.phase == "will" then
        Runtime:removeEventListener("touch", onTouch)
        resetImageScale() -- Reseta a escala da imagem e o texto ao sair
        if audioPlaying then
            audio.stop()
            audioPlaying = false
        end
    end
end

function scene:destroy(event)
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
