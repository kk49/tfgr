function onInit()
    Gui.onInit_handle('character_viewer_element', self)
end

function onFirstLayout()
    Gui.onFirstLayout_handle('character_viewer_element', self)
end

function onDragStart(button, x, y, drag_info)
    return elementDrag(button, x, y, drag_info)
end

function elementOpen()
    db_ref = getDatabaseNode().getNodeName()
    Interface.openWindow(Core.editorFind(db_ref), db_ref)
    return true
end

function elementDrag(button, x, y, drag_info)
    return Core.dragInfoGet(getDatabaseNode().getNodeName(), button, x, y, drag_info)
end

