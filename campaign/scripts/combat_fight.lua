local combat_actors = 'combat.fight.id-00001.actor'
local combat_turns = 'combat.fight.id-00001.round.id-00001.turn'

local turn_count = 0
local turn_id = nil

-- Turn state
local db_actor_chits = {}
local db_actor_chits_used = {}
local db_actor_is_enemy = {}
local db_actor_to_combat_actor = {}
local db_actor_to_name = {}
local db_actor_to_link_window = {}
local end_of_round_occurred = false
local total_chits = 0
local total_chits_used = 0

function onInit()
    Core.onInitEntered('combat_fight', self)
    fightProcessDatabase()
    fightDisplayState()
end

function onFirstLayout()
    Core.onFirstLayoutEntered('combat_fight', self)
end

function fightProcessDatabase()
    -- calculate state
    db_actor_chits = {}
    db_actor_chits_used = {}
    db_actor_is_enemy = {}

    db_actor_to_combat_actor = {}
    db_actor_to_name = {}
    db_actor_to_link_window = {}

    end_of_round_occurred = false
    total_chits = 0
    total_chits_used = 0


    actors = DB.getChildren(combat_actors)
    for id, node in pairs(actors) do
        link_db_ref = DB.getValue(node, 'link_db_ref')
        link_window = DB.getValue(node, 'link_window')
        name = DB.getValue(node, 'name')
        initiative = DB.getValue(node, 'initiative_max')
        prefix = string.match(link_db_ref, '^([^.]*)')

        db_actor_to_combat_actor[link_db_ref] = id
        db_actor_to_link_window[link_db_ref] = link_window
        db_actor_to_name[link_db_ref] = name
        db_actor_chits[link_db_ref] = initiative
        db_actor_chits_used[link_db_ref] = 0
        total_chits = total_chits + initiative
        if prefix == 'npc' then
            db_actor_is_enemy[link_db_ref] = true
        elseif prefix == 'character' then
            db_actor_is_enemy[link_db_ref] = false
        end
    end
    total_chits = total_chits + 1  -- add one chit for the end of round


    turns = DB.getChildren(combat_turns)
    for id, node in pairs(turns) do
        name = DB.getValue(node, 'name')
        action = DB.getValue(node, 'action')
        turn_number = DB.getValue(node, 'turn_number')
        link_window = DB.getValue(node, 'link_window')
        link_db_ref = DB.getValue(node, 'link_db_ref')

        if CombatManager.k_action_end_of_round == action then
            end_of_round_occurred = true
            total_chits_used = total_chits_used + 1
        else
            if CombatManager.k_action_aim == action then
                total_chits_used = total_chits_used + 1
                db_actor_chits_used[link_db_ref] = db_actor_chits_used[link_db_ref] + 1
            elseif CombatManager.k_action_delay == action then
                -- pass
            elseif CombatManager.k_action_done == action then
                total_chits_used = total_chits_used + 1
                db_actor_chits_used[link_db_ref] = db_actor_chits_used[link_db_ref] + 1
            end
        end
    end
end


function fightDisplayState()
    actors = DB.getChildren(combat_actors)
    for id, node in pairs(actors) do
        link_db_ref = DB.getValue(node, 'link_db_ref')

        chits_available = db_actor_chits[link_db_ref]
        chits_used = db_actor_chits_used[link_db_ref]
        chits_remaining = chits_available - chits_used

        DB.setValue(node, 'initiative_cur', 'number', chits_remaining)
    end
end


function processNextTurn()
    if not end_of_round_occurred then
        -- calculate next chit
        active_chits = total_chits - total_chits_used

        chit_number = math.random(active_chits)
        print(string.format('Rolled %d of %d out of %d', chit_number, active_chits, total_chits))

        winner = nil
        for link_db_ref, chits_available in pairs(db_actor_chits) do
            chits_used = db_actor_chits_used[link_db_ref]

            chits_remaining = chits_available - chits_used
            chit_number = chit_number - chits_remaining
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
            link_window = db_actor_to_link_window[winner]
        else
            print(string.format('Turn %d: END OF ROUND', turn_count))
            name = 'END OF ROUND'
            action = CombatManager.k_action_end_of_round
            link_db_ref = ''
            link_window = ''
        end

        DB.setValue(turn_id .. '.name', 'string', name)
        DB.setValue(turn_id .. '.action', 'string', action)
        DB.setValue(turn_id .. '.turn_number', 'number', turn_count)
        DB.setValue(turn_id .. '.link_db_ref', 'string', link_db_ref)
        DB.setValue(turn_id .. '.link_window', 'string', link_window)

        fightProcessDatabase()
        fightDisplayState()
    end
end


function fightActonPerform(action)
    if turn_id then
        last_action = DB.getValue(turn_id .. '.action')
        if not last_action or last_action == '' then
            DB.setValue(turn_id .. '.action', 'string', action)
        end
        fightProcessDatabase()
    end
    processNextTurn()
end


function fightRoundReset()
    turn_count = 0
    turn_id = nil
    end_of_round_occurred = false
    DB.deleteChildren(combat_turns)
    fightProcessDatabase()
    fightDisplayState()
end


function cmdRoundNext()
    print('cmdRoundNext')
    fightRoundReset()
end


function cmdTurnNext()
    print('cmdTurnNext')
    fightActonPerform (CombatManager.k_action_done)
end


function cmdTurnDelay()
    print('cmdTurnDelay')
    fightActonPerform (CombatManager.k_action_delay)
end


function cmdTurnAim()
    print('cmdTurnAim')
    fightActonPerform (CombatManager.k_action_aim)
end




function onDrop(x, y, drag_info)
    if drag_info.isType('shortcut') then
        link_window, link_db_ref = drag_info.getShortcutData()
        prefix = string.match(link_db_ref, '^([^.]*)')

        -- check to make sure combat_actor does not exist for this add_actor
        actors = DB.getChildren(combat_actors)

        add_actor = true
        max_id = -1
        for actor_id, actor_node in pairs(actors) do
            db_ref = DB.getValue(actor_node, 'link_db_ref')
            if db_ref == link_db_ref then
                Debug.console('Actor already exists: ', link_db_ref)
                add_actor = false
                break
            end

            id_number = string.match(actor_id, 'id%-(%d+)')
            id_number = tonumber(id_number)
            if id_number and id_number > max_id then
                max_id = id_number
            end
        end

        if add_actor then
            if 'npc' == prefix then
                name = DB.getValue(link_db_ref .. '.name')
                initiative = DB.getValue(link_db_ref .. '.initiative')

                add_actor = true
            elseif 'character' == prefix then
                name = DB.getValue(link_db_ref .. '.name')
                initiative = 2

                add_actor = true
            end
        end

        if add_actor then
            actor_new = combat_actors .. string.format('.id-%05d', max_id + 1)
            DB.setValue(actor_new .. '.name', 'string', name)
            DB.setValue(actor_new .. '.initiative_cur', 'number', initiative)
            DB.setValue(actor_new .. '.initiative_max', 'number', initiative)
            DB.setValue(actor_new .. '.link_window', 'string', link_window)
            DB.setValue(actor_new .. '.link_db_ref', 'string', link_db_ref)
            return true
        end
    end

    return false
end

