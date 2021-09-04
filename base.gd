extends Node2D

var state = "play"
var respawn = 0
var level = 1

signal start_respawn(id)

onready var anim = $anim
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_respawn_set(id):
	respawn = id

func on_respawn(play=true):
	if play:
		anim.play("fade")
	state = "pause"
	if play:
		yield(anim, "animation_finished")
	propagate_call("check_respawn", [respawn])
	if play:
		anim.play_backwards("fade")
		yield(anim, "animation_finished")
	state = "play"
	
func next_level():
	level += 1
	respawn = 1
	change_scene("res://levels/"+str(level)+".tscn")
	
func change_scene(path):
	state = "pause"
	anim.play("fade")
	yield(anim, "animation_finished")
	
	for i in get_children():
		if i.is_in_group("room"):
			i.queue_free()
			
	var newroom = load(path).instance()
	call_deferred("add_child", newroom)
	newroom.call_deferred("on_scene_change")
	yield(newroom, "change_done")

	yield(get_tree().create_timer(0.4), "timeout")
	state = "play"
	
	anim.play_backwards("fade")
	yield(anim, "animation_finished")
