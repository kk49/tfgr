function onInit()
    Debug.console('npc_viewer_element.onInit')
    TypeLayout.setup()
end

function onFirstLayout()
    TypeLayout.doAdjustLayout()
end

function onDragStart(button, x, y, drag_info)
    elementDrag(button, x, y, drag_info)
    return true
end

function elementOpen()
	Interface.openWindow("npc", getDatabaseNode().getNodeName())
end

function elementDrag(button, x, y, drag_info)
    Debug.console('elementDrag', button, x, y, drag_info)
end

