function onInit()
    Debug.console("manager_module: onInit");

	Module.onUnloadedReference = onUnloadedReferenceHandler;
end

function onUnloadedReferenceHandler(sModule, sClass, sPath)
	Debug.console("onUnloadedReferenceHandler", sModule, sClass, sPath);
end

