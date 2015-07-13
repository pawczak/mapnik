-- scaling

-- turn on multitouch
system.activate("multitouch")

-- which environment are we running on?
local isDevice = (system.getInfo("environment") == "device")



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
local mapa = display.newImage("mapy/beskid_makowski.jpg")

-- keep a list of the tracking dots
mapa.dots = {}


local function outOfBounds(image, imgCenter, newScale, touchStartX, touchStartY, touchStartContentWidth, touchStartContentHeight)
--    local newX, newY, newContentWidth, newContentHeight
--    newX = image.x + (imgCenter.x - image.prevCentre.x)
--    newY = image.y + (imgCenter.y - image.prevCentre.y)
--    local cancelX, cancelY
--    local prevOutX = image.x + image.contentWidth * 0.5 > display.contentWidth or image.x - image.contentWidth * 0.5 > display.screenOriginX
--    local prevOutY = image.y + image.contentWidth * 0.5 > display.contentHeight or image.y - image.contentHeight * 0.5 > display.screenOriginY
--    newContentWidth = (image.contentWidth * image.xScale * newScale)
--    newContentHeight = (image.contentHeight * image.yScale * newScale)
----    local startCancelXPlus = image.startX + image.startContentWidth * 0.5 < display.contentWidth
----    local startCancelXMinus = image.startX - image.startContentWidth * 0.5 > display.screenOriginX
----    local startCancelYPlus = image.startY + image.startContentHeight * 0.5 < display.contentHeight
----    local startCancelYMinus = image.startY - image.startContentHeight * 0.5 > display.screenOriginY
--    local startCancelY = image.startY + image.startContentHeight * 0.5 > display.contentHeight or image.startY - image.startContentHeight * 0.5 > display.screenOriginY
--    if newX + newContentWidth * 0.5 < display.contentWidth or newX - newContentWidth * 0.5 > display.screenOriginX and not prevOutX then
--        cancelX = true
--    elseif newY + newContentHeight * 0.5 > display.contentHeight + display.screenOriginY or newY - newContentHeight * 0.5 < display.screenOriginY and not prevOutY then
--        cancelY = true
--    end
    return false,false
end

-- advanced multi-touch event listener
function mapa:touch(e)

    -- get the object which received the touch event
    local target = e.target
    local centre = calcAvgCentre(mapa.dots)
    --    local cancelX, cancelY = outOfBounds(target, centre)

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

            local cancelX, cancelY = outOfBounds(mapa, centre, scale)
            -- if there is more than one tracking dot, calculate the rotation and scaling
            scale = calcAverageScaling(mapa.dots)
            if (#mapa.dots > 1) then
                -- calculate the average scaling of the tracking dots

                -- apply scaling to mapa
                if not cancelX then
                    mapa.xScale = mapa.xScale * scale
                end
                if not cancelY then
                    mapa.yScale = mapa.yScale * scale
                end
            end
            -- update the position of mapa
            if not cancelX then
                mapa.x = mapa.x + (centre.x - mapa.prevCentre.x)
            end
            if not cancelY then
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
