local action_path = nil

function onInit()
    Gui.onInitEntered('combat_turn', self)
    doUpdate()
    action_path = getDatabaseNode().getPath() .. '.action'
    DB.addHandler(action_path, 'onUpdate', doUpdate)
end

function onClose()
    DB.removeHandler(action_path, 'onUpdate', doUpdate)
end

function onFirstLayout()
    Gui.onFirstLayoutEntered('combat_turn', self)
end

function doUpdate()
    visible = not (action.getValue() == CombatManager.k_action_end_of_round)
    action.setVisible(visible)
    l0.setVisible(visible)
    l1.setVisible(visible)
end