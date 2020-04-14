function onInit()
	Debug.console("manager_character: onInit")
	Core.classRegister('character..[^.]+', objectCast)
	Core.editorRegister('character..[^.]+', 'character_sheet')
end

function objectCast(db_path, cast_to)
    if Combat.k_interface_combat_actor then
        return {
            db_node = DB.findNode(db_path),
            nameGet = nameGet,
            initiativeGet = initiativeGet,
            staminaGet = staminaGet,
            staminaLostGet = staminaLostGet,
            staminaLostSet = staminaLostSet,
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
-- :staminaGet()
function staminaGet(self)
    return DB.getValue(self.db_node,'stamina')
end
-- :staminaLostGet()
function staminaLostGet(self)
    stamina_lost = DB.getValue(self.db_node,'stamina_lost')
    if stamina_lost then
        return stamina_lost
    else
        return 0
    end
end
-- :staminaLostSet()
function staminaLostSet(self, v)
    return DB.setValue(self.db_node, 'stamina_lost', 'number', v)
end