extends Area2D


signal select(id)

export var id:int

onready var base = get_node("/root/base")
onready var player = get_node("/root/base/player")
onready var anim = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("select", base, "_on_respawn_set")
	base.connect("set_respawn", self, "_on_room_respawn_set")

func check_respawn(target):
	if int(target) == id:
		player.position = position

func _on_room_respawn_set(respawn_id):
	print("??" + str(respawn_id))
	if respawn_id != self.id:
		anim.play("become_not_active")
		
func _on_respawn_body_entered(body):
	if body.is_in_group("player") && base.state == "play":
		emit_signal("select", id)
		anim.play("become_active")
