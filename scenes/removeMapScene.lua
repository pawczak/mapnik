local composer = require("composer")
local properties = require("properties")
local button = require("widget.button")

local scene = composer.newScene()

local fileName, sceneGroup

local function removeMap(fileName)
    print("removing " .. fileName)
end

local function quitScene()
    composer.hideOverlay("fade", 500)
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

    local removeText = display.newText("Remove " .. fileName .. "?", contentBg.x, contentBg.y - contentBg.contentHeight * 0.25, "arial", 20)
    removeText:setFillColor(1, 1, 1)
    sceneGroup:insert(removeText)

    local yesButton, noButton, yesImg, noImg
    yesImg = display.newRect(0, 0, contentBg.contentWidth * 0.25, contentBg.contentHeight * 0.2)
    noImg = display.newRect(0, 0, contentBg.contentWidth * 0.25, contentBg.contentHeight * 0.2)

    local yesParams = {
        img = yesImg,
        text = "Yes",
        fontSize = properties.mapRowOptionsFontSize,
        font = "arial",
        callback = function(event)
            removeMap(fileName)
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