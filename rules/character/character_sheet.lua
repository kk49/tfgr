function onInit()
    Gui.onInitEntered('character_sheet', self)
end

function onFirstLayout()
    Gui.onFirstLayoutEntered('character_sheet', self)
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

