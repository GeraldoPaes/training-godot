extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCELERATION = 50
const MAX_SPEED = 200
const JUMP_HEIGHT = -500

# Friction values - Speed Reduction Rate Percentage
const AIR_FRICTION = 0.05
const GROUND_FRICTION = 0.2

var motion = Vector2()

func _process(delta):
	var friction = false
	
	motion.y += GRAVITY
	
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		$Sprite.flip_h = false
		$Sprite.play("Run")
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		$Sprite.flip_h = true
		$Sprite.play("Run")
	else:
		$Sprite.play("Idle")
		friction = true
		
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
		if friction: # Ground friction (Reduces h_speed 20% each frame)
			motion.x *= (1 - GROUND_FRICTION)
	else:
		if motion.y < 0:
			$Sprite.play("Jump")
		else:
			$Sprite.play("Fall")
		
		if friction: # Air friction (Reduces h_speed 5% each frame)
			motion.x *= (1 - AIR_FRICTION)

	motion = move_and_slide(motion, UP)
