extends Control


export var player_maxhp = 100
var player_hp
var player_played = false
var player_choice 
export var player_dp = 25
export var player_lv = 1
export var player_rm = 1.5
onready var player_healthbar = $Player/TextureProgress

export var opp_maxhp = 100
var opp_hp
var opp_played = false
var opp_choice 
export var opp_dp = 25
export var opp_lv = 1
export var opp_rm = 1.5
onready var opp_healthbar = $Opponent/TextureProgress


var current_round = 0
var choices = ["rock", "paper", "scissors"]
onready var rock = preload("res://sprites/rock.png")
onready var paper = preload("res://sprites/sheet.png")
onready var scissors = preload("res://sprites/scissors.png")
onready var question = preload("res://sprites/cranium-2028555_1280.png")
onready var non = preload("res://sprites/404.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	randomize()
	player_hp = player_maxhp
	opp_hp = opp_maxhp
	player_healthbar.max_value = player_maxhp
	opp_healthbar.max_value = opp_maxhp
	$TimerUI.max_value = $TimerUI/Timer.wait_time
	new_round()

func _process(_delta):
	player_healthbar.value = player_hp
	opp_healthbar.value = opp_hp
	$TimerUI.value = $TimerUI/Timer.time_left
	$Round.text = "ROUND "+str(current_round)
	$Player/Label.text = "LV: "+str(player_lv)+"\n"+"HP: "+str(player_hp)+"\n"+"DP: "+str(player_dp)+"\n"+"RM: "+str(player_rm)
	$Opponent/Label.text = "LV: "+str(opp_lv)+"\n"+"HP: "+str(opp_hp)+"\n"+"DP: "+str(opp_dp)+"\n"+"RM: "+str(opp_rm)
	health_colour()
	game_over()
#	if player_played and opp_played:
#		$TimerUI/Timer.stop()
#		compare_choices()

func health_colour():
	if player_hp >= player_maxhp/2:
		$Player/TextureProgress.self_modulate = ColorN("Green")
	elif player_hp < player_maxhp/2 and player_hp>player_maxhp/4:
		$Player/TextureProgress.self_modulate = ColorN("Yellow")
	elif player_hp <= player_maxhp/4:
		$Player/TextureProgress.self_modulate = ColorN("Red")

	if opp_hp >= opp_maxhp/2:
		$Opponent/TextureProgress.self_modulate = ColorN("Green")
	elif opp_hp < opp_maxhp/2 and opp_hp > opp_maxhp/4:
		$Opponent/TextureProgress.self_modulate = ColorN("Yellow")
	elif opp_hp <= opp_maxhp/4:
		$Opponent/TextureProgress.self_modulate = ColorN("Red")

func com_play():
	$ComTimer.wait_time = choose([1,2,3,2.5,1.5,0.5])
	$ComTimer.start()
	print($ComTimer.wait_time)

func _on_Timer_timeout():
	if player_played or opp_played:
		compare_choices()
	else:
		$TimerUI/Timer.start()

func choose(array):
	array.shuffle()
	return array.front()

func _on_Button_pressed():
	if not player_played:
		player_choice = "rock"
		$Player/Sprite.texture = rock
		player_played = true
		print(player_choice)


func _on_Button1_pressed():
	if not player_played:
		player_choice = "paper"
		$Player/Sprite.texture = paper
		player_played = true
		print(player_choice)


func _on_Button2_pressed():
	if not player_played:
		player_choice = "scissors"
		$Player/Sprite.texture = scissors
		player_played = true
		print(player_choice)


func _on_ComTimer_timeout():
	opp_choice = choose(choices)
	opp_played = true
#	print("opp: ",opp_choice)

func battle(winr):
	print("winner is ",winr)
	if winr == "player":
		$AnimationPlayer.play("player_attack")
	if winr == "opp":
		$AnimationPlayer.play("opp_attack")
	if winr == "none":
		$AnimationPlayer.play("draw")
		

func compare_choices():
	show_card()
	var winner
	if player_choice == "rock":
		if opp_choice == "rock":
			winner = "none"
		if opp_choice == "paper":
#			player_hp -= opp_dp
			winner ="opp"
		if opp_choice == "scissors":
#			opp_hp -= player_dp
			winner = "player"
		battle(winner)

	if player_choice == "paper":
		if opp_choice == "rock":
#			opp_hp -= player_dp
			winner = "player"
		if opp_choice == "paper":
			winner = "none"
		if opp_choice == "scissors":
#			player_hp -= opp_dp
			winner = "opp"
		battle(winner)
			
	if player_choice == "scissors":
		if opp_choice == "rock":
#			player_hp -= opp_dp
			winner = "opp"
		if opp_choice == "paper":
#			opp_hp -= player_dp
			winner = "player"
		if opp_choice == "scissors":
			winner = "none"
		battle(winner)
	if player_choice == "non" and opp_choice != "non":
		winner = "opp"
		battle(winner)
	elif opp_choice == "non" and player_choice != "non":
		winner = "player"
		battle(winner)
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "player_attack":
		$HurtAnimation.play("opp_hurt")
		$hit.play()
		opp_hp -= player_dp
#		$AnimationPlayer.play_backwards("player_attack")
	if anim_name == "opp_attack":
		$HurtAnimation.play("player_hurt")
		$hit.play()
		player_hp -= opp_dp
#		$AnimationPlayer.play_backwards("opp_attack")

	if anim_name == "draw":
		pass
	new_round()

func new_round():
	player_played = false
	opp_played = false
	hide_card()
	com_play()
	current_round += 1
	$TimerUI/Timer.start()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		pass
	if what == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		if opp_hp>0 and player_hp>0:
			$EndScreen.visible =!$EndScreen.visible
			get_tree().paused = $EndScreen.visible

func show_card():
	if opp_choice == "rock":
		$Opponent/Sprite.texture = rock
	if opp_choice == "paper":
		$Opponent/Sprite.texture = paper
	if opp_choice == "scissors":
		$Opponent/Sprite.texture = scissors
	if player_choice == "non":
		$Player/Sprite.texture = non
	if opp_choice == "non":
		$Opponent/Sprite.texture = non

func hide_card():
	player_choice = "non"
	opp_choice = "non"
	$Player/Sprite.texture = question
	$Opponent/Sprite.texture = question

func game_over():
	if opp_hp<=0:
		$EndScreen.show()
		$EndScreen/Label.text = "WOW, YOU BEAT ME? NOT BAD\nFOR A HUMAN!"
		get_tree().paused = true
	if player_hp<=0:
		$EndScreen.show()
		$EndScreen/Label.text = "MAN, YOU SUCK AT THIS GAME"
		get_tree().paused = true
	if opp_hp>0 and player_hp>0:
		$EndScreen/Label.text = ""
	$EndScreen/Label2.text = "ROUNDs PLAYED: "+str(current_round)


func _on_again_pressed():
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().change_scene("res://scenes/title.tscn")
