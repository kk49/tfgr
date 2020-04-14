function onInit()
    Gui.onInitEntered('combat_actor', self)
end

function onFirstLayout()
    Gui.onFirstLayoutEntered('combat_actor', self)
end

function elementOpen()
    db_ref = link_db_ref.getValue()
    Interface.openWindow(Core.editorFind(db_ref), db_ref)
end

function elementDrag(button, x, y, drag_info)
    --Debug.console('elementDrag', button, x, y, drag_info)
    db_ref = link_db_ref.getValue()
    drag_info.setShortcutData(Core.editorFind(db_ref), db_ref)
    drag_info.setType('shortcut')
end
