function onInit()
    -- DB.addHandler was moved to onFirstLayout because the values are not loaded when onInit is called
    Gui.onInit_handle('combat_actor', self)
end

function onClose()
    DB.removeHandler(link_db_ref.getValue(), 'onChildUpdate', onUpdateHandler)
    DB.removeHandler(link_db_ref.getValue(), 'onUpdate', onUpdateHandler)
end

function onFirstLayout()
    DB.addHandler(link_db_ref.getValue(), 'onUpdate', onUpdateHandler)
    DB.addHandler(link_db_ref.getValue(), 'onChildUpdate', onUpdateHandler)
    Gui.onFirstLayout_handle('combat_actor', self)
end

function onUpdateHandler(actor_node, child_node)
    Debug.console('combat_actor.onUpdateHandler', actor_node, child_node)
    actor = Core.dbCast(actor_node, Combat.k_interface_combat_actor)
    if actor then
        node = getDatabaseNode()

        chits_available = actor:initiativeGet()
        chits_used =  actor:initiativeUsedGet()
        chits_remaining = chits_available - chits_used
        DB.setValue(node, 'initiative_cur', 'number', chits_remaining)

        stamina = actor:staminaGet()
        stamina_used = actor:staminaUsedGet()
        stamina_remaining = stamina - stamina_used
        DB.setValue(node, 'stamina_cur', 'number', stamina_remaining)
    else
        Core.error('did not link to combat.actor properly')
    end
end

function elementOpen()
    return Core.openWindow(link_db_ref.getValue())
end

function elementDrag(button, x, y, drag_info)
    return Core.dragInfoGet(link_db_ref.getValue(), button, x, y, drag_info)
end
