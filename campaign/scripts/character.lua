function onInit()
    Debug.console('character_sheet.onInit')
    TypeLayout.setup()
end

function onFirstLayout()
    TypeLayout.doAdjustLayout()
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

