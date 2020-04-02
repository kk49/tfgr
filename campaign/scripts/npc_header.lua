function onInit()
	update();
	updateIDState();
end

function update()
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());
	name.setReadOnly(bReadOnly);
	nonid_name.setReadOnly(bReadOnly);
	token.setReadOnly(bReadOnly);
end

function updateIDState()
	if User.isHost() then return; end
	local bID = LibraryData.getIDState("npc", getDatabaseNode());
	name.setVisible(bID);
	nonid_name.setVisible(not bID);
end