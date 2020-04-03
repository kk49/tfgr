
function onInit()
	Debug.console("manager_chat: onInit");
end

function systemMessage(sText)
	local msg = {font = "systemfont"};
	msg.text = sText;
	Comm.addChatMessage(msg);
end



global_launchmsg = {};

function registerLaunchMessage(msg)
	Debug.console("manager_chat: registerLaunchMessage", msg)

	table.insert(global_launchmsg, msg);
end

function retrieveLaunchMessages()
	return global_launchmsg;
end