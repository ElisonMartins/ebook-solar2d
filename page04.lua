local composer = require("composer")
local physics = require("physics")
physics.start()
physics.setGravity(0, 0.5)

local scene = composer.newScene()

local darwin, lamarck

local function resetPositions()
    darwin.x = 50
    darwin.y = display.contentCenterY + 50
    lamarck.x = display.contentWidth - 50
    lamarck.y = display.contentCenterY + 50

    darwin:setLinearVelocity(0, 0)
    lamarck:setLinearVelocity(0, 0)

    darwin:setLinearVelocity(200, 0)
    lamarck:setLinearVelocity(-200, 0)
end

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImageRect(
        sceneGroup,
        "assets/p4/page4.png",
        display.contentWidth,
        display.contentHeight
    )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local topWall = display.newRect(sceneGroup, display.contentCenterX, -10, display.contentWidth, 20)
    local bottomWall = display.newRect(sceneGroup, display.contentCenterX, display.contentHeight + 10, display.contentWidth, 20)
    local leftWall = display.newRect(sceneGroup, -10, display.contentCenterY, 20, display.contentHeight)
    local rightWall = display.newRect(sceneGroup, display.contentWidth + 10, display.contentCenterY, 20, display.contentHeight)

    physics.addBody(topWall, "static")
    physics.addBody(bottomWall, "static")
    physics.addBody(leftWall, "static")
    physics.addBody(rightWall, "static")

    darwin = display.newImageRect(sceneGroup, "assets/p4/darwin.png", 100, 100)
    lamarck = display.newImageRect(sceneGroup, "assets/p4/lamarck.png", 100, 100)

    physics.addBody(darwin, { radius = 50, bounce = 0.7 })
    physics.addBody(lamarck, { radius = 50, bounce = 0.7 })

    local btnNext = display.newImage(sceneGroup, "assets/BtnNext.png")
    btnNext.x = display.contentWidth - 45
    btnNext.y = display.contentHeight - 40
    btnNext:scale(0.5, 0.5)

    btnNext:addEventListener("tap", function(event)
        composer.gotoScene("page05", { effect = "fade" })
    end)

    local btnPrev = display.newImage(sceneGroup, "assets/BtnLeft.png")
    btnPrev.x = 40
    btnPrev.y = display.contentHeight - 40
    btnPrev:scale(0.5, 0.5)

    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene("page03")
    end)
end

function scene:show(event)
    if event.phase == "will" then
        resetPositions()
    end
end

function scene:hide(event)
    if event.phase == "will" then
        darwin:setLinearVelocity(0, 0)
        lamarck:setLinearVelocity(0, 0)
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
