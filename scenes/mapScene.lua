local composer = require("composer")
local properties = require("properties")

local scene = composer.newScene()

local fileNam, sceneGroup
-- scaling

-- turn on multitouch
system.activate("multitouch")

-- which environment are we running on?
local isDevice = properties.isDevice










-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create(event)
    sceneGroup = self.view
    fileName = event.params.mapFileName
    print('saving fileName ' .. fileName)
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

local function createMapObj(mapFileName)
    -- returns the distance between points a and b
    function lengthOf(a, b)
        local width, height = b.x - a.x, b.y - a.y
        return (width * width + height * height) ^ 0.5
    end

    -- calculates the average centre of a list of points
    local function calcAvgCentre(points)
        local x, y = 0, 0

        for i = 1, #points do
            local pt = points[i]
            x = x + pt.x
            y = y + pt.y
        end

        return { x = x / #points, y = y / #points }
    end

    -- calculate each tracking dot's distance and angle from the midpoint
    local function updateTracking(centre, points)
        for i = 1, #points do
            local point = points[i]

            point.prevDistance = point.distance

            point.distance = lengthOf(centre, point)
        end
    end

    -- calculates scaling amount based on the average change in tracking point distances
    local function calcAverageScaling(points)
        local total = 0

        for i = 1, #points do
            local point = points[i]
            total = total + point.distance / point.prevDistance
        end

        return total / #points
    end

    -- creates an object to be moved
    function newTrackDot(e)
        -- create a user interface object
        local circle = display.newCircle(e.x, e.y, 50)

        -- make it less imposing
        circle.alpha = .5

        -- keep reference to the mapaangle
        local mapa = e.target

        -- standard multi-touch event listener
        function circle:touch(e)
            -- get the object which received the touch event
            local target = circle

            -- store the parent object in the event
            e.parent = mapa

            -- handle each phase of the touch event life cycle...
            if (e.phase == "began") then
                -- tell corona that following touches come to this display object
                display.getCurrentStage():setFocus(target, e.id)
                -- remember that this object has the focus
                target.hasFocus = true
                -- indicate the event was handled
                return true
            elseif (target.hasFocus) then
                -- this object is handling touches
                if (e.phase == "moved") then
                    -- move the display object with the touch (or whatever)
                    target.x, target.y = e.x, e.y
                else -- "ended" and "cancelled" phases
                -- stop being responsible for touches
                display.getCurrentStage():setFocus(target, nil)
                -- remember this object no longer has the focus
                target.hasFocus = false
                end

                -- send the event parameter to the mapa object
                mapa:touch(e)

                -- indicate that we handled the touch and not to propagate it
                return true
            end

            -- if the target is not responsible for this touch event return false
            return false
        end

        -- listen for touches starting on the touch layer
        circle:addEventListener("touch")

        -- listen for a tap when running in the simulator
        function circle:tap(e)
            if (e.numTaps == 2) then
                -- set the parent
                e.parent = mapa

                -- call touch to remove the tracking dot
                mapa:touch(e)
            end
            return true
        end

        -- only attach tap listener in the simulator
        if (not isDevice) then
            circle:addEventListener("tap")
        end

        -- pass the began phase to the tracking dot
        circle:touch(e)

        -- return the object for use
        return circle
    end



    -- spawning tracking dots

    -- create object to listen for new touches
    print(tostring(mapFileName))
    local mapa = display.newImage(properties.mapDir .. "/" .. mapFileName)
    sceneGroup:insert(mapa)


    local newWidthScale, newHeightScale = properties.width / mapa.contentWidth, properties.height / mapa.contentHeight
    local newScale
    if newHeightScale > newWidthScale then
        newScale = newHeightScale
    else
        newScale = newWidthScale
    end
--    mapa.xScale, mapa.yScale = newScale, newScale
    mapa.x, mapa.y = properties.center.x,properties.center.y


    -- keep a list of the tracking dots
    mapa.dots = {}


    local function outOfBounds(image, imgCenter)
        local leftLock, rightLock, topLock, bottomLock

        if image.x + image.contentWidth * 0.5 <= display.contentWidth then
            rightLock = true
        end
        if image.x - image.contentWidth * 0.5 >= display.screenOriginX then
            leftLock = true
        end
        if image.y + image.contentHeight * 0.5 <= display.contentHeight then
            bottomLock = true
        end
        if image.y - image.contentHeight * 0.5 >= display.screenOriginY then
            topLock = true
        end

        return leftLock, rightLock, topLock, bottomLock
    end

    -- advanced multi-touch event listener
    function mapa:touch(e)

        -- get the object which received the touch event
        local target = e.target
        local centre = calcAvgCentre(mapa.dots)

        -- handle began phase of the touch event life cycle...
        if (e.phase == "began") then
            print(e.phase, e.x, e.y)

            -- create a tracking dot
            local dot = newTrackDot(e)

            -- add the new dot to the list
            mapa.dots[#mapa.dots + 1] = dot

            -- pre-store the average centre position of all touch points
            mapa.prevCentre = calcAvgCentre(mapa.dots)

            -- pre-store the tracking dot scale and rotation values
            updateTracking(mapa.prevCentre, mapa.dots)

            -- we handled the began phase
            return true

        elseif (e.parent == mapa) then
            if (e.phase == "moved") then
                print(e.phase, e.x, e.y)

                -- declare working variables
                local cetnre, scale, rotate = {}, 1, 0

                -- calculate the average centre position of all touch points

                -- refresh tracking dot scale and rotation values
                updateTracking(mapa.prevCentre, mapa.dots)

                local leftEdgeLock, rightEdgeLock, topEdgeLock, bottomEdgeLock = outOfBounds(mapa, centre, scale)
                print("l " .. tostring(leftEdgeLock) .. " r " .. tostring(rightEdgeLock) .. " t " .. tostring(topEdgeLock) .. " b " .. tostring(bottomEdgeLock))
                -- if there is more than one tracking dot, calculate the rotation and scaling
                scale = calcAverageScaling(mapa.dots)
                if (#mapa.dots > 1) then
                    -- calculate the average scaling of the tracking dots
                    print('scale ' .. scale)
                    -- apply scaling to mapa
                    if (not leftEdgeLock and not rightEdgeLock and scale < 1) or scale > 1 then
                        mapa.xScale = mapa.xScale * scale
                    end
                    if (not topEdgeLock and not bottomEdgeLock and scale < 1) or scale > 1 then
                        mapa.yScale = mapa.yScale * scale
                    end
                end
                -- update the position of mapa
                local moveLeft = mapa.x < mapa.x + (centre.x - mapa.prevCentre.x)
                local moveRight = mapa.x > mapa.x + (centre.x - mapa.prevCentre.x)
                local moveTop = mapa.y < mapa.y + (centre.y - mapa.prevCentre.y)
                local moveBottom = mapa.y > mapa.y + (centre.y - mapa.prevCentre.y)
                print("moveleft " .. tostring(moveLeft))
                print("moveright " .. tostring(moveRight))
                print("movetop " .. tostring(moveTop))
                print("movebottom " .. tostring(moveBottom))
                if (moveLeft and not leftEdgeLock) or (moveRight and not rightEdgeLock) then
                    mapa.x = mapa.x + (centre.x - mapa.prevCentre.x)
                end
                if (moveTop and not topEdgeLock) or (moveBottom and not bottomEdgeLock) then
                    mapa.y = mapa.y + (centre.y - mapa.prevCentre.y)
                end
                -- store the centre of all touch points
                mapa.prevCentre = centre
            else -- "ended" and "cancelled" phases
            print(e.phase, e.x, e.y)
            -- remove the tracking dot from the list
            if (isDevice or e.numTaps == 2) then
                -- get index of dot to be removed
                local index = table.indexOf(mapa.dots, e.target)

                -- remove dot from list
                table.remove(mapa.dots, index)

                -- remove tracking dot from the screen
                e.target:removeSelf()

                -- store the new centre of all touch points
                mapa.prevCentre = calcAvgCentre(mapa.dots)

                -- refresh tracking dot scale and rotation values
                updateTracking(mapa.prevCentre, mapa.dots)
            end
            end
            return true
        end

        -- if the target is not responsible for this touch event return false
        return false
    end

    -- listen for touches starting on the touch object
    mapa:addEventListener("touch")
end


-- "scene:show()"
function scene:show(event)

    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        createMapObj(fileName)
        print("WILL" .. "aaa")
    elseif (phase == "did") then
        -- Called when the scene is still off screen (but is about to come on screen).

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