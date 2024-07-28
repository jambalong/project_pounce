class_name DebugBox
extends HBoxContainer

var value_function: Callable

@onready var value: Label = $Value


func _process(_delta: float) -> void:
	var result = value_function.call()
	value.text = (result if typeof(result) == TYPE_STRING else "%.2f" % result) if not typeof(result) == TYPE_BOOL else ("true" if result else "false")
