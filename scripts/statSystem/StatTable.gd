extends Resource

class_name StatTable

@export var stats: Dictionary = {
	"Vigor": Stat.new("Vigor", 0, 0, 0),
	"Strength": Stat.new("Strength", 0, 0, 0),
	"Agility": Stat.new("Agility", 0, 0, 0),
	"Defense": Stat.new("Defense", 0, 0, 0),
	"Intelligence": Stat.new("Intelligence", 0, 0, 0),
	"Luck": Stat.new("Luck", 0, 0, 0)
}

var vigor = Stat.new("vigor", 0, 0 ,0)

func add_stat_modifier(stat_name: String, mod_type: String, value: float):
	if stats.has(stat_name):
		stats[stat_name].add_modifier(mod_type, value)

func clear_all_modifiers():
	for stat in stats.values():
		stat.clear_modifiers()
