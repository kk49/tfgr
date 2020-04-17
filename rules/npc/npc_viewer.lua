function onInit()
    Gui.onInit_handle('npc_viewer', self)
end

function onFirstLayout()
    Gui.onFirstLayout_handle('npc_viewer', self)
end

function onClose()
end

function onListChanged(node, child)
    print('npc.viewer.onListChanged', node, child)
    notifyUpdate()
end