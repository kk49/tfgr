function onInit()
	Debug.console("manager_core: onInit")
end

--
function error(...)
    Debug.console('Error: ' .. string.format(unpack(arg)))
end

-- editor
local window_registry = {}

function windowRegister(type, db_path_pattern, editor_name)
    local type_registry = window_registry[type]

    if not type_registry then
        type_registry = {}
        window_registry[type] = type_registry
    end

    local stored_names = type_registry[db_path_pattern]
    if not stored_names then
        stored_names = {}
        type_registry[db_path_pattern] = stored_names
    end

    table.insert(stored_names, editor_name)
end

function windowUnregister(type, db_path_pattern, editor_name)
    local type_registry = window_registry[type]
    if type_registry then
        local stored_names = type_registry[db_path_pattern]
        if stored_names and stored_names[#stored_names] == editor_name then
            table.remove(stored_names)
            type_registry[db_path_pattern] = nil
        else
            Core.error('manager_core.windowUnregister: editor_name does not match top of stack for <%s>', db_path_pattern)
        end
    else
        Core.error('manager_core.windowUnregister: type <%s} does not exist', type)
    end
end

function windowFind(type, db_path, default)
    editor = default

    local type_registry = window_registry[type]
    if type_registry then
        for k,v in pairs(type_registry) do
            if string.match(db_path, k) then
                editor = v
                break
            end
        end
    end

    if editor then
        return editor[#editor]  -- return top of stack
    else
        Core.error('manager_core.editorFind: could not match <%s> to any class', db_path)
        return nil
    end
end

function windowOpen(type, db_ref)
    editor = windowFind(type, db_ref)
    if editor then
        return Interface.openWindow(editor, db_ref)
    else
        return nil
    end
end

-- drag info
drag_info_registry = {}
function dragInfoRegister(db_path_pattern, handler)
    if drag_info_registry[db_path_pattern] then
        Core.error('manager_core.dragInfoRegister: <%s> already registered', db_path_pattern)
    else
        drag_info_registry[db_path_pattern] = handler
    end
end

function dragInfoUnregister(db_path_pattern, handler)
    if handler == drag_info_registry[db_path_pattern] then
        drag_info_registry[db_path_pattern] = nil
    else
        Core.error('manager_core.dragInfoUnregister: handler does not match stored value for <%s>', db_path_pattern)
    end
end

function dragInfoGet(db_path, button, x, y, drag_info)
    handler = nil
    for k,v in pairs(drag_info_registry) do
        if string.match(db_path, k) then
            handler = v
            break
        end
    end

    if handler then
        return handler(db_path, button, x, y, drag_info)
    else
        return false
    end
end

-- class
local class_registry = {}

function classRegister(db_path_pattern, class_object)
    if class_registry[db_path_pattern] then
        Core.error('manager_core.classRegister: %s already registered', db_path_pattern)
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
                Core.error('manager_core.dbCast: could not match case <%s> to "%s"', db_path, cast_to)
            end
        else
            Core.error('manager_core.dbCast: could not match <%s> to any class', db_path)
        end
    end

    return nil
end