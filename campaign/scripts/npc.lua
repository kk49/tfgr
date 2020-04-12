function onInit()
    Debug.console('npc_sheet.onInit')
    TypeLayout.setup()
end

function onFirstLayout()
    TypeLayout.doAdjustLayout()
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