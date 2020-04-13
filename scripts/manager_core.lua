function onInit()
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

function isType(name)
    i,j = string.find(name, 'Type')
    if i == 1 and j == 4 then
        return true
    else
        return false
    end
end

function cast(object, type)
    for k,v in ipairs(object.getControls()) do
        print('cast', k, v, v.getName())
        if v.getName() == type then
            return v
        end
    end

    return nil
end

function controlsList(window)
    controls = window.getControls()
    for k,v in ipairs(controls) do
        Debug.console(k,v, v.getName())
    end
end