/// @description update the enemy object

//temporary?
//image_xscale = SCALE_FACTOR;
//image_yscale = SCALE_FACTOR;

//rotate this object
image_angle += ROTATION_RATE;

//movement
if (place_meeting(x + hSpeed, y, oWall) || place_meeting(x + hSpeed, y, oPlayer) || place_meeting(x + hSpeed, y, oBullet)) {
	//while (!place_meeting(x + sign(hSpeed), y, oWall)) x += sign(hSpeed);
	hSpeed = -hSpeed;
}
if (place_meeting(x, y + vSpeed, oWall) || place_meeting(x, y + vSpeed, oPlayer) || place_meeting(x, y + vSpeed, oBullet)) {
	//while (!place_meeting(x, y + sign(vSpeed), oWall)) y += sign(vSpeed);
	vSpeed = -vSpeed;
}

//change speed depending on gravity or lack thereof
if (oPlayer.playerState == playerStates.PLATFORMER) {
	x += hSpeed;
	y += vSpeed;
} else if (oPlayer.playerState == playerStates.ZEROG) {
	x += hSpeed * ZEROG_SLOW;
	y += vSpeed * ZEROG_SLOW;
}