function onInit()
	Debug.console("manager_gui: onInit")
    Interface.onWindowOpened = onWindowOpened_handle
    Interface.onWindowClosed = onWindowClosed_handle
end

function onWindowOpened_handle(wi)
    Debug.console('onWindowOpenedHandler', wi)
end

function onWindowClosed_handle(wi)
    Debug.console('onWindowClosedHandler', wi)
end

function onInit_handle(name, obj)
--     Debug.console(name .. '.onInit', obj)
    if obj.TypeLayout then
        obj.TypeLayout.setup()
    end
    onLockStateChanged_handle(obj)
end

function onFirstLayout_handle(name, obj)
    Debug.console(name .. '.onFirstLayout', obj)
    if obj.TypeLayout then
        obj.TypeLayout.doAdjustLayout()
    end
end

function onLockStateChanged_handle(obj)
    if obj and obj.window_resize then
        obj.window_resize.setVisible(not obj.getLockState());
    end
end

-- utils
function controlsList(window)
    controls = window.getControls()
    for k,v in pairs(controls) do
        Debug.console(k,v, v.getName())
    end
end