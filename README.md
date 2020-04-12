# Troika!_fantasy grounds_ruleset
Troika! ruleset implemented in fantasy grounds

# TODO
- Setup Character
- Setup Combat tracker
- Make Enemy sheet look like main rule book layout
- Mien should be per enemy table, with role button?
- Damage as dropdown based on values from table
- options!!!
  - Background

  

* Object
  * classGet() -> str
  * classIs(class) -> bool
  * classesGet() -> {str}

## Reference info
* EquipRef
  * Name
  * Description
  
* WeaponRef(EquipRef)
  * DamageTable[7]
   
* AdvSkillsRef
  * Name
  * Description
  * RefTables
  
* SpellsRef
  * Name
  * Description
  * Cost
  * RefTables

* BestiaryRef
  * Name
  * TagLine
  * Description
  * Skill
  * Stamina
  * Initiative
  * Armour
  * Damage as
  * Mien[6]  # reference to Generic table?
  * Special

* BackgroundRef
  * Name
  * TagLine
  * Description
  * EquipRef[]
  * AdvSkillsRef[]
  * Special

* CharacterSheetRef

  
## Runtime
* Equip
  * ref_link: EquipRef 
  * notes
  
* Weapon
  * ref_link: WeaponRef 
  * notes
  
* AdvSkills
  * AdvSkillsRef
  * Rank
  * SuccessCount

* Actor
  * Damage
  * Faction
  
* Character(Actor)
  * ref_link: BackgroundRef
  * Skill: number
  * Stamina: number
  * //Damage: number
  * Luck: number
  * LuckSpent: number
  * Wearing: str
  * Monies
  * Provisions
  * Skills: AdvSkills[]
  * Weapons: Weapon[]
  * Inventory: Equip[]

* Npc(Actor)
  * ref_link: BestiaryRef 
  * //Damage: Number

### Combat
Action passed to actors, wait for update to change display
record has cached display values, actual records should be in Actor
  
* CombatActor
  * ref_link: Actor
  
* CombatTurn
  * ref_link: CombatActor
  
* CombatRound
  * actors: CombatActor[]
  * turns: CombatTurn[]
  
* CombatTracker
  * rounds: CombatRound[]
  
