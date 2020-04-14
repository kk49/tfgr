function onInit()
	Debug.console("manager_character: onInit")
	Core.classRegister('character..[^.]+', objectCast)
end

function objectCast(db_path, cast_to)
    if Combat.k_interface_combat_actor then
        return {
            db_node = DB.findNode(db_path),
            nameGet = interface_combat_actor_nameGet,
            initiativeGet = interface_combat_actor_initiativeGet,
            staminaGet = interface_combat_actor_staminaGet,
            staminaLostGet = interface_combat_actor_staminaLostGet,
            staminaLostSet = interface_combat_actor_staminaLostSet,
        }
    end
end

--k_interface_combat_actor = 'CombatActor'
-- :nameGet()
function interface_combat_actor_nameGet(self)
    return DB.getValue(self.db_node,'name')
end
-- :initiativeGet()
function interface_combat_actor_initiativeGet(self)
    return 2
end
-- :staminaGet()
function interface_combat_actor_staminaGet(self)
    return DB.getValue(self.db_node,'stamina')
end
-- :staminaLostGet()
function interface_combat_actor_staminaLostGet(self)
    stamina_lost = DB.getValue(self.db_node,'stamina_lost')
    if stamina_lost then
        return stamina_lost
    else
        return 0
    end
end
-- :staminaLostSet()
function interface_combat_actor_staminaLostSet(self, v)
    return DB.setValue(self.db_node, 'stamina_lost', 'number', v)
end