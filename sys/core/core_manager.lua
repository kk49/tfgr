function onInit()
	Debug.console("manager_core: onInit")
end

--
function error(...)
    Debug.console('Error: ' .. string.format(unpack(arg)))
end

-- editor
local editor_registry = {}

function editorRegister(db_path_pattern, editor_name)
    stored_names = editor_registry[db_path_pattern]
    if not stored_names then
        stored_names = {}
    end

    table.insert(stored_names, editor_name)

    editor_registry[db_path_pattern] = stored_names
end

function editorUnregister(db_path_pattern, editor_name)
    stored_names = editor_registry[db_path_pattern]
    if stored_names and stored_names[#stored_names] == editor_name then
        table.remove(stored_names)
        editor_registry[db_path_pattern] = nil
    else
        Core.error('manager_core.editorUnregister: editor_name does not match top of stack for %s', db_path_pattern)
    end
end

function editorFind(db_path, default)
    editor = default
    for k,v in pairs(editor_registry) do
        if string.match(db_path, k) then
            editor = v
            break
        end
    end

    if editor then
        return editor[#editor]  -- return top of stack
    else
        Core.error('manager_core.editorFind: could not match %s to any class', db_path)
        return nil
    end
end

-- class
local class_registry = {}

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
        Core.error('manager_core.classUnregister: class_object does not match stored value for %s', db_path_pattern)
    end
end

function dbCast(node, cast_to)
    if not node then
        Core.error('manager_core.dbCast: node is nil')
    elseif not cast_to then
        Core.error('manager_core.dbCast: cast_to is nil')
    else
        if type(node) == 'string' then
            db_path = node
            node = nil
        else
            db_path = node.getPath()
        end

        cr = nil
        for k,v in pairs(class_registry) do
            if string.match(db_path, k) then
                cr = v
                break
            end
        end

        if cr then
            if not node then
                node = DB.findNode(db_path)
            end

            obj = cr(node, cast_to)
            if obj then
                return obj
            else
                Core.error('manager_core.dbCast: could not match case %s to %s', db_path, cast_to)
            end
        else
            Core.error('manager_core.dbCast: could not match %s to any class', db_path)
        end
    end

    return nil
end