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


local function resetToFirstImage()
    currentImageIndex = 1 

   
    if giraffeImage then
        giraffeImage:removeSelf()
    end

    
    giraffeImage = display.newImageRect(
        scene.view,
        giraffeImages[currentImageIndex],
        150, 200
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
        150, 200 
    )
    giraffeImage.x = display.contentCenterX
    giraffeImage.y = display.contentHeight - 150
end

-- create()
function scene:create(event)
    local sceneGroup = self.view

    
    local background = display.newImageRect(
        sceneGroup,
        "assets/p3/page3.png", 
        display.contentWidth,
        display.contentHeight
    )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

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
        resetToFirstImage()
    elseif event.phase == "did" then
        local shakeListener = function(event)
            if event.isShake then
                changeImage()
            end
        end

       
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
