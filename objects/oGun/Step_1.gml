/// @description track gun to player

//only run if we have it in our inventory
if (inInventory == true) {

	//flip the X offset depending on player direction, assign x value with this offset
	if (oPlayer.image_xscale == -SCALE_FACTOR) {
		x = oPlayer.x - GUN_XOFFSET;	
	} else if (oPlayer.image_xscale == SCALE_FACTOR) {
		x= oPlayer.x + GUN_XOFFSET;	
	}

	//assign y value, offset doesn't have to change
	y = oPlayer.y + GUN_YOFFSET;

} else if (inInventory == false) {
	//rotate this object if not picked up
	image_angle += ROTATION_RATE * 2;
}