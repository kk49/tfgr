function onInit()
    notifyUpdate()

	local node = getDatabaseNode();
	DB.addHandler(DB.getPath(node), "onChildAdded", onListChanged);
	DB.addHandler(DB.getPath(node), "onChildDeleted", onListChanged);
	DB.addHandler(DB.getPath(node), "onChildUpdate", onListChanged);
end

function onClose()
	local node = getDatabaseNode();
	DB.removeHandler(DB.getPath(node), "onChildAdded", onListChanged);
	DB.removeHandler(DB.getPath(node), "onChildDeleted", onListChanged);
	DB.removeHandler(DB.getPath(node), "onChildUpdate", onListChanged);
end

function onListChanged(node, child)
    print('character.viewer.onListChanged', node, child)
    notifyUpdate()
end