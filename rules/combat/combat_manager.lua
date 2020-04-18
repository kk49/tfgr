
-- # DEFINE
-- ## Common
k_action_aim = 'AIM'
k_action_delay = 'DELAY'
k_action_done = 'DONE'
k_action_end_of_round = 'EOR'
k_what_combat_round = 'round'

-- ## Object interfaces
k_interface_combat_actor = 'CombatActor'
-- :nameGet()
-- :initiativeGet()
-- :initiativeUsedGet()
-- :initiativeUsedSet()
-- :staminaGet()
-- :staminaUsedGet()
-- :staminaUsedSet()

-- ## OOB interfaces
k_OOB_COMBAT_RESET = 'OOB_COMBAT_RESET'
k_OOB_COMBAT_DROPPED = 'OOB_COMBAT_DROPPED'
k_OOB_COMBAT_ACTION = 'OOB_COMBAT_ACTION'

-- ## functionality
local combat_actors = 'combat.fight.id-00001.actor'
local combat_turns = 'combat.fight.id-00001.round.id-00001.turn'

-- Round State, tracks state of turns so turn id and turn count does not have to be redetermined every time
local turn_count = nil
local turn_id = nil


-- Round Info to pass data between state determination and display
local total_initiative = 0
local total_initiative_used = 0
local db_actor_initiative = {}
local db_actor_initiative_used = {}
local db_actor_stamina = {}
local db_actor_stamina_used = {}
local db_actor_to_combat_actor = {}
local db_actor_to_name = {}
local end_of_round_occurred = false

function onInit()
	Debug.console("manager_combat: onInit")
	OOBManager.registerOOBMsgHandler(k_OOB_COMBAT_RESET, combatHandleReset)
	OOBManager.registerOOBMsgHandler(k_OOB_COMBAT_DROPPED, combatHandleDropped)
	OOBManager.registerOOBMsgHandler(k_OOB_COMBAT_ACTION, combatHandleAction)
end

-- ## Client
function requestRoundReset()
    -- TODO check for host status and whose turn it is, only GM and owner of active actor can do certain requests
    msg = {}
    msg.type = Combat.k_OOB_COMBAT_RESET
    msg.what = k_what_combat_round
    Comm.deliverOOBMessage(msg);
    return true
end

function requestDropAccept(x, y, drag_info)
    -- TODO check for host status and whose turn it is, only GM and owner of active actor can do certain requests
    if drag_info.isType('shortcut') then
        _, link_db_ref = drag_info.getShortcutData()  -- we are tracking the link window thru core

        if actorCastAndIsNew(link_db_ref) then
            msg = {}
            msg.type = Combat.k_OOB_COMBAT_DROPPED
            msg.link_db_ref = link_db_ref
            Comm.deliverOOBMessage(msg);
            return true
        end
    end

    return false
end

function requestFightAction(action)
    -- TODO check for host status and whose turn it is, only GM and owner of active actor can do certain requests
    msg = {}
    msg.type = Combat.k_OOB_COMBAT_ACTION
    msg.action = action
    Comm.deliverOOBMessage(msg);
    return true
end


-- ## Server
function combatHandleReset(msg)
    if msg.what == k_what_combat_round then
        turn_count = nil
        turn_id = nil
        DB.deleteChildren(combat_turns)
        fightProcessDatabase()
    end
end


function actorCastAndIsNew(link_db_ref)
    -- check to make sure combat_actor does not exist for this add_actor
    new_index, new_id = DbManager.generateNextId(
        combat_actors,
        function (dbn) return not (link_db_ref == DB.getValue(dbn, 'link_db_ref')) end
    )

    -- "cast" db link to combat actor object
    actor = nil
    if new_index then
        actor = Core.dbCast(link_db_ref, Combat.k_interface_combat_actor)
    end

    return actor
end

function combatHandleDropped(msg)
    link_db_ref = msg.link_db_ref
    if not link_db_ref then
        Core.error('Combat.combatHandleDropped : bad message received: ' .. tostring(msg))
    else
        actor = actorCastAndIsNew(link_db_ref)

        if actor then
            name = actor:nameGet()
            initiative = actor:initiativeGet()
            stamina = actor:staminaGet()
            stamina_used = actor:staminaUsedGet()

            actor_db = DB.createNode(new_id)
            DB.setValue(actor_db, 'name', 'string', name)
            DB.setValue(actor_db, 'link_db_ref', 'string', link_db_ref)
            DB.setValue(actor_db, 'initiative_cur', 'number', initiative)
            DB.setValue(actor_db, 'initiative_max', 'number', initiative)
            DB.setValue(actor_db, 'stamina_cur', 'number', stamina - stamina_used)
            DB.setValue(actor_db, 'stamina_max', 'number', stamina)
        end
    end
end

