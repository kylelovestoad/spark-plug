extends CPUParticles2D

@export 
var state_machine: Node

@export 
var grapple_state: State

func _physics_process(delta: float) -> void:
	visible = state_machine.current_state == grapple_state
