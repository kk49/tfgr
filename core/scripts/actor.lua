function classGet()
    return "Actor"
end

function onInit()
    if super and super.onInit then super.onInit() end
    Debug.console(classGet() .. "::onInit")
end

function actorStamina()
    return self.window.actorStamina()
end

function actorInitiative()
    return self.window.actorInitiative()
end

