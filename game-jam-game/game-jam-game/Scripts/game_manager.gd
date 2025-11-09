extends Node

# Global coin counter
var coins: int = 0

func add_coin():
	coins += 1
	print("Coins collected: ", coins)

func reset_coins():
	coins = 0
