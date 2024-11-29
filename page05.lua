local composer = require("composer")
local scene = composer.newScene()

local function dragBird(event)
    local bird = event.target

    if event.phase == "began" then
        display.getCurrentStage():setFocus(bird)
        bird.isFocus = true
        bird.xStart = bird.x
        bird.yStart = bird.y
    elseif event.phase == "moved" and bird.isFocus then
        bird.x = event.x
        bird.y = event.y
    elseif event.phase == "ended" or event.phase == "cancelled" then
        if bird.isFocus then
            display.getCurrentStage():setFocus(nil)
            bird.isFocus = false

            if bird.name == "passaro_grande" and bird.x < display.contentCenterX then
                native.showAlert("Acerto!", "Este ambiente é ideal para pássaros com bicos fortes!", { "OK" })
                bird.x = display.contentCenterX - 80
                bird.y = display.contentCenterY + 30
            elseif bird.name == "passaro_pequeno" and bird.x > display.contentCenterX then
                native.showAlert("Acerto!", "Este ambiente é ideal para pássaros com bicos delicados!", { "OK" })
                bird.x = display.contentCenterX + 80
                bird.y = display.contentCenterY + 30
            else
                transition.to(bird, { x = bird.xStart, y = bird.yStart, time = 300 })
            end
        end
    end
    return true
end

function scene:create(event)
    local sceneGroup = self.view

    local background = display.newImageRect(
        sceneGroup,
        "assets/p5/page5.png",
        display.contentWidth,
        display.contentHeight
    )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local environment1 = display.newText({
        parent = sceneGroup,
        text = "Sementes grandes\ne duras no chão.",
        x = display.contentCenterX - 90,
        y = display.contentCenterY - 20,
        font = native.systemFont,
        fontSize = 14,
        align = "center",
    })
    environment1:setFillColor(0, 0, 0)

    local environment2 = display.newText({
        parent = sceneGroup,
        text = "Frutas pequenas\nem árvores.",
        x = display.contentCenterX + 90,
        y = display.contentCenterY - 20,
        font = native.systemFont,
        fontSize = 14,
        align = "center",
    })
    environment2:setFillColor(0, 0, 0)

    local bird1 = display.newImageRect(sceneGroup, "assets/p5/passaro_grande.png", 80, 80)
    bird1.x = display.contentCenterX - 100
    bird1.y = display.contentHeight - 150
    bird1.name = "passaro_grande"
    bird1:addEventListener("touch", dragBird)

    local bird2 = display.newImageRect(sceneGroup, "assets/p5/passaro_pequeno.png", 80, 80)
    bird2.x = display.contentCenterX + 100
    bird2.y = display.contentHeight - 150
    bird2.name = "passaro_pequeno"
    bird2:addEventListener("touch", dragBird)

    local btnNext = display.newImage(sceneGroup, "assets/BtnNext.png")
    btnNext.x = display.contentWidth - 45
    btnNext.y = display.contentHeight - 40
    btnNext:scale(0.5, 0.5)

    btnNext:addEventListener("tap", function(event)
        composer.gotoScene("page06", { effect = "fade" })
    end)

    local btnPrev = display.newImage(sceneGroup, "assets/BtnLeft.png")
    btnPrev.x = 45
    btnPrev.y = display.contentHeight - 40
    btnPrev:scale(0.5, 0.5)

    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene("page04", { effect = "fade" })
    end)
end

scene:addEventListener("create", scene)

return scene
