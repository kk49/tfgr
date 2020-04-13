local action_path = nil

function onInit()
    action_path = getDatabaseNode().getPath() .. '.action'
    doUpdate()
    TypeLayout.setup()
    DB.addHandler(action_path, 'onUpdate', doUpdate)
end

function onClose()
    DB.removeHandler(action_path, 'onUpdate', doUpdate)
end

function doUpdate()
    visible = not (action.getValue() == CombatManager.k_action_end_of_round)
    action.setVisible(visible)
    l0.setVisible(visible)
    l1.setVisible(visible)
end