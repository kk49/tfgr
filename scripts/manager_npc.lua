function onInit()
    Debug.console("manager_npc: onInit");
	Core.classRegister('npc..[^.]+', objectCast)
end

function objectCast(db_path, cast_to)
    if Combat.k_interface_combat_actor then
        return {
            db_node = DB.findNode(db_path),
            nameGet = interface_combat_actor_nameGet,
            initiativeGet = interface_combat_actor_initiativeGet,
        }
    end
end

--k_interface_combat_actor = 'CombatActor'
-- :nameGet()
function interface_combat_actor_nameGet(self)
    return DB.getValue(self. db_node,'name')
end
-- :initiativeGet()
function interface_combat_actor_initiativeGet(self)
    return DB.getValue(self. db_node,'initiative')
end