function onInit()
    Gui.onInit_handle('npc_sheet', self)
end

function onFirstLayout()
    Gui.onFirstLayout_handle('npc_sheet', self)
end

function elementDrag(button, x, y, drag_info)
    return Core.dragInfoGet(getDatabaseNode().getNodeName(), button, x, y, drag_info)
end
