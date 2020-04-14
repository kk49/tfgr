function onInit()
	Debug.console("manager_core: onInit")
end

local class_registry = {}

--
function error(...)
    Debug.console('Error: ' .. string.format(unpack(arg)))
end

-- class
function classRegister(db_path_pattern, class_object)
    if class_registry[db_path_pattern] then
        Core.error('manager_core.classRegister: class already registered %s', db_path_pattern)
    else
        class_registry[db_path_pattern] = class_object
    end

end

function classUnregister(db_path_pattern, class_object)
    if class_object == class_registry[db_path_pattern] then
        class_registry[db_path_pattern] = nil
    else
        Core.error('manager_core.classUnregister: class_object does not match stored class_object for %s', db_path_pattern)
    end
end

function dbCast(db_path, cast_to)
    cr = nil
    for k,v in pairs(class_registry) do
        if string.match(db_path, k) then
            cr = v
            break
        end
    end

    if cr then
        obj = cr(db_path, cast_to)
        if obj then
            return obj
        else
            Core.error('manager_core.dbCast: could not match case %s to %s', db_path_pattern, cast_to)
        end
    else
        Core.error('manager_core.dbCast: could not match %s to any class', db_path_pattern)
    end
end