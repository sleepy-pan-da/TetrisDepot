# Handles frontend stuff
extends HBoxContainer

export(Array, PackedScene) var blockLogos
onready var qtyLabel : Label = $QtyLabel
var blockLogosMap = {
	"IBlock": 0, 
	"JBlock": 1,
	"LBlock": 2,
	"OBlock": 3,
	"SBlock": 4,
	"TBlock": 5,
	"ZBlock": 6
}


# bool reflects whether icon is successfully setup
func setUp(blockLogoName : String, newQty : int) -> bool:
	var updatedLogo : bool = updateLogo(blockLogoName)
	var updatedQty : bool = updateQtyLabel(newQty)
	return updatedLogo and updatedQty


# bool reflects whether logo is successfully updated
func updateLogo(blockLogoName : String) -> bool:
	if not (blockLogoName in blockLogosMap):
		print("{str} not in blockLogosMap".format({"str": blockLogoName}))
		return false
	var i : int = blockLogosMap[blockLogoName]
	var logo : Node = blockLogos[i].instance()
	add_child(logo)
	return true


# bool reflects whether qty is successfully updated
func updateQtyLabel(newQty : int) -> bool:
	if newQty < 0:
		print("New qty of {newQty} is < 0".format({"newQty": newQty}))
		return false
	qtyLabel.text = "X" + str(newQty)
	return true
