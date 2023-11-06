/// @description update camera

//update our future destination (what we follow)
if (instance_exists(objectFollow)) {
	
	xTo = objectFollow.x;
	yTo = objectFollow.y;

}

//update camera's position based on our following object's coordinates divided by our PAN_INCREMENT value for smooth movement
x += (xTo - x) / PAN_INCREMENT;
y += (yTo - y) / PAN_INCREMENT;

/* clamp camera to room-- probably not needed for this game for now?

x = clamp(x, viewWidthHalf, room_width - viewWidthHalf);
y = clamp(y, viewHeightHalf, room_height - viewHeightHalf);

*/

//update view and center it on the player
camera_set_view_pos(defaultCam, x - viewWidthHalf, y - viewHeightHalf);