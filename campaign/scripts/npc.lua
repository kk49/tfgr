function onInit()
    Debug.console('npc.onInit')
    TypeLayout.setup()
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