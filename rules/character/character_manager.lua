function onInit()
	Debug.console("manager_character: onInit")
	Core.classRegister('character..[^.]+', objectCast)
	Core.dragInfoRegister('character..[^.]+', dragInfoGet)
	Core.editorRegister('character..[^.]+', 'character_sheet')
end

function dragInfoGet(db_ref, button, x, y, drag_info)
    --Debug.console('elementDrag', button, x, y, drag_info)
    name = DB.getValue(db_ref .. '.name')
    drag_info.setShortcutData(Core.editorFind(db_ref), db_ref)
    drag_info.setDescription('Character: ' .. name)
    drag_info.setType('shortcut')
    return true
end

function objectCast(db_node, cast_to)
    if Combat.k_interface_combat_actor then
        return {
            db_node = db_node,
            nameGet = nameGet,
            initiativeGet = initiativeGet,
            initiativeUsedGet = initiativeUsedGet,
            initiativeUsedSet = initiativeUsedSet,
            staminaGet = staminaGet,
            staminaUsedGet = staminaUsedGet,
            staminaUsedSet = staminaUsedSet,
        }
    end
end

--k_interface_combat_actor = 'CombatActor'
-- :nameGet()
function nameGet(self)
    return DB.getValue(self.db_node,'name')
end
-- :initiativeGet()
function initiativeGet(self)
    return 2
end
-- :initiativeUsedGet()
function initiativeUsedGet(self)
    used = DB.getValue(self.db_node,'initiative_used')
    if used then
        return used
    else
        return 0
    end
end
-- :initiativeUsedSet()
function initiativeUsedSet(self, v)
    return DB.setValue(self.db_node, 'initiative_used', 'number', v)
end
-- :staminaGet()
function staminaGet(self)
    return DB.getValue(self.db_node,'stamina')
end
-- :staminaUsedGet()
function staminaUsedGet(self)
    used = DB.getValue(self.db_node,'stamina_used')
    if used then
        return used
    else
        return 0
    end
end
-- :staminaUsedSet()
function staminaUsedSet(self, v)
    return DB.setValue(self.db_node, 'stamina_used', 'number', v)
end