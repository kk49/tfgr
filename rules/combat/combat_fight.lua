local combat_actors = 'combat.fight.id-00001.actor'
local combat_turns = 'combat.fight.id-00001.round.id-00001.turn'

local turn_count = 0
local turn_id = nil

-- Turn state
local db_actor_chits = {}
local db_actor_chits_used = {}
local db_actor_stamina = {}
local db_actor_stamina_lost = {}
local db_actor_to_combat_actor = {}
local db_actor_to_name = {}
local db_actor_to_link_window = {}
local end_of_round_occurred = false
local total_chits = 0
local total_chits_used = 0

function onInit()
    Gui.onInitEntered('combat_fight', self)
    fightProcessDatabase()
    fightDisplayState()
end

function onFirstLayout()
    Gui.onFirstLayoutEntered('combat_fight', self)
end

function fightProcessDatabase()
    -- calculate state
    db_actor_chits = {}
    db_actor_chits_used = {}

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

        actor = Core.dbCast(link_db_ref, Combat.k_interface_combat_actor)
        name = actor:nameGet()
        initiative = actor:initiativeGet()
        stamina = actor:staminaGet()
        stamina_lost = actor:staminaLostGet()

        db_actor_to_combat_actor[link_db_ref] = id
        db_actor_to_link_window[link_db_ref] = link_window
        db_actor_to_name[link_db_ref] = name
        db_actor_chits[link_db_ref] = initiative
        db_actor_chits_used[link_db_ref] = 0
        db_actor_stamina[link_db_ref] = stamina
        db_actor_stamina_lost[link_db_ref] = stamina_lost
        total_chits = total_chits + initiative
    end
    total_chits = total_chits + 1  -- add one chit for the end of round


    turns = DB.getChildren(combat_turns)
    for id, node in pairs(turns) do
        action = DB.getValue(node, 'action')
        link_db_ref = DB.getValue(node, 'link_db_ref')

        if Combat.k_action_end_of_round == action then
            end_of_round_occurred = true
            total_chits_used = total_chits_used + 1
        else
            if db_actor_chits_used[link_db_ref] then
                if Combat.k_action_aim == action then
                    total_chits_used = total_chits_used + 1
                    db_actor_chits_used[link_db_ref] = db_actor_chits_used[link_db_ref] + 1
                elseif Combat.k_action_delay == action then
                    -- pass
                elseif Combat.k_action_done == action then
                    total_chits_used = total_chits_used + 1
                    db_actor_chits_used[link_db_ref] = db_actor_chits_used[link_db_ref] + 1
                end
            else
                -- handle case where actors were removed and turns were left
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

        stamina = db_actor_stamina[link_db_ref]
        stamina_lost = db_actor_stamina_lost[link_db_ref]
        stamina_remaining = stamina - stamina_lost
        DB.setValue(node, 'stamina_cur', 'number', stamina_remaining)
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
            action = Combat.k_action_end_of_round
            link_db_ref = ''
            link_window = ''
        end

        turn_db = DB.createNode(turn_id)
        DB.setValue(turn_db, 'name', 'string', name)
        DB.setValue(turn_db, 'action', 'string', action)
        DB.setValue(turn_db, 'turn_number', 'number', turn_count)
        DB.setValue(turn_db, 'link_db_ref', 'string', link_db_ref)
        DB.setValue(turn_db, 'link_window', 'string', link_window)

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
    fightActonPerform (Combat.k_action_done)
end


function cmdTurnDelay()
    print('cmdTurnDelay')
    fightActonPerform (Combat.k_action_delay)
end


function cmdTurnAim()
    print('cmdTurnAim')
    fightActonPerform (Combat.k_action_aim)
end


function onDrop(x, y, drag_info)
    if drag_info.isType('shortcut') then
        link_window, link_db_ref = drag_info.getShortcutData()
        prefix = string.match(link_db_ref, '^([^.]*)')

        -- check to make sure combat_actor does not exist for this add_actor

        new_index, new_id = DbManager.generateNextId(
            combat_actors,
            function (dbn) return not (link_db_ref == DB.getValue(dbn, 'link_db_ref')) end
        )

        actor = nil
        if new_index then
            actor = Core.dbCast(link_db_ref, Combat.k_interface_combat_actor)
        end

        if actor then
            name = actor:nameGet()
            initiative = actor:initiativeGet()
            stamina = actor:staminaGet()
            stamina_lost = actor:staminaLostGet()

            actor_db = DB.createNode(new_id)
            DB.setValue(actor_db, 'name', 'string', name)
            DB.setValue(actor_db, 'initiative_cur', 'number', initiative)
            DB.setValue(actor_db, 'initiative_max', 'number', initiative)
            DB.setValue(actor_db, 'stamina_cur', 'number', stamina - stamina_lost)
            DB.setValue(actor_db, 'stamina_max', 'number', stamina)
            DB.setValue(actor_db, 'link_window', 'string', link_window)
            DB.setValue(actor_db, 'link_db_ref', 'string', link_db_ref)

            return true
        end
    end

    return false
end

