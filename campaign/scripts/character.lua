function classGet()
    return "CharSheet";
end

function onInit()
    Debug.console("CharSheet::onInit")
    if User.isLocal() then
        speak.setVisible(false);
        portrait.setVisible(false);
        portrait_local.setVisible(true);
    end
end

function actorStamina()
    return  main.stamina
end

function actorInitiative()
    return 2
end

