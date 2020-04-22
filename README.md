# Troika!_fantasy grounds_ruleset
Troika! ruleset implemented in fantasy grounds

# TODO
- Gui
  - still missing at least two icons
  - window title text
  - window title icon?
  - layout engine update
  - scroll bar graphics
- Setup Character
- Setup Combat tracker
- Make Enemy sheet look like main rule book layout
- Mien should be per enemy table, with role button?
- Damage as dropdown based on values from table
- options!!!
- Background

-- OOB_COMBAT_ACTION
-- aim, delay, hit(with_what), shoot(with_what), 
-- spell(with_what), move(...), item_use(...), item_retrieve(...), grapple(...)

Weapons have ammunition / rounds / charge etc... reloading take getting the items out of your bag
Armour
Encomberance

* Object
  * classGet() -> str
  * classIs(class) -> bool
  * classesGet() -> {str}

## Reference info
* DamageTable
  * name
  * damage[7]
  * ignore_1_ap  // ignore 1 point of armour
  
* EquipWeaponRef
  * Name
  * Description
  * Special {Text, code?}
  * two_plus_handed T/F
  * OPTIONAL: DamageTable
  
* AdvSkillSpellRef
  * Name
  * Description
  * RefTables
  * OPTIONAL: SpellCost
  * OPTIONAL: DamageTable
  
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
  
## Assets
### Streamline Icons
[Free Icons from the Streamline Icons Pack](https://www.streamlineicons.com/)

