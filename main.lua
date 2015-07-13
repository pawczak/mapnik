local composer = require("composer")
local properties = require("properties")
composer.gotoScene("scenes.mainScene")

local backButtonEnabled = true


local function toggleBackButton(value)
    backButtonEnabled = value
end


local function backButton(event)
    if not backButtonEnabled then return end
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print(properties.isDevice)
    print(message)
    if (event.keyName == "back" or not properties.isDevice) and event.phase == "up" then
        local prevScene, curScene = composer.getSceneName("previous"), composer.getSceneName("current")

        if not prevScene then return end
        composer.gotoScene(prevScene)
        composer.removeScene(curScene)
        backButtonEnabled = false
        timer.performWithDelay(1000, function()
            toggleBackButton(true)
        end, 1)
    end
end


Runtime:addEventListener("key", backButton)