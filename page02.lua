local composer = require("composer")
local scene = composer.newScene()

local stageImage
local descriptionText
local instructionText

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

    -- Texto de instruções
    instructionText = display.newText({
        parent = sceneGroup,
        text = "Toque em um dos nomes para visualizar a evolução correspondente.",
        x = display.contentCenterX,
        y = display.contentHeight - 150,
        width = display.contentWidth - 40,
        font = native.systemFont,
        fontSize = 14,
        align = "center",
    })
    instructionText:setFillColor(0, 0, 0)

    -- Imagem de estágio
    stageImage = display.newImageRect(sceneGroup, "", 150, 200)
    stageImage.x = display.contentCenterX
    stageImage.y = display.contentCenterY + 60
    stageImage.isVisible = false

    -- Texto de descrição
    descriptionText = display.newText({
        parent = sceneGroup,
        text = "",
        x = display.contentCenterX,
        y = stageImage.y + 120,
        width = display.contentWidth - 40,
        font = native.systemFont,
        fontSize = 14,
        align = "center",
    })
    descriptionText:setFillColor(0, 0, 0)
    descriptionText.isVisible = false

    -- Dados dos estágios
    local stages = {
        { name = "Australopithecus", image = "assets/p2/e1.png", description = "Australopithecus viveu há 4 milhões de anos. Eles eram bípedes e usavam ferramentas rudimentares." },
        { name = "habilis", image = "assets/p2/e2.png", description = "Homo habilis foi um dos primeiros a usar ferramentas há 2 milhões de anos." },
        { name = "erectus", image = "assets/p2/e3.png", description = "Homo erectus viveu há 1.8 milhões de anos e dominava o fogo." },
        { name = "neanderthalensis", image = "assets/p2/e4.png", description = "Os Neandertais viveram na Europa e Ásia há cerca de 400 mil anos." },
        { name = "sapiens", image = "assets/p2/e5.png", description = "Homo sapiens, nossa espécie, evoluiu há cerca de 300 mil anos." },
    }

    -- Configuração dos nomes
    local xStart = 80
    local yStart = stageImage.y - 180
    local rowCount = 0

    for i, stage in ipairs(stages) do
        local stageText = display.newText({
            parent = sceneGroup,
            text = stage.name,
            x = xStart,
            y = yStart,
            font = native.systemFontBold,
            fontSize = 12,
            align = "center",
        })
        stageText:setFillColor(0, 0, 1)

        -- Adicionando interatividade
        stageText:addEventListener("tap", function()
            instructionText.isVisible = false -- Esconde as instruções
            stageImage.fill = { type = "image", filename = stage.image }
            stageImage.isVisible = true
            descriptionText.text = stage.description
            descriptionText.isVisible = true
        end)

        xStart = xStart + 110
        rowCount = rowCount + 1

        if rowCount == 2 and i < #stages then
            xStart = 80
            yStart = yStart + 30
            rowCount = 0
        end
    end

    -- Botão Próximo
    local btnNext = display.newImage(sceneGroup, "assets/BtnNext.png")
    btnNext.x = display.contentWidth - 45
    btnNext.y = display.contentHeight - 40
    btnNext:scale(0.5, 0.5)

    btnNext:addEventListener("tap", function(event)
        instructionText.isVisible = false -- Esconde as instruções
        composer.gotoScene("page03", { effect = "fade" })
    end)

    -- Botão Anterior
    local btnPrev = display.newImage(sceneGroup, "assets/BtnLeft.png")
    btnPrev.x = 40
    btnPrev.y = display.contentHeight - 40
    btnPrev:scale(0.5, 0.5)

    btnPrev:addEventListener("tap", function(event)
        instructionText.isVisible = false -- Esconde as instruções
        composer.gotoScene("Capa")
    end)
end

function scene:show(event)
    local phase = event.phase

    if phase == "will" then
        stageImage.isVisible = false
        descriptionText.isVisible = false
        descriptionText.text = ""
        instructionText.isVisible = true -- Mostra as instruções novamente ao entrar na cena
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)

return scene
