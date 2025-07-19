extends Resource
class_name Stat

signal stat_changed(stat_name: String, new_value: float)

# Private fields
var _name: String = ""
var _base_value: float = 0.0
var _current_value: float = 0.0
var _min_value: float = 0.0
var _max_value: float = 100.0

# Public properties
var name: String:
	get: return _name
	set(val): _name = val

var base_value: float:
	get: return _base_value
	set(val):
		_base_value = val
		emit_signal("changed", _name, _base_value)

var current_value: float:
	get: return _current_value
	set(val):
		_current_value = clamp(val, _min_value, _max_value)
		emit_signal("changed", _name, _current_value)

var min_value: float:
	get: return _min_value
	set(val):
		_min_value = val
		# Re-clamp current value if min changed
		current_value = _current_value

var max_value: float:
	get: return _max_value
	set(val):
		_max_value = val
		# Re-clamp current value if max changed
		current_value = _current_value

func _init(stat_name := "", base := 0.0, min := 0.0, max := 100.0):
	_name = stat_name
	_base_value = base
	_min_value = min
	_max_value = max
	_current_value = clamp(base, min, max)

# Modifiers
var flat_modifiers: Array = []
var percent_add_modifiers: Array = []
var percent_mult_modifiers: Array = []

func recalculate_modifiers() -> void:
	var result = _base_value
	
	for mod in flat_modifiers:
		result += mod
	
	var percent_add: = 0.0
	for mod in percent_add_modifiers:
		percent_add += mod
	result *= (1.0 * percent_add)
	
	for mod in percent_mult_modifiers:
		result *= mod
		
	current_value = result

func add_modifier(mod_type: String, value: float) -> void:
	match mod_type:
		"flat":
			flat_modifiers.append(value)
		"percent_add":
			percent_add_modifiers.append(value)
		"percent_mult":
			percent_mult_modifiers.append(value)
		_:
			push_error("Unknown modifier type: " + mod_type)
	recalculate_modifiers()

func clear_modifiers():
	flat_modifiers.clear()
	percent_add_modifiers.clear()
	percent_mult_modifiers.clear()
	recalculate_modifiers()
