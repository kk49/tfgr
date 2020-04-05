
function onInit()
	Debug.console("manager_chat: onInit");
end

function systemMessage(sText)
	local msg = {font = "systemfont"};
	msg.text = "SystemMessage: " .. sText;
	Comm.addChatMessage(msg);
end



global_launch_messages = {};

function registerLaunchMessage(msg)
	Debug.console("manager_chat: registerLaunchMessage", msg)
	table.insert(global_launch_messages, msg);
end

function retrieveLaunchMessages()
	return global_launch_messages;
end