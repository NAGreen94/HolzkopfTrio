extends CanvasLayer

@onready var coin_label = $Label

func _process(_delta):
	coin_label.text = "Coins: " + str(GameManager.coins)
