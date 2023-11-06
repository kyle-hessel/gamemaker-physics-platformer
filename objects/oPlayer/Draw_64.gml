/// @description Insert description here

//debug

/*
//accel/decel check
if ((abs(hSpeed) < walkSpeed) && (moveLeft != NOT_MOVING && moveRight != NOT_MOVING)) {
	draw_set_color(c_green);	
} else {
	draw_set_color(c_white);	
}

if ((abs(hSpeed) < walkSpeed) && (moveLeft != NOT_MOVING || moveRight != NOT_MOVING)) {
	draw_set_color(c_green);	
} else {
	draw_set_color(c_white);	
}
*/

/*
//state init check
if (stateInit == true) {
	draw_set_color(c_yellow);
}
*/
draw_set_color(c_white);

//player health
draw_text(50, 25, "Health:");
draw_text(115, 25, string(playerHealth));

//track player speed
draw_text(50, 50, "hSpeed:");
draw_text(115, 50, string(hSpeed));

draw_text(50, 75, "vSpeed:");
draw_text(115, 75, string(vSpeed));

//visually track input type
draw_text(50, 100, "input:");
draw_text(115, 100, string(inputType));

//visually track player state
draw_text(50, 125, "state:");
draw_text(115, 125, string(playerState));

//track inventory
if (oGun.inInventory == true || oGunDoubleBounce.inInventory == true) {
	draw_text(50, 150, "weapon:");
	draw_text(115, 150, string(activeSlot));
}