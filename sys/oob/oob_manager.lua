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

    Debug.console('OOB: ', msg)

	for handler_type, handler in pairs(global_OOBMsgHandlers) do
		if msg.type == handler_type then
			handler(msg);
			return true;
		end
	end

	Core.error("manager_oob: error_oob_msg_unknown: "  .. msg.type);

	return true;
end