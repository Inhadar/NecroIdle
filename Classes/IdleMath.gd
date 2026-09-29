# Godot 4.x — GDScript 2.0
class_name IdleMath

# --- Tunable constants (balance knobs) ---
const TAP_GROWTH: float = 1.07            # per level
#const HERO_GROWTH_DEFAULT: float = 1.10   # per hero level (example)
const COST_GROWTH: float = 1.07           # per level
#const MONSTER_HP_EXP: float = 1.65        # stage exponent
#const BOSS_HP_MULT: float = 7.0           # boss tougher than normal
#const GOLD_PER_HP: float = 0.03           # gold = HP * c
#const OFFLINE_FACTOR: float = 0.6         # r = 60% efficiency
#const RELIC_COEFF: float = 0.02           # prestige relic coefficient

static func tap_income(base_damage: float, level: int) -> float:
	# Player tap damage grows exponentially with level
	return base_damage * pow(TAP_GROWTH,level)# base_damage x (1.07)**level

# Tek seviye maliyet
static func upgrade_cost(base_cost: float, level: int) -> float:
	return base_cost * pow(COST_GROWTH, level)

# Çoklu maliyet
static func upgrade_cost_multi(base_cost: float,current_level: int, count: int) -> float:
	# Geometric series: cost(l+1) + cost(l+2) + ... + cost(l+count)
	var total = base_cost * (pow(COST_GROWTH, current_level + 1) - pow(COST_GROWTH, current_level + count + 1)) / (1.0 - COST_GROWTH)
	return total



static func format_number(n: float):

	if n < 1000.0:
		return str(int(round(n)))
	elif n < 1000000.0:
		return str(snapped(n / 1000.0, 0.1)) + "K"
	elif n < 1000000000.0:
		return str(snapped(n / 1_000_000.0, 0.1)) + "M"
	elif n < 1000000000000.0:
		return str(snapped(n / 1000000000.0, 0.1)) + "B"
	else:
		return str(snapped(n / 1000000000000.0, 0.1)) + "T"
	

"""
static func hero_dps(base_dps: float, level: int, COST_GROWTH: float = HERO_GROWTH_DEFAULT) -> float:
	# Single hero DPS by level with exponential scaling
	return base_dps * pow(growth, float(level))

static func total_dps(heroes: Array) -> float:
	# heroes: Array of {base_dps: float, level: int, growth: float?}
	var total := 0.0
	for h in heroes:
		var g := h.get("growth", HERO_GROWTH_DEFAULT)
		total += hero_dps(h.base_dps, h.level, g)
	return total

static func is_boss_stage(stage: int) -> bool:
	# Example: every 5th stage is a boss stage
	return stage > 0 and stage % 5 == 0

static func monster_hp(base_hp: float, stage: int) -> float:
	# Base formula for regular monsters
	return base_hp * pow(float(stage), MONSTER_HP_EXP)

static func boss_hp(base_hp: float, stage: int) -> float:
	# Boss = tougher
	return monster_hp(base_hp, stage) * BOSS_HP_MULT

static func gold_drop(monster_hp_value: float, is_boss: bool) -> float:
	# Boss can drop more if you like; here we just reuse HP * c.
	var mult := is_boss ? 2.0 : 1.0
	return monster_hp_value * GOLD_PER_HP * mult

static func upgrade_cost(base_cost: float, level: int) -> float:
	# Exponential cost progression
	return base_cost * pow(COST_GROWTH, float(level))

static func prestige_relics(stage: int) -> float:
	# Relics ~ stage^1.5 * coeff
	return pow(float(stage), 1.5) * RELIC_COEFF

static func offline_gold(dps: float, seconds_offline: float, r: float = OFFLINE_FACTOR) -> float:
	# Gold while offline based on DPS and time
	return max(dps, 0.0) * max(seconds_offline, 0.0) * clamp(r, 0.0, 1.0)

"""
