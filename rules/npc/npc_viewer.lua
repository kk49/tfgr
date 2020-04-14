function onInit()
    Gui.onInitEntered('npc_viewer', self)
end

function onFirstLayout()
    Gui.onFirstLayoutEntered('npc_viewer', self)
end

function onClose()
end

function onListChanged(node, child)
    print('npc.viewer.onListChanged', node, child)
    notifyUpdate()
end