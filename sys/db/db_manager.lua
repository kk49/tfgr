function onInit()
    Debug.console("manager_db.onInit")
end

function generateNextId(container_path, check_function, verbose_error)
    children = DB.getChildren(container_path)
    add_actor = true
    max_id = -1
    for id, node in pairs(children) do
        if check_function and not check_function(node) then
            if verbose_error then
                Core.error('DbManager.generateNextId(%s) check failed', container_path)
            end
            return nil, nil
        end

        id_number = string.match(id, 'id%-(%d+)')
        id_number = tonumber(id_number)
        if id_number and id_number > max_id then
            max_id = id_number
        end
    end

    new_index = max_id + 1
    new_id = container_path .. string.format('.id-%05d', new_index)
    return new_index, new_id
end