function onInit()
    Gui.onInit_handle('character_viewer', self)
end

function onFirstLayout()
    Gui.onFirstLayout_handle('character_viewer', self)
end

function onListChanged(node, child)
    print('character_viewer.onListChanged', node, child)
    notifyUpdate()
end