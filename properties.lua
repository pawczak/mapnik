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
--backbutton
properties.eventTypeToggleButton = "eventTypeToggleButton"
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

--maplist
properties.mapRowOptionsFontSize = 15
properties.rowButtonClickColor = { 0.1, 0.3, 0.5, 0.9 }
properties.rowButtonUnclickColor = { 0.3, 0.7, 0.5, 0.9 }

properties.removeMapClickColor = { 0.9, 0.9, 1, 1 }
properties.removeMapUnclickColor = { 0.1, 0.1, 0.1 }
properties.eventTypeUpdateMapList = "eventTypeUpdateMapList"

--overlay options


--file system
return properties