global_OOBMsgHandlers = {};

function onInit()
	Debug.console("manager_oob: onInit");

	Comm.onReceiveOOBMessage = processReceiveOOBMessage;
end

function registerOOBMsgHandler(sMessageType, fCallback)
	global_OOBMsgHandlers[sMessageType] = fCallback;
end

function processReceiveOOBMessage(msg)
	if not msg.type then
		return;
	end

	for kHandlerType, fHandler in pairs(global_OOBMsgHandlers) do
		if msg.type == kHandlerType then
			fHandler(msg);
			return true;
		end
	end

	Debug.chat("manager_oob: error_oob_msg_unknown: "  .. msg.type);

	return true;
end