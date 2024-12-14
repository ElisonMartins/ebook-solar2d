local composer = require("composer")
local scene = composer.newScene()

local stageImage
local descriptionText
local instructionText
local audioControlButton
local audioControlText
local audioPlaying = false -- Estado inicial do áudio
local backgroundAudio -- Variável para armazenar o áudio

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

    -- Imagem de estágio (reduzida)
    stageImage = display.newImageRect(sceneGroup, "", 100, 130) -- Tamanho reduzido
    stageImage.x = display.contentCenterX
    stageImage.y = display.contentCenterY + 60
    stageImage.isVisible = false

    -- Texto de descrição (tamanho reduzido)
    descriptionText = display.newText({
        parent = sceneGroup,
        text = "",
        x = display.contentCenterX,
        y = stageImage.y + 80, -- Ajustado para a nova altura da imagem
        width = display.contentWidth - 40,
        font = native.systemFont,
        fontSize = 12, -- Tamanho reduzido
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

    -- Botão de Controle de Áudio (Botão com borda e texto)
    local buttonBackground = display.newRect(
        sceneGroup,
        display.contentCenterX,
        display.contentHeight - 40,
        120,
        40
    )
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
            -- Parar o áudio
            audio.stop()
            audioPlaying = false
            audioControlText.text = "Audio Off"
        else
            -- Reiniciar o áudio do começo
            audio.stop()
            audioPlaying = true
            audioControlText.text = "Audio On"
            audio.play(backgroundAudio, { loops = 0 }) -- Toca o áudio do início, sem loop
        end
    end)

    -- Botão Próximo
    local btnNext = display.newGroup()
    local nextButtonBackground = display.newImage(btnNext, "assets/BtnNext.png")
    nextButtonBackground.x = display.contentWidth - 45
    nextButtonBackground.y = display.contentHeight - 40
    nextButtonBackground:scale(0.5, 0.5)
    local nextButtonText = display.newText(btnNext, "Próximo", nextButtonBackground.x, nextButtonBackground.y + 30, native.systemFontBold, 12)
    nextButtonText:setFillColor(0, 0, 0)
    sceneGroup:insert(btnNext)

    btnNext:addEventListener("tap", function(event)
        composer.gotoScene("page03", { effect = "fade" })
    end)

    -- Botão Anterior
    local btnPrev = display.newGroup()
    local prevButtonBackground = display.newImage(btnPrev, "assets/BtnLeft.png")
    prevButtonBackground.x = 40
    prevButtonBackground.y = display.contentHeight - 40
    prevButtonBackground:scale(0.5, 0.5)
    local prevButtonText = display.newText(btnPrev, "Anterior", prevButtonBackground.x, prevButtonBackground.y + 30, native.systemFontBold, 12)
    prevButtonText:setFillColor(0, 0, 0)
    sceneGroup:insert(btnPrev)

    btnPrev:addEventListener("tap", function(event)
        composer.gotoScene("Capa")
    end)
end

function scene:show(event)
    if event.phase == "will" then
        -- Carregar o áudio ao entrar na cena
        backgroundAudio = audio.loadStream("assets/p2/Audio-p2.mp3")
        audioPlaying = false
        audioControlText.text = "Audio Off"
    end
end

function scene:hide(event)
    if event.phase == "will" then
        -- Parar o áudio ao sair da cena
        if audioPlaying then
            audio.stop()
            audioPlaying = false
        end
    end
end

function scene:destroy(event)
    -- Liberar o áudio da memória
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
