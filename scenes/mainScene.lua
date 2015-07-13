local composer = require("composer")
local properties = require("properties")


local scene = composer.newScene()

local buttons = {}

local function onChoosenMapClick(event)
    if event.phase == "ended" then
        composer.gotoScene("scenes.mapListScene")
        Runtime:dispatchEvent({ name = properties.eventTypeAddScene, sceneName = properties.mapListSceneName })
    end
end

local chooseButtonGroup = display.newGroup()
local chooseButtonRect = display.newRect(chooseButtonGroup, 0, 0, properties.mainButtonWidth, properties.mainButtonHeight)
local chooseButtonText = display.newText(chooseButtonGroup, "map list", 0, 0, "arial")
chooseButtonRect:setFillColor(1, 1, 1, 1)
chooseButtonText:setFillColor(0, 0, 0, 1)
chooseButtonRect:toBack()
chooseButtonGroup:addEventListener("touch", onChoosenMapClick)

chooseButtonGroup.x, chooseButtonGroup.y = display.contentCenterX, display.contentCenterY

local function onAddMapClick(event)

    local function onComplete(event)
        --        local userMap = event.target
--        for i = 1, 10 do
--        end
        native.showAlert("Map", "Map added!")
    end

    if media.hasSource(media.PhotoLibrary) then
        media.selectPhoto({ mediaSource = media.PhotoLibrary, destination = { baseDir = properties.documentsPath, fileName = event.target.name, type = "image" }, listener = onComplete })
    else
        native.showAlert("Corona", "This device does not have a photo library.", { "OK" })
    end
end

local addMapButtonGroup = display.newGroup()
local addMapButtonRect = display.newRect(addMapButtonGroup, 0, 0, properties.mainButtonWidth, properties.mainButtonHeight)
local addMapButtonText = display.newText(addMapButtonGroup, "add map", 0, 0, "arial")
addMapButtonRect:setFillColor(1, 1, 1, 1)
addMapButtonText:setFillColor(0, 0, 0, 1)
addMapButtonRect:toBack()
addMapButtonGroup:addEventListener("touch", onAddMapClick)

addMapButtonGroup.x, addMapButtonGroup.y = chooseButtonGroup.x, chooseButtonGroup.y + chooseButtonGroup.contentHeight * 0.5 + addMapButtonGroup.contentHeight * 0.5 + properties.mainSceneBtnDistance

--system.DocumentsDirectory
table.insert(buttons, chooseButtonGroup)
table.insert(buttons, addMapButtonGroup)

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create(event)

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is still off screen (but is about to come on screen).

    elseif (phase == "did") then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif (phase == "did") then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy(event)

    local sceneGroup = self.view
    for i = #buttons, 1, -1 do
        buttons[i]:removeSelf(); buttons[i] = nil
    end
    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

-- -------------------------------------------------------------------------------

return scene