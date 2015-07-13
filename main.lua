local composer = require("composer")
local properties = require("properties")
print("isDevice " .. tostring(properties.isDevice))

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

--properties.documentsPath
Runtime:addEventListener(properties.eventTypeResetSceneStack, resetSceneStack)

local function backButton(event)
    if not backButtonEnabled then return true end
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
        composer.gotoScene(prevScene, properties.sceneChangeOptions)
        composer.removeScene(curScene)
        backButtonEnabled = false
        timer.performWithDelay(properties.sceneChangeTime, function()
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

local function doesFileExist(fname, path)

    local results = false

    local filePath = system.pathForFile(fname, path)

    --filePath will be 'nil' if file doesn't exist and the path is 'system.ResourceDirectory'
    if (filePath) then
        filePath = io.open(filePath, "r")
    end

    if (filePath) then
        print("File found: " .. fname)
        --clean up file handles
        filePath:close()
        results = true
    else
        print("File does not exist: " .. fname)
    end

    return results
end

local function copyMap(srcName, srcPath, dstName, dstPath, overwrite)

    --    local params = event.params --event
    local results = false

    local srcPath = doesFileExist(srcName, srcPath)

    if (srcPath == false) then
        return nil -- nil = source file not found
    end

    --check to see if destination file already exists
    if not (overwrite) then
        if (fileLib.doesFileExist(dstName, dstPath)) then
            return 1 -- 1 = file already exists (don't overwrite)
        end
    end

    --copy the source file to the destination file
    local rfilePath = system.pathForFile(srcName, srcPath)
    local wfilePath = system.pathForFile(dstName, dstPath)

    local rfh = io.open(rfilePath, "rb")
    local wfh = io.open(wfilePath, "wb")

    if not (wfh) then
        print("writeFileName open error!")
        return false
    else
        --read the file from 'system.ResourceDirectory' and write to the destination directory
        local data = rfh:read("*a")
        if not (data) then
            print("read error!")
            return false
        else
            if not (wfh:write(data)) then
                print("write error!")
                return false
            end
        end
    end

    results = 2 -- 2 = file copied successfully!

    --clean up file handles
    rfh:close()
    wfh:close()

    return results
end

--
local function copyStartPack()
    --TODO:take maps from some sort of package                              , reapir next line
    local doc_path = system.pathForFile(properties.mapDir, system.DocumentsDirectory)
    local path = system.pathForFile(nil, system.DocumentsDirectory)
    print(path)
    for file in lfs.dir(doc_path) do
        -- file is the current file or directory name
        print("Found file: " .. file)
        if file ~= "." and file ~= ".." then
            print("copy to " .. string.sub(file, 1, string.len(file) - 4))
            copyMap(file, properties.mapDir, string.sub(file, 1, string.len(file) - 4), system.TemporaryDirectory, true)

            --            table.insert(maps, file)
        end
    end
end

if not properties.isDevice then
    copyStartPack()
end





timer.performWithDelay(1000, startApp, 1)



Runtime:addEventListener(properties.eventTypeCopyMap, copyMap)

--copy 'readme.txt' from the 'system.ResourceDirectory' to 'system.DocumentsDirectory'.
--copyFile( "readme.txt", nil, "readme.txt", system.DocumentsDirectory/maps, true )