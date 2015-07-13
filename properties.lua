local properties = {}


--display:
properties.width = display.actualContentWidth
properties.height = display.actualContentHeight
properties.x = display.screenOriginX
properties.y = display.screenOriginY

properties.center = { x = display.actualContentWidth * 0.5, y = display.actualContentHeight * 0.5 }

properties.mainButtonWidth = properties.width * 0.7
properties.mainButtonHeight = properties.height * 0.2

properties.labelHeight = 100

properties.mapTempFileName = "mapTempFileName"
--design
properties.mainSceneBtnDistance = properties.height * 0.1

--events
properties.eventTypeCopyMap = "eventTypeCopyMap"
--scene events
properties.eventTypeAddScene = "eventTypeAddScene"
properties.eventTypeResetSceneStack = "eventTypeResetSceneStack"
--scene names
properties.mapSceneName = "scenes.mapScene"
properties.mapListSceneName = "scenes.mapListScene"
properties.mainSceneName = "scenes.mainScene"

--device/sim
properties.isDevice = (system.getInfo("environment") == "device")
if properties.isDevice then
    properties.mapListBaseDir = system.TemporaryDirectory
else
    properties.mapListBaseDir = system.ResourcesDirectory
    properties.mapListDir = "mapy"
end

properties.sceneChangeTime = 1000
properties.sceneChangeOptions = { effect = "crossFade", time = properties.sceneChangeTime }
--file system
return properties