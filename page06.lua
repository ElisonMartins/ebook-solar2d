local composer = require("composer")
local scene = composer.newScene()

-- create()
function scene:create(event)
    local sceneGroup = self.view

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
        150, 150 -- 
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

    local previousDistance = 0

    local function calculateDistance(event)
        local dx = event[2].x - event[1].x
        local dy = event[2].y - event[1].y
        return math.sqrt(dx * dx + dy * dy)
    end

    -- Função de pinça
    local function onPinchZoom(event)
        if event.numTouches == 2 then
            if event.phase == "began" then
                previousDistance = calculateDistance(event) -- Salva a distância inicial
            elseif event.phase == "moved" then
                local currentDistance = calculateDistance(event)
                local scale = currentDistance / previousDistance -- Calcula a escala baseada na mudança de distância
                dnaImage:scale(scale, scale)
                previousDistance = currentDistance
            elseif event.phase == "ended" or event.phase == "cancelled" then
                dnaText.text =
                    "Mutações são alterações no material genético. Elas podem ser benéficas, neutras ou prejudiciais, dependendo de como afetam o organismo. Algumas mutações podem gerar novas características vantajosas, enquanto outras podem ser prejudiciais ou não ter impacto significativo."
            end
        end
        return true
    end

    dnaImage:addEventListener("touch", onPinchZoom)

    -- Botão "Next"
    local btnNext = display.newImage(sceneGroup, "assets/BtnNext.png")
    btnNext.x = display.contentWidth - 45
    btnNext.y = display.contentHeight - 40
    btnNext:scale(0.5, 0.5)

    btnNext:addEventListener("tap", function(event)
        print("next")
        composer.gotoScene("contraCapa", { effect = "fade" })
    end)

    -- Botão "Prev"
    local btnPrev = display.newImage(sceneGroup, "assets/BtnLeft.png")
    btnPrev.x = 40
    btnPrev.y = display.contentHeight - 40
    btnPrev:scale(0.5, 0.5)

    btnPrev:addEventListener("tap", function(event)
        print("prev")
        composer.gotoScene("page05")
    end)
end

-- Outros eventos da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
