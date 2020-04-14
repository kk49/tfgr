function onInit()
    Gui.onInitEntered('combat_actor', self)
end

function onFirstLayout()
    Gui.onFirstLayoutEntered('combat_actor', self)
end

function elementOpen()
	Interface.openWindow(link_window.getValue(), link_db_ref.getValue())
end

function elementDrag(button, x, y, drag_info)
    --Debug.console('elementDrag', button, x, y, drag_info)
	drag_info.setShortcutData(link_window.getValue(), link_db_ref.getValue())
    drag_info.setType('shortcut')
end
