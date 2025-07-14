extends Area2D
class_name BaseAOE 

@export var aoe_ability: String

enum call_state{
	Start,
	Hold,
	End
}

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_despawn_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body):
	if aoe_ability != null:
		if body.has_method(aoe_ability):
			var ability = Callable(body, aoe_ability)
			ability.call(call_state.Start)

func _on_body_exited(body):
	if aoe_ability != null:
		if body.has_method(aoe_ability):
			var ability = Callable(body, aoe_ability)
			ability.call(call_state.End)
