function onInit()
	Debug.console("manager_gui: onInit")
    Interface.onWindowOpened = onWindowOpenedHandler
    Interface.onWindowClosed = onWindowClosedHandler
end

function onWindowOpenedHandler(wi)
    Debug.console('onWindowOpenedHandler', wi)
end

function onWindowClosedHandler(wi)
    Debug.console('onWindowClosedHandler', wi)
end

function onInitEntered(name, obj)
    Debug.console(name .. '.onInit', obj)
    if obj.TypeLayout then
        obj.TypeLayout.setup()
    end
end

function onFirstLayoutEntered(name, obj)
    Debug.console(name .. '.onFirstLayout', obj)
    if obj.TypeLayout then
        obj.TypeLayout.doAdjustLayout()
    end
end

-- utils
function controlsList(window)
    controls = window.getControls()
    for k,v in ipairs(controls) do
        Debug.console(k,v, v.getName())
    end
end