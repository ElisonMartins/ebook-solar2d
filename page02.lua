local composer = require("composer")
local scene = composer.newScene()

-- Variável para armazenar o texto
local infoText

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Fundo
    local background = display.newImageRect(
        sceneGroup,
        "assets/p2/page2.png",
        display.contentWidth,
        display.contentHeight
    )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Texto logo acima da imagem
    infoText = display.newText({
        parent = sceneGroup,
        text = "Toque em uma evolução humana para saber mais:",
        x = display.contentCenterX,
        y = display.contentHeight - 260, -- Ajuste para ficar logo acima da imagem
        width = display.contentWidth - 40,
        font = native.systemFont,
        fontSize = 14, -- Tamanho menor para caber melhor
        align = "center"
    })
    infoText:setFillColor(0, 0, 0)

    -- Imagem na região inferior
    local imageP2 = display.newImageRect(sceneGroup, "assets/p2/imageP2.png", 250, 150)
    imageP2.x = display.contentCenterX
    imageP2.y = display.contentHeight - 150 -- Posição mantida

    -- Adiciona evento de toque na imagem
    imageP2:addEventListener("tap", function(event)
        infoText.text = "Australopithecus: \"O Australopithecus foi um dos primeiros hominídeos que viveram na África cerca de 4 milhões de anos atrás. Eles eram bípedes e usavam ferramentas rudimentares.\""
    end)

    -- Botão "Next"
    local btnNext = display.newImage(sceneGroup, "assets/BtnNext.png")
    btnNext.x = display.contentWidth - 45
    btnNext.y = display.contentHeight - 40
    btnNext:scale(0.5, 0.5)

    btnNext:addEventListener("tap", function(event)
        print("next")
        composer.gotoScene("page03", { effect = "fade" })
    end)

    -- Botão "Prev"
    local btnPrev = display.newImage(sceneGroup, "assets/BtnLeft.png")
    btnPrev.x = 40
    btnPrev.y = display.contentHeight - 40
    btnPrev:scale(0.5, 0.5)

    btnPrev:addEventListener("tap", function(event)
        print("prev")
        composer.gotoScene("Capa")
    end)
end

-- show()
function scene:show(event)
    local phase = event.phase

    if phase == "will" then
        -- Redefine o texto inicial sempre que a cena for mostrada
        if infoText then
            infoText.text = "Toque em uma evolução humana para saber mais:"
        end
    end
end

-- Outros eventos da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
