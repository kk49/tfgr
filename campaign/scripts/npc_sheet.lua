function onInit()
    Gui.onInitEntered('npc_sheet', self)
end

function onFirstLayout()
    Gui.onFirstLayoutEntered('npc_sheet', self)
end

function classGet()
    return "Npc";
end

function actorStamina()
    return stamina
end

function actorInitiative()
    return initiative
end