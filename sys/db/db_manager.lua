local rules_name = "TroikaRPG";
local rules_major_version = 1;

function onInit()
	local _, _, aMajor, aMinor = DB.getRulesetVersion()
    Debug.console("manager_db.onInit", aMajor, aMinor)
	if User.isHost() then
		updateCampaign()
	end

	Module.onModuleLoad = onModuleLoad;
end


local default_db =
{
    ['shortcuts'] = {
        ['id-00001'] = {
            ['name'] = {'string', 'Character List'},
            ['order'] = {'number', 0},
            ['shortcut_class'] = {'string', 'character_viewer'},
            ['shortcut_db'] = {'string', 'character'},
        },
        ['id-00002'] = {
            ['name'] = {'string', 'NPC List'},
            ['order'] = {'number', 1},
            ['shortcut_class'] = {'string', 'npc_viewer'},
            ['shortcut_db'] = {'string', 'npc'},
        },
        ['id-00003'] = {
            ['name'] = {'string', 'Combat'},
            ['order'] = {'number', 2},
            ['shortcut_class'] = {'string', 'combat_fight'},
            ['shortcut_db'] = {'string', 'combat.fight.id-00001'},
        },
    },
    ['character'] = {
        ['id-00001'] = {
            ['luck'] = {'number', 10},
            ['name'] = {'string', 'name 1'},
            ['skill'] = {'number', 11},
            ['stamina'] = {'number', 12},
        },
        ['id-00002'] = {
            ['luck'] = {'number', 20},
            ['name'] = {'string', 'name 2'},
            ['skill'] = {'number', 21},
            ['stamina'] = {'number', 22},
        },
    },
    ['npc'] = {
        ['id-00002'] = {
            ['armour'] = {'number', 4},
            ['damage_as'] = {'string', 'Gigantic Beast'},
            ['description'] = {'string', 'DESCRIBE ME!!!'},
            ['initiative'] = {'number', 8},
            ['is_identified'] = {'number', 1},
            ['locked'] = {'number', 0},
            ['luck'] = {'number', 1},
            ['miens'] = {'string', 'M1, M2, M3, M4, M5, M6'},
            ['name'] = {'string', 'Dragon'},
            ['no_id_name'] = {'string', 'Something really big'},
            ['skill'] = {'number', 16},
            ['special'] = {'string', 'AM I SPECIAL?'},
            ['stamina'] = {'number', 32},
        },
    },
}




function onModuleLoad(sModule)
	local _, _, aMajor, aMinor = DB.getRulesetVersion(sModule)
    Debug.console("manager_db.onModuleLoad", aMajor, aMinor)
end

function updateCampaign()
	local _, _, aMajor, aMinor = DB.getRulesetVersion();
    Debug.console("manager_db.updateCampaign", aMajor, aMinor)

	local major = aMajor[rules_name]
	if major then
        if major > 0 and major < rules_major_version then
            DB.backup()
            if major < 0 then
            end
        end
    else
        dbSetup('', default_db)
	end

end


function dbSetup(path, tbl)
    for k,v in pairs(tbl) do
        n_path = path  .. k
        if v[1] then
            DB.setValue(n_path, v[1], v[2])
        else
            dbSetup(n_path .. '.', v)
        end
    end
end

