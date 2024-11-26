local composer = require("composer")
local scene = composer.newScene()

-- Variáveis para controle da imagem
local currentImageIndex = 1
local giraffeImages = {
    "assets/p3/girafa1.png",
    "assets/p3/girafa2.png",
    "assets/p3/girafa3.png",
    "assets/p3/girafa4.png"
}
local giraffeImage

-- Função para redefinir a imagem para a primeira
local function resetToFirstImage()
    currentImageIndex = 1 -- Reinicia o índice para a primeira imagem

    -- Remove a imagem atual, se existir
    if giraffeImage then
        giraffeImage:removeSelf()
    end

    -- Exibe a primeira imagem
    giraffeImage = display.newImageRect(
        scene.view,
        giraffeImages[currentImageIndex],
        150, 200 -- Dimensões da imagem: altura maior que largura
    )
    giraffeImage.x = display.contentCenterX
    giraffeImage.y = display.contentHeight - 150 -- Mesma posição da imagem no p2
end

-- Função para alternar a imagem da girafa
local function changeImage()
    currentImageIndex = currentImageIndex + 1
    if currentImageIndex > #giraffeImages then
        currentImageIndex = 1
    end

    -- Remove a imagem atual, se existir
    if giraffeImage then
        giraffeImage:removeSelf()
    end

    -- Exibe a nova imagem
    giraffeImage = display.newImageRect(
        scene.view,
        giraffeImages[currentImageIndex],
        150, 200 -- Dimensões da imagem: altura maior que largura
    )
    giraffeImage.x = display.contentCenterX
    giraffeImage.y = display.contentHeight - 150 -- Mesma posição da imagem no p2
end

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Background com imagem
    local background = display.newImageRect(
        sceneGroup,
        "assets/p3/page3.png", -- Caminho para a imagem de fundo
        display.contentWidth,
        display.contentHeight
    )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- Inicializa com a primeira imagem da girafa
    resetToFirstImage()

    -- Botão "Next"
    local btnNext = display.newImage(sceneGroup, "assets/BtnNext.png")
    btnNext.x = display.contentWidth - 45
    btnNext.y = display.contentHeight - 40
    btnNext:scale(0.5, 0.5)

    btnNext:addEventListener("tap", function(event)
        print("next")
        composer.gotoScene("page04", { effect = "fade" })
    end)

    -- Botão "Prev"
    local btnPrev = display.newImage(sceneGroup, "assets/BtnLeft.png")
    btnPrev.x = 40
    btnPrev.y = display.contentHeight - 40
    btnPrev:scale(0.5, 0.5)

    btnPrev:addEventListener("tap", function(event)
        print("prev")
        composer.gotoScene("page02")
    end)
end

-- show()
function scene:show(event)
    if event.phase == "will" then
        -- Reseta para a primeira imagem antes de mostrar a cena
        resetToFirstImage()
    elseif event.phase == "did" then
        -- Adiciona listener para detectar o shake
        local shakeListener = function(event)
            if event.isShake then
                changeImage() -- Troca de imagem ao detectar o shake
            end
        end

        -- Salva a referência ao listener para removê-lo depois
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
    end
end

-- Outros eventos da cena
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
