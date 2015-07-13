local composer = require("composer")
local properties = require("properties")
local lfs = require("lfs")
local widget = require("widget")

local scene = composer.newScene()

local maps = {}

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create(event)

    local sceneGroup = self.view
    local listLabel = display.newGroup()
    local listLabelRect = display.newRect(listLabel, 0, 0, properties.width, properties.labelHeight)
    local listLabelText = display.newText(listLabel, "map list", 0, 0, "arial")
    listLabelRect:setFillColor(0.1, 0.3, 0.5, 0.9)
    sceneGroup:insert(listLabel)

    listLabel.x, listLabel.y = properties.width * 0.5, listLabel.contentHeight * 0.5

    local doc_path = system.pathForFile(properties.mapDir, system.ResourceDirectory)

    for file in lfs.dir(doc_path) do
        -- file is the current file or directory name
        print("Found file: " .. file)
        if file ~= "." and file ~= ".." then
            table.insert(maps, file)
        end
    end


    local function onRowRender(event)

        -- Get reference to the row group
        local row = event.row

        -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
        local rowHeight = row.contentHeight
        local rowWidth = row.contentWidth

        local rowTitle = display.newText(row, maps[row.index], 0, 0, nil, 14)
        rowTitle:setFillColor(0)

        -- Align the label left and vertically centered
        rowTitle.anchorX = 0
        rowTitle.x = 0
        rowTitle.y = rowHeight * 0.5
    end

    local function onRowTouch(event)
        --TODO:goto mapScene with object map to show
        if event.phase == "release" then

            print("release " .. maps[event.row.index])
            local options = {
--                effect = "fade",
--                time = 800,
                params = { mapFileName = maps[event.row.index] }
            }

            composer.gotoScene("scenes.mapScene", options)
        end
    end

    -- Create the widget
    local tableView = widget.newTableView
        {
            left = properties.x,
            top = properties.y + listLabel.contentHeight,
            height = properties.contentWidth,
            width = properties.contentHeight,
            onRowRender = onRowRender,
            onRowTouch = onRowTouch,
            listener = scrollListener
        }

    sceneGroup:insert(tableView)
    -- Insert 40 rows
    for i = 1, #maps do
        -- Insert a row into the tableView
        tableView:insertRow({ mapImg = maps[i] })
    end
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
        local prevScene = composer.getSceneName("previous")
        print(prevScene)
        composer.removeScene(prevScene)
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