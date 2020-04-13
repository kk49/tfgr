function onInit()
    Core.onInitEntered('character_viewer', self)
end

function onFirstLayout()
    Core.onFirstLayoutEntered('character_viewer', self)
end

function onListChanged(node, child)
    print('character_viewer.onListChanged', node, child)
    notifyUpdate()
end