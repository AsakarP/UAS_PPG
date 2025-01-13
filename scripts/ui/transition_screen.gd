extends CanvasLayer

# Transition Screen
signal on_transition_finished

@onready var colorRect = $ColorRect
@onready var animationPlayer = $AnimationPlayer

func _ready():
	colorRect.visible = false
	animationPlayer.animation_finished.connect(onAnimFinished)
		
func onAnimFinished(animName):
	if animName == "fade_to_black":
		on_transition_finished.emit()
		animationPlayer.play("fade_to_normal")
	elif animName == "fade_to_normal":
		colorRect.visible = false
	
func transition():
	colorRect.visible = true
	animationPlayer.play("fade_to_black")
