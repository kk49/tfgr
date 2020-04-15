
function onInit()
    Gui.onInitEntered('combat_fight', self)
end

function onFirstLayout()
    Gui.onFirstLayoutEntered('combat_fight', self)
end

function onDrop(x, y, drag_info)
    return Combat.requestDropAccept(x, y, drag_info)
end
