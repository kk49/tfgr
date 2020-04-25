function onInit()
    Gui.onInit_handle(self)
end

function onFirstLayout()
    Gui.onFirstLayout_handle(self)
end

function onDragStart(button, x, y, drag_info)
    return elementDrag(button, x, y, drag_info)
end

function elementOpen()
    db_ref = getDatabaseNode().getNodeName()
    return Core.windowOpen('editor', db_ref)
end

function elementDrag(button, x, y, drag_info)
    return Core.dragInfoGet(getDatabaseNode().getNodeName(), button, x, y, drag_info)
end

