function onInit()
	update();
end

function VisDataCleared()
	update();
end

function InvisDataAdded()
	update();
end

function updateControl(sControl, bReadOnly, bForceHide)
	if not self[sControl] then
		return false;
	end
		
	return self[sControl].update(bReadOnly, bForceHide);
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);

	skill.setReadOnly(bReadOnly);
	stamina.setReadOnly(bReadOnly);
	initiative.setReadOnly(bReadOnly);
	armour.setReadOnly(bReadOnly);
	damage_as.setReadOnly(bReadOnly);
	description.setReadOnly(bReadOnly);
	special.setReadOnly(bReadOnly);
	mien.setReadOnly(bReadOnly);
end
