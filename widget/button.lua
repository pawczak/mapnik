local button = {}

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

    if params.text then
        buttonText = display.newText(params.text, 0, 0, params.font, params.fontSize)
        buttonGroup:insert(buttonText)
    end

    local function buttonTouched(event)
        if event.phase == "began" then
            if takeFocus then
                display.getCurrentStage():setFocus(event.target)
                buttonGroup.touchInitX, buttonGroup.touchInitY = event.x, event.y
                return true
            end
        elseif event.phase == "moved" then
            if takeFocus then

                return true
            end
        elseif event.phase == "ended" then
            callback(event)
            display.getCurrentStage():setFocus(nil)
        end
    end

    buttonGroup:addEventListener("touch", buttonTouched)


    return buttonGroup
end

return button