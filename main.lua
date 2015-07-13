local composer = require("composer")
local properties = require("properties")

local backButtonEnabled = true

local sceneStack = {}

local function toggleBackButton(value)
    backButtonEnabled = value
end

local function addScene(event)
    print('add scene ' .. event.sceneName)
    sceneStack[#sceneStack + 1] = event.sceneName
end

Runtime:addEventListener(properties.eventTypeAddScene, addScene)

local function resetSceneStack(event)
    for i = 1, #sceneStack - 1 do
        table.remove(sceneStack, 1)
    end
end

Runtime:addEventListener(properties.eventTypeResetSceneStack, resetSceneStack)

local function backButton(event)
    if not backButtonEnabled then return end
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print(properties.isDevice)
    print(message)
    if (event.keyName == "back" or not properties.isDevice) and event.phase == "up" then

        local prevScene, curScene = nil, composer.getSceneName("current")
        print("#sceneStack " .. #sceneStack)
        for i = 1, #sceneStack do
            print(i .. " " .. sceneStack[i])
        end
        if sceneStack[#sceneStack - 1] then prevScene = sceneStack[#sceneStack - 1]; table.remove(sceneStack) end
        if not prevScene then return end
        print("sceneStackCount" .. #sceneStack .. " prevScene REMOVED" .. prevScene)
        composer.gotoScene(prevScene)
        composer.removeScene(curScene)
        backButtonEnabled = false
        timer.performWithDelay(1000, function()
            toggleBackButton(true)
        end, 1)
    end
    return true
end

Runtime:addEventListener("key", backButton)


local function startApp()
    composer.gotoScene("scenes.mainScene")
    Runtime:dispatchEvent({ name = properties.eventTypeAddScene, sceneName = properties.mainSceneName })
end

timer.performWithDelay(1000, startApp, 1)
