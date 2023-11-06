/// @description alerts to the player

//tell the player if they died (temporary)
if (oPlayer.healthState == healthStates.DEAD) {
		
	draw_set_color(c_white);
	draw_text(viewWidthHalf - 31, viewHeightHalf - 31, "YOU DIED");
		
	draw_set_color(c_red);
	draw_text(viewWidthHalf - 30, viewHeightHalf - 30, "YOU DIED");
	
	draw_set_color(c_white);
	draw_text(viewWidthHalf + 91, viewHeightHalf + 91, "Press R");
	draw_set_color(c_yellow);
	draw_text(viewWidthHalf + 90, viewHeightHalf + 90, "Press R");
	
}