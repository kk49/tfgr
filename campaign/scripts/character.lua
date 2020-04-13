function onInit()
    Core.onInitEntered('character_sheet', self)
end

function onFirstLayout()
    Core.onFirstLayoutEntered('character_sheet', self)
end

function classGet()
    return "CharSheet";
end

function actorStamina()
    return  main.stamina
end

function actorInitiative()
    return 2
end

