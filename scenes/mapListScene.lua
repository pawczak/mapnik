local composer = require("composer")
local properties = require("properties")
local lfs = require("lfs")
local widget = require("widget")
local button = require("widget.button")

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

    print("mapDir", properties.mapDir)
    local destDirt

    local doc_path
    if properties.isDevice then
        doc_path = system.pathForFile(nil, properties.mapListBaseDir)
    else
        doc_path = system.pathForFile("mapy/", properties.mapListBaseDir)
    end

    for file in lfs.dir(doc_path) do
        -- file is the current file or directory name
        print("Found file: " .. file)
        if file ~= "." and file ~= ".." then
            table.insert(maps, file)
        end
    end

    local function removeMap(mapIndex)
        print("remove")
        log.table(maps[mapIndex])

        local options = {
            isModal = true,
            effect = "fade",
            time = 500,
            params = {
                mapFileName = maps[mapIndex]
            }
        }

        composer.showOverlay("scenes.removeMapScene", options)
    end

    local function renameMap(mapIndex)
        print("rename")
        log.table(maps[mapIndex])


        local options = {
            isModal = true,
            effect = "fade",
            time = 500,
            params = {
                mapFileName = maps[mapIndex]
            }
        }

        composer.showOverlay("scenes.renameMapScene", options)
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

        local optionsGroup = display.newGroup()
        row:insert(optionsGroup)

        local renameButton, removeButton
        local renameImg, removeImg = display.newRect(0, 0, rowWidth * 0.25, rowHeight), display.newRect(0, 0, rowWidth * 0.25, rowHeight)

        local renameButtonParams = {
            img = renameImg,
            text = "rename map",
            fontSize = properties.mapRowOptionsFontSize,
            font = "arial",
            callback = function(event)
                renameMap(row.index)
            end,
            takeFocus = true,
            dimColor = properties.rowButtonUnclickColor,
            undimColor = properties.rowButtonClickColor
        }
        local removeButtonParams = {
            img = removeImg,
            text = "remove map",
            fontSize = properties.mapRowOptionsFontSize,
            font = "arial",
            callback = function(event)
                removeMap(row.index)
            end,
            takeFocus = true,
            dimColor = properties.rowButtonUnclickColor,
            undimColor = properties.rowButtonClickColor
        }

        renameButton, removeButton = button.new(renameButtonParams), button.new(removeButtonParams)

        optionsGroup:insert(renameButton)

        renameButton.x = renameButton.contentWidth * 0.5

        optionsGroup:insert(removeButton)

        removeButton.x = renameButton.x + removeButton.contentWidth * 0.5 + removeButton.contentWidth * 0.5

        optionsGroup.x = rowWidth - optionsGroup.contentWidth
        optionsGroup.y = optionsGroup.contentHeight * 0.5
    end

    local function onRowTouch(event)
        if event.phase == "release" then
            print("release " .. maps[event.row.index])
            local options = properties.sceneChangeOptions

            options.params = { mapFileName = maps[event.row.index] }

            Runtime:dispatchEvent({ name = properties.eventTypeToggleButton })
            composer.gotoScene("scenes.mapScene", options)
            Runtime:dispatchEvent({ name = properties.eventTypeAddScene, sceneName = properties.mapSceneName })
        end
    end

    -- Create the widget
    local tableView = widget.newTableView
        {
            left = properties.x,
            top = properties.y + listLabel.contentHeight,
            height = properties.height - listLabel.contentHeight,
            width = properties.contentWidth,
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
        Runtime:dispatchEvent({ name = properties.eventTypeToggleButton, value = true })
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