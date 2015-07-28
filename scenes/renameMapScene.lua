local composer = require("composer")
local properties = require("properties")
local button = require("widget.button")

local scene = composer.newScene()

local fileName, sceneGroup

local function quitScene()
    composer.hideOverlay("fade", 500)
end

local function renameMap(fileName, newFileName)
    print("renaming map " .. fileName .. " " .. " to " .. newFileName)
    if properties.isDevice then
        local destDir = system.TemporaryDirectory
        print(tostring(system.pathForFile(properties.mapTempFileName, destDir)))
        local results, reason = os.rename(system.pathForFile(fileName, destDir),
            system.pathForFile(newFileName, destDir))
        print("reson" .. tostring(reason))
        print("result" .. tostring(results))
        Runtime:dispatchEvent({ name = properties.eventTypeUpdateMapList })
        quitScene()
    else
        print("!!!!!!!!!!!!!!!!! You cannot rename map from simulator !!!!!!!!!!!!!!!!!!!!!")
        quitScene()
    end
end

-- "scene:create()"
function scene:create(event)
    sceneGroup = self.view
    fileName = event.params.mapFileName
    print('removeScene for fileName ' .. fileName)

    local sceneBg = display.newRect(0, 0, properties.width, properties.height)
    sceneBg:setFillColor(0, 0, 0, 0.5)
    sceneGroup:insert(sceneBg)
    sceneBg.x, sceneBg.y = properties.x + sceneBg.contentWidth * 0.5, properties.y + sceneBg.contentHeight * 0.5

    local contentBg = display.newRect(0, 0, properties.width * 0.5, properties.height * 0.2)
    contentBg:setFillColor(0, 0, 0)
    sceneGroup:insert(contentBg)
    contentBg.x, contentBg.y = properties.center.x, properties.center.y

    local renameText = display.newText("Rename " .. fileName, contentBg.x, contentBg.y - contentBg.contentHeight * 0.25, "arial", 20)
    renameText:setFillColor(1, 1, 1)
    sceneGroup:insert(renameText)

    local renameField = native.newTextField(properties.center.x, properties.center.y, contentBg.contentWidth * 0.9, contentBg.contentHeight * 0.2)
    sceneGroup:insert(renameField)
    local function renameListener() end

    renameField:addEventListener("userInput", renameListener)

    local yesButton, noButton, yesImg, noImg
    yesImg = display.newRect(0, 0, contentBg.contentWidth * 0.25, contentBg.contentHeight * 0.2)
    noImg = display.newRect(0, 0, contentBg.contentWidth * 0.25, contentBg.contentHeight * 0.2)

    local yesParams = {
        img = yesImg,
        text = "Rename",
        fontSize = properties.mapRowOptionsFontSize,
        font = "arial",
        callback = function(event)
            renameMap(fileName, renameField.text)
        end,
        takeFocus = true,
        dimColor = properties.removeMapUnclickColor,
        undimColor = properties.removeMapClickColor
    }

    local noParams = {
        img = noImg,
        text = "Cancel",
        fontSize = properties.mapRowOptionsFontSize,
        font = "arial",
        callback = function(event)
            quitScene()
        end,
        takeFocus = true,
        dimColor = properties.removeMapUnclickColor,
        undimColor = properties.removeMapClickColor
    }

    yesButton = button.new(yesParams)
    noButton = button.new(noParams)

    sceneGroup:insert(yesButton)
    yesButton.x, yesButton.y = contentBg.x - contentBg.contentWidth * 0.25, contentBg.y + contentBg.contentHeight * 0.25
    sceneGroup:insert(noButton)
    noButton.x, noButton.y = contentBg.x + contentBg.contentWidth * 0.25, contentBg.y + contentBg.contentHeight * 0.25
end

-- "scene:show()"
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
    elseif (phase == "did") then
        Runtime:dispatchEvent({ name = properties.eventTypeToggleButton, value = true })
    end
end


-- "scene:hide()"
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        print("remove scene will hide")
        Runtime:dispatchEvent({ name = properties.eventTypeToggleButton })
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.

    elseif (phase == "did") then
        Runtime:dispatchEvent({ name = properties.eventTypeToggleButton, value = true })

        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy(event)

    local sceneGroup = self.view
end

-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

-- -------------------------------------------------------------------------------

return scene