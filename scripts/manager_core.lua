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