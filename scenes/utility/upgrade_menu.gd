extends Control
signal weapon_upgrade

const MAX_DAMAGE_BUY := 5
const MAX_FIRERATE_BUY := 3

const FIRERATE_COST := 1
const DAMAGE_COST := 2
const SHOTGUN_COST := 3
const MACHINEGUN_COST := 3

@onready var FireRateCost = $TextPopUp/VBoxContainer/Upgrades/UpgradeFireRate/CostText
@onready var DamageCost = $TextPopUp/VBoxContainer/Upgrades/UpgradeDamage/CostText
@onready var ShotgunCost = $TextPopUp/VBoxContainer/Weapons/BuyShotgun/CostText
@onready var MachineGunCost = $TextPopUp/VBoxContainer/Weapons/BuyMachineGun/CostText

@onready var FireRateButton = $TextPopUp/VBoxContainer/Upgrades/UpgradeFireRate/Buy
@onready var DamageButton = $TextPopUp/VBoxContainer/Upgrades/UpgradeDamage/Buy
@onready var ShotgunButton = $TextPopUp/VBoxContainer/Weapons/BuyShotgun/Buy
@onready var MachineGunButton = $TextPopUp/VBoxContainer/Weapons/BuyMachineGun/Buy

var available_crystals: int

func _ready():
	$TextPopUp/VBoxContainer/Info/CurrentLevel/Value.text = str(Globals.current_level)
	$TextPopUp/VBoxContainer/Upgrades/MaxFireRate.text = '(max buy ' + str(MAX_FIRERATE_BUY) + ')'
	$TextPopUp/VBoxContainer/Upgrades/MaxDamage.text = '(max buy ' + str(MAX_DAMAGE_BUY) + ')'
	FireRateCost.text = str(FIRERATE_COST) + ' X'
	DamageCost.text = str(DAMAGE_COST) + ' X'
	ShotgunCost.text = str(SHOTGUN_COST) + ' X'
	MachineGunCost.text = str(MACHINEGUN_COST) + ' X'
	_update_crystal_count()
	_disable_buy_buttons()

func _disable_buy_buttons():
	if Globals.firerate_upgrades == MAX_FIRERATE_BUY or available_crystals < FIRERATE_COST:
		FireRateButton.disabled = true
	if Globals.damage_upgrades == MAX_DAMAGE_BUY or available_crystals < DAMAGE_COST:
		DamageButton.disabled = true
	if Globals.inventory[Globals.WeaponEnum.SHOTGUN] or available_crystals < SHOTGUN_COST:
		ShotgunButton.disabled = true
	if Globals.inventory[Globals.WeaponEnum.MACHINE_GUN] or available_crystals < MACHINEGUN_COST:
		MachineGunButton.disabled = true

func _update_crystal_count():
	available_crystals = Globals.crystals_collected - Globals.crystals_spent
	$TextPopUp/VBoxContainer/Info/CrystalsCount/Value.text = str(available_crystals)

func _on_buy_firerate_pressed() -> void:
	Globals.crystals_spent += FIRERATE_COST
	Globals.firerate_upgrades += 1
	_update_crystal_count()
	_disable_buy_buttons()
	emit_signal('weapon_upgrade')

func _on_buy_damage_pressed() -> void:
	Globals.crystals_spent += DAMAGE_COST
	Globals.damage_upgrades += 1
	_update_crystal_count()
	_disable_buy_buttons()
	emit_signal('weapon_upgrade')

func _on_buy_shotgun_pressed() -> void:
	Globals.crystals_spent += SHOTGUN_COST
	Globals.inventory[Globals.WeaponEnum.SHOTGUN] = true
	_update_crystal_count()
	_disable_buy_buttons()

func _on_buy_machinegun_pressed() -> void:
	Globals.crystals_spent += MACHINEGUN_COST
	Globals.inventory[Globals.WeaponEnum.MACHINE_GUN] = true
	_update_crystal_count()
	_disable_buy_buttons()

func _on_continue_button_pressed() -> void:
	hide()
	get_tree().paused = false
