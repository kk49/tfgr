
function onInit()
	Debug.console("manager_chat: onInit")
	Comm.registerSlashHandler("dl", debug_db)
	Comm.registerSlashHandler("dc", debug_db)
	Comm.registerSlashHandler("dg", debug_db)
	Comm.registerSlashHandler("ds", debug_db)
	Comm.registerSlashHandler("vc", debug_db)
	Comm.registerSlashHandler("vn", debug_db)
end

function systemMessage(sText)
	local msg = {font = "systemfont"}
	msg.text = "SystemMessage: " .. sText
	Comm.addChatMessage(msg)
end

global_node_type = "character"

function debug_db(command, params)
	if command == "dg" then
		node = DB.findNode(params)
		Debug.chat(node)
		if node then
			value = node.getValue()
			Debug.chat(value)
			if not value then  -- TODO get better check for nil
				win = Interface.openWindow(global_node_type, params)
				--Debug.chat(win)
				if win then
					--Debug.chat("win._type")
					--Debug.chat(win._type)
					if win._type then
						--Debug.chat("win._type.classGet")
						--Debug.chat(win._type.classGet)
						if win._type.classGet then
							--Debug.chat("win._type.classGet()")
							Debug.chat(win._type.classGet())
						end

						--Debug.chat("win._type.classesGet")
						--Debug.chat(win._type.classesGet)
						if win._type.classesGet then
							--Debug.chat("win._type.classesGet()")
							Debug.chat(win._type.classesGet())
						end
						Debug.chat(win._type.classIs("Object"))
						Debug.chat(win._type.classIs("Actor"))
						Debug.chat(win._type.classIs("Npc"))
						Debug.chat(win._type.classIs("Character"))
						Debug.chat(win._type.actorStamina())
						Debug.chat(win._type.actorInitiative())



					end
				end
			end
		end
	elseif command == "dc" then
		Interface.openWindow(global_node_type, params)
	elseif command == "dl" then
		cl = DB.getChildren(params)
		Debug.console(cl);
	elseif command == "ds" then
		--if params ~= "" then
		--	global_node_type = params
		--end
		--Debug.chat("global_node_type == " .. global_node_type)
		id = params
		Debug.chat(id)
		node = DB.findNode(id)
		Debug.chat(node)
		v = DB.getValue(id)
		Debug.chat(v)
	elseif command == "vc" then
		Interface.openWindow('character_viewer', 'character')
	elseif command == "vn" then
		Interface.openWindow('npc_viewer', 'npc')
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