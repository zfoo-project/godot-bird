extends RigidBody2D

const Common = preload("res://script/Common.gd")


@export var speed: float = Common.birdInitSpeed()
@export var flyUpSpeed: float = Common.birdFlyUpSpeed()

@export var cameraInitOffset: float = Common.cameraInitOffset()
@export var cameraSpeedUpOffset: float = Common.cameraSpeedUpOffset()
@export var cameraMoveSpeed: float = Common.cameraMoveSpeed()

@export var cameraOffset: float = Common.cameraInitOffset()
@export var hp: int = Common.birdInitHp()


var point: int = 0

# Size of the game window.
var screen_size

var isSpeedUp = false

var lastLinearVelocity: Vector2

signal hpChangedEvent(oldHp: int, hp: int)
signal attackEvent(other_body)

@onready var animated: AnimatedSprite2D = $AnimatedSprite2d
@onready var speedTimer: Timer = $Timer

func _ready():
	animated.animation = Main.currentAnimation
	screen_size = get_viewport_rect().size
	
	set_linear_velocity(Vector2(speed, 0))
	set_linear_damp(0)
	set_gravity_scale(Common.birdGravityScale())
	lastLinearVelocity = get_linear_velocity()

	set_contact_monitor(true)
	set_max_contacts_reported(1)
	connect("body_entered", Callable(self, "on_body_entered_event"))
	speedTimer.wait_time = Common.birdSpeedUpContinueTime()
	speedTimer.timeout.connect(onSpeedUpTimeout)
	fly()
	fly()
	pass


func _process(delta):
	if rotation < deg_to_rad(-30):
		rotation = deg_to_rad(-30)
		set_angular_velocity(0)
	if get_linear_velocity().y > 0:
		set_angular_velocity(3)
		if rotation > deg_to_rad(75):
			set_angular_velocity(6)

	if (animated.frame == 2):
		animated.stop()
		animated.frame =  0  
		set_gravity_scale(Common.birdGravityScale())
		
	position.y = clamp(position.y, 0, screen_size.y)
	
	if (isSpeedUp):
		cameraOffset = clamp(cameraOffset + cameraMoveSpeed * delta, cameraInitOffset, cameraSpeedUpOffset)
	else:
		cameraOffset = clampf(cameraOffset - cameraMoveSpeed * delta, cameraInitOffset, cameraSpeedUpOffset)
	
	lastLinearVelocity = get_linear_velocity()
	pass

func _input(event):
	if (event.is_pressed()):
		fly()
	pass

func fly():
	var ratio = 50000
	if linear_velocity.y > 500:
		set_linear_velocity(Vector2(speed, flyUpSpeed + 0.60))
	elif linear_velocity.y > 400:
		set_linear_velocity(Vector2(speed, flyUpSpeed + 0.65))
	elif linear_velocity.y > 300:
		set_linear_velocity(Vector2(speed, flyUpSpeed + 0.7))
	elif linear_velocity.y > 200:
		set_linear_velocity(Vector2(speed, flyUpSpeed + 0.8))
	elif linear_velocity.y > 100:
		set_linear_velocity(Vector2(speed, flyUpSpeed * 0.9))
	elif linear_velocity.y > 0:
		set_linear_velocity(Vector2(speed, flyUpSpeed))
	elif linear_velocity.y > -100:
		set_linear_velocity(Vector2(speed, flyUpSpeed * 1.1))
	elif linear_velocity.y > -200:
		set_linear_velocity(Vector2(speed, flyUpSpeed * 1.15))
	elif linear_velocity.y > -300:
		set_linear_velocity(Vector2(speed, flyUpSpeed * 1.2))
	elif linear_velocity.y > -400:
		set_linear_velocity(Vector2(speed, flyUpSpeed * 1.3))
	elif linear_velocity.y > -500:
		set_linear_velocity(Vector2(speed, flyUpSpeed * 1.4))
	else:
		set_linear_velocity(Vector2(speed, flyUpSpeed * 1.5))
	set_angular_velocity(-3)
	set_gravity_scale(0)
	animated.frame = 0
	animated.play()
	$wing.play()
	pass

func on_body_entered_event(other_body):
	if (isSpeedUp):
		if (other_body is AnimatableBody2D):
			emit_signal("attackEvent", other_body)
			$attack.play()
			set_linear_velocity(lastLinearVelocity)
		return
	var oldHp = hp
	$hit.play()
	hp = max(hp - 1, 0)
	emit_signal("hpChangedEvent", oldHp, hp)
	pass

func speedUp():
	speedTimer.start()
	speedTimer.one_shot = true
	$speedup.play()
	$SpeedUp.visible = true
	speed = speed + Common.birdSpeedUp()
	flyUpSpeed = Common.birdSpeedUpFlyUpSpeed()
	isSpeedUp = true
	pass

func onSpeedUpTimeout():
	speed = Common.birdInitSpeed()
	$speedup.stop()
	$speedup_end.play()
	$SpeedUp.visible = false
	flyUpSpeed = Common.birdFlyUpSpeed()
	isSpeedUp = false
	pass


