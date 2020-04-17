
function onInit()
    Gui.onInit_handle('combat_fight', self)
end

function onFirstLayout()
    Gui.onFirstLayout_handle('combat_fight', self)
end

function onDrop(x, y, drag_info)
    return Combat.requestDropAccept(x, y, drag_info)
end
