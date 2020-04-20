function onInit()
	Debug.console("manager_chat: onInit")
	Comm.registerSlashHandler("vc", debug_db)
	Comm.registerSlashHandler("vn", debug_db)
	Comm.registerSlashHandler("dd", debug_db)
end

function systemMessage(sText)
	local msg = {font = "systemfont"}
	msg.text = "SystemMessage: " .. sText
	Comm.addChatMessage(msg)
end

global_node_type = "character"

function debug_db(command, params)
	if command == "vc" then
		Interface.openWindow('character_viewer', 'character')
	elseif command == "vn" then
		Interface.openWindow('npc_viewer', 'npc')
	elseif command == "dd" then
	end
end


global_launch_messages = {};

function registerLaunchMessage(msg)
	Debug.console("manager_chat: registerLaunchMessage", msg)
	table.insert(global_launch_messages, msg);
end

function retrieveLaunchMessages()
	return global_launch_messages;
end