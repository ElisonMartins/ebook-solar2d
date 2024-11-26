local composer = require("composer")
local physics = require("physics")
physics.start()
physics.setGravity(0, 0.5) -- Configura gravidade leve para baixo

local scene = composer.newScene()

-- Variáveis globais para Darwin e Lamarck
local darwin, lamarck

-- Função para reiniciar as posições e velocidades
local function resetPositions()
    -- Reinicia as posições
    darwin.x = 50 -- Darwin começa do lado esquerdo
    darwin.y = display.contentCenterY + 50 -- Posicionado mais abaixo
    lamarck.x = display.contentWidth - 50 -- Lamarck começa do lado direito
    lamarck.y = display.contentCenterY + 50 -- Posicionado mais abaixo

    -- Para qualquer movimento residual
    darwin:setLinearVelocity(0, 0)
    lamarck:setLinearVelocity(0, 0)

    -- Aplica forças iniciais novamente
    darwin:setLinearVelocity(200, 0) -- Move Darwin para a direita
    lamarck:setLinearVelocity(-200, 0) -- Move Lamarck para a esquerda
end

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Background com imagem
    local background = display.newImageRect(
        sceneGroup,
        "assets/p4/page4.png", -- Caminho para o fundo
        display.contentWidth,
        display.contentHeight
    )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Adiciona bordas invisíveis para limitar os objetos na tela
    local topWall = display.newRect(sceneGroup, display.contentCenterX, -10, display.contentWidth, 20)
    local bottomWall = display.newRect(sceneGroup, display.contentCenterX, display.contentHeight + 10, display.contentWidth, 20)
    local leftWall = display.newRect(sceneGroup, -10, display.contentCenterY, 20, display.contentHeight)
    local rightWall = display.newRect(sceneGroup, display.contentWidth + 10, display.contentCenterY, 20, display.contentHeight)

    physics.addBody(topWall, "static")
    physics.addBody(bottomWall, "static")
    physics.addBody(leftWall, "static")
    physics.addBody(rightWall, "static")

    -- Adiciona imagens de Darwin e Lamarck
    darwin = display.newImageRect(sceneGroup, "assets/p4/darwin.png", 100, 100)
    lamarck = display.newImageRect(sceneGroup, "assets/p4/lamarck.png", 100, 100)

    -- Adiciona física aos objetos
    physics.addBody(darwin, { radius = 50, bounce = 0.7 })
    physics.addBody(lamarck, { radius = 50, bounce = 0.7 })

    -- Botão "Next"
    local btnNext = display.newImage(sceneGroup, "assets/BtnNext.png")
    btnNext.x = display.contentWidth - 45
    btnNext.y = display.contentHeight - 40
    btnNext:scale(0.5, 0.5)

    btnNext:addEventListener("tap", function(event)
        print("next")
        composer.gotoScene("page05", { effect = "fade" })
    end)

    -- Botão "Prev"
    local btnPrev = display.newImage(sceneGroup, "assets/BtnLeft.png")
    btnPrev.x = 40
    btnPrev.y = display.contentHeight - 40
    btnPrev:scale(0.5, 0.5)

    btnPrev:addEventListener("tap", function(event)
        print("prev")
        composer.gotoScene("page03")
    end)
end

-- show()
function scene:show(event)
    if event.phase == "will" then
        -- Reinicia posições e velocidades antes de mostrar a cena
        resetPositions()
    end
end

-- hide()
function scene:hide(event)
    if event.phase == "will" then
        -- Para os objetos quando a cena está prestes a sair
        darwin:setLinearVelocity(0, 0)
        lamarck:setLinearVelocity(0, 0)
    end
end

-- Outros eventos da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
