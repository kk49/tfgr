function onInit()
    Core.onInitEntered('npc_viewer', self)
end

function onFirstLayout()
    Core.onFirstLayoutEntered('npc_viewer', self)
end

function onClose()
end

function onListChanged(node, child)
    print('npc.viewer.onListChanged', node, child)
    notifyUpdate()
end