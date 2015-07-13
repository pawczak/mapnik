local composer = require("composer")
composer.gotoScene("scenes.mainScene")

local backButtonEnabled = true


local function toggleBackButton(value)
    backButtonEnabled = value
end


local function backButton(event)
    if not backButtonEnabled then return end
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print(message)
    if event.keyName == "back" and event.phase == "up" then
        local prevScene, curScene = composer.getSceneName("previous"), composer.getSceneName("current")

        composer.goToScene(prevScene)
        composer.remove(curScene)
        backButtonEnabled = false
        timer.performWithDelay(1000, function()
            toggleBackButton(true)
        end, 1)
    end
end


Runtime:addEventListener("key", backButton)