function combatHandleAction(msg)
    if k_action_aim == msg.action then
        fightActonPerform(msg.action)
    elseif k_action_delay == msg.action then
        fightActonPerform(msg.action)
    elseif k_action_done == msg.action then
        fightActonPerform(msg.action)
    end
end

-- function fightLoad(fight_id)
-- function roundLoad(fight_id, round_id)


function fightProcessDatabase()
    -- calculate state
    db_actor_initiative = {}
    db_actor_initiative_used = {}

    db_actor_to_combat_actor = {}
    db_actor_to_name = {}

    end_of_round_occurred = false
    total_initiative = 0
    total_initiative_used = 0

    -- get source actor state
    db_actor_map = {}
    actors = DB.getChildren(combat_actors)
    for id, node in pairs(actors) do
        link_db_ref = DB.getValue(node, 'link_db_ref')
        actor =  Core.dbCast(link_db_ref, k_interface_combat_actor)
        db_actor_map[link_db_ref] = actor

        name = actor:nameGet()
        initiative = actor:initiativeGet()
        stamina = actor:staminaGet()
        stamina_used = actor:staminaUsedGet()

        db_actor_to_combat_actor[link_db_ref] = id
        db_actor_to_name[link_db_ref] = name
        db_actor_initiative[link_db_ref] = initiative
        db_actor_initiative_used[link_db_ref] = 0
        db_actor_stamina[link_db_ref] = stamina
        db_actor_stamina_used[link_db_ref] = stamina_used
        total_initiative = total_initiative + initiative
    end
    total_initiative = total_initiative + 1  -- add one chit for the end of round

    -- get state of current fight
    turn_count = 0
    turns = DB.getChildren(combat_turns)
    for id, node in pairs(turns) do
        node_turn_count = DB.getValue(node, 'turn_number')
        if turn_count < node_turn_count then
            turn_count = node_turn_count
            turn_id = combat_turns .. '.' .. id
        end

        action = DB.getValue(node, 'action')
        link_db_ref = DB.getValue(node, 'link_db_ref')

        if k_action_end_of_round == action then
            end_of_round_occurred = true
            total_initiative_used = total_initiative_used + 1
        else
            if db_actor_initiative_used[link_db_ref] then
                if k_action_aim == action then
                    total_initiative_used = total_initiative_used + 1
                    db_actor_initiative_used[link_db_ref] = db_actor_initiative_used[link_db_ref] + 1
                elseif k_action_delay == action then
                    -- pass
                elseif k_action_done == action then
                    total_initiative_used = total_initiative_used + 1
                    db_actor_initiative_used[link_db_ref] = db_actor_initiative_used[link_db_ref] + 1
                end
            else
                -- handle case where actors were removed and turns were left
            end
        end
    end

    -- update source actors
    actors = DB.getChildren(combat_actors)
    for id, node in pairs(actors) do
        link_db_ref = DB.getValue(node, 'link_db_ref')
        actor = db_actor_map[link_db_ref]

        actor:initiativeUsedSet(db_actor_initiative_used[link_db_ref])
        actor:staminaUsedSet(db_actor_stamina_used[link_db_ref])
    end
end

function processNextTurn()
    if not turn_count then
        fightProcessDatabase()
    end

    if not end_of_round_occurred then
        -- calculate next chit
        active_initiative = total_initiative - total_initiative_used

        chit_number = math.random(active_initiative)
        print(string.format('Rolled %d of %d out of %d', chit_number, active_initiative, total_initiative))

        winner = nil
        for link_db_ref, initiative_available in pairs(db_actor_initiative) do
            initiative_used = db_actor_initiative_used[link_db_ref]

            initiative_remaining = initiative_available - initiative_used
            chit_number = chit_number - initiative_remaining
            if chit_number <= 0 then
                winner = link_db_ref
                break
            end
        end

        turn_count = turn_count + 1
        turn_id = combat_turns .. string.format('.id-%05d', turn_count)

        if winner then
            print(string.format('Turn %d: Winner is %s', turn_count, winner))
            name = db_actor_to_name[winner]
            action = ''
            link_db_ref = winner
        else
            print(string.format('Turn %d: END OF ROUND', turn_count))
            name = 'END OF ROUND'
            action = k_action_end_of_round
            link_db_ref = ''
        end

        turn_db = DB.createNode(turn_id)
        DB.setValue(turn_db, 'name', 'string', name)
        DB.setValue(turn_db, 'action', 'string', action)
        DB.setValue(turn_db, 'turn_number', 'number', turn_count)
        DB.setValue(turn_db, 'link_db_ref', 'string', link_db_ref)

        fightProcessDatabase()
    end
end

function fightActonPerform(action)
    if not turn_count then
        fightProcessDatabase()
    end

    if turn_id then
        last_action = DB.getValue(turn_id .. '.action')
        if not last_action or last_action == '' then
            DB.setValue(turn_id .. '.action', 'string', action)
        end
        fightProcessDatabase()
    end
    processNextTurn()
end


