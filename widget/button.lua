local properties = require("properties")

local button = {}

local buttonEnabled = true

button.toggle = function(event)
    buttonEnabled = event.value
end
Runtime:addEventListener(properties.eventTypeToggleButton, button.toggle)

button.new = function(params)
    local buttonGroup = display.newGroup()
    local buttonBg, buttonText, buttonObject, callback, takeFocus, deltaFocusLost

    callback = params.callback
    takeFocus = params.takeFocus
    deltaFocusLost = params.deltaFocusLost

    if params.img then
        buttonBg = params.img
        buttonGroup:insert(buttonBg)
    end

    if params.undimColor then
        buttonBg:setFillColor(params.undimColor[1], params.undimColor[2], params.undimColor[3], params.undimColor[4])
    end

    if params.text then
        buttonText = display.newText(params.text, 0, 0, params.font, params.fontSize)
        buttonGroup:insert(buttonText)
    end

    local function buttonTouched(event)
        if not buttonEnabled then
            print("toggle button disabled")
            return
        end
        if event.phase == "began" then
            if takeFocus then
                display.getCurrentStage():setFocus(event.target)
                buttonGroup.touchInitX, buttonGroup.touchInitY = event.x, event.y

                if params.dimColor then
                    buttonBg:setFillColor(params.dimColor[1], params.dimColor[2], params.dimColor[3], params.dimColor[4])
                end

                return true
            end
        elseif event.phase == "moved" then
            if takeFocus then

                return true
            end
        elseif event.phase == "ended" then
            if params.undimColor then
                buttonBg:setFillColor(params.undimColor[1], params.undimColor[2], params.undimColor[3], params.undimColor[4])
            end
            callback(event)
            display.getCurrentStage():setFocus(nil)
        end
    end

    buttonGroup:addEventListener("touch", buttonTouched)

    function buttonGroup:finalize(event)
    end

    buttonGroup:addEventListener("finalize")

    return buttonGroup
end

return button