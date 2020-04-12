function onInit()
    Debug.console('npc_viewer_element.onInit')
    TypeLayout.setup()
end

function onFirstLayout()
    TypeLayout.doAdjustLayout()
end

function onDragStart(button, x, y, drag_info)
    return elementDrag(button, x, y, drag_info)
end

function elementOpen()
	Interface.openWindow('npc_sheet', getDatabaseNode().getNodeName())
    return true
end

function elementDrag(button, x, y, drag_info)
    --Debug.console('elementDrag', button, x, y, drag_info)
	drag_info.setShortcutData("npc_sheet", getDatabaseNode().getNodeName())
    drag_info.setType('shortcut')
    return true
end

