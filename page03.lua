local composer = require( "composer" )
local scene = composer.newScene()

-- create()
function scene:create( event )
    local sceneGroup = self.view

    local bg = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    bg:setFillColor(1, 1, 1)

    local pageText = display.newText({
        parent = sceneGroup,
        text = "Página 03",
        x = display.contentWidth - 60,
        y = 30,
        font = native.systemFontBold,
        fontSize = 24,
    })
    pageText:setFillColor(0, 0, 0)

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
    local btnPrev = display.newImage(sceneGroup, "Assets/BtnLeft.png")
    btnPrev.x = 40  
    btnPrev.y = display.contentHeight - 40 

    btnPrev:scale(0.5, 0.5)
    btnPrev:addEventListener("tap", function(event)
        print("prev")
        composer.gotoScene("page02")
    end)
end

-- Outros eventos da cena, como show(), hide(), destroy(), etc.

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
