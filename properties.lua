local properties = {}

properties.mapDir = "mapy"

--display:
properties.width = display.actualContentWidth
properties.height = display.actualContentHeight
properties.x = display.screenOriginX
properties.y = display.screenOriginY

properties.center = { x = display.actualContentWidth * 0.5, y = display.actualContentHeight * 0.5 }

properties.mainButtonWidth = properties.width * 0.7
properties.mainButtonHeight = properties.height * 0.2

properties.labelHeight = 100

--device/sim
properties.isDevice = (system.getInfo("environment") == "device")

return properties