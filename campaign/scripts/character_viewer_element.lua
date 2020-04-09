function onInit()
    Debug.console("character_viewer_element::onInit")
    Layout.horizontal(self, 8)
end

function onFirstLayout()
    Layout.horizontal_first_layout(self, 8)
end

function onDragStart(button, x, y, drag_info)
    characterDrag(button, x, y, drag_info)
    return true
end

function characterOpen()
	Interface.openWindow("character", getDatabaseNode().getNodeName())
end

function characterDrag(button, x, y, drag_info)
    Debug.console('character_viewer_element.characterDrag', button, x, y, drag_info)
end

