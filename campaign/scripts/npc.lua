function onInit()
    Core.onInitEntered('npc_sheet', self)
end

function onFirstLayout()
    Core.onFirstLayoutEntered('npc_sheet', self)
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