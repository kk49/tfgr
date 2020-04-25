function onInit()
    Gui.onInit_handle(self)
end

function onFirstLayout()
    Gui.onFirstLayout_handle(self)
end

function onListChanged(node, child)
    print(self.getClass() .. '.onListChanged', node, child)
    notifyUpdate()
end