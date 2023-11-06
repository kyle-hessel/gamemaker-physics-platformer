/// @description manage gun firing, angle, ammo, etc

//only use the gun if alive and it's in our inventory
if (oPlayer.healthState != healthStates.DEAD) {

	if (inInventory == true && oPlayer.activeSlot == oPlayer.playerInventory[0]) {
		
		if (visible == false) visible = true;
	
		#region keyboard
		if (oPlayer.inputType == KEYBOARD) {
	
			//check for mouse left button
			var mouseLeft = mouse_check_button(mb_left);
	
			//calculate the angle of the displacement vector from the gun to the mouse
			image_angle = point_direction(x, y, mouse_x, mouse_y);
	
			//add one count to the firing delay every frame to make the counter move
			firingDelay--;
			firingRecoil = max(0, firingRecoil - 1); // do the same with recoil but clamp above 0. also cant use -- here for some reason, not really worth making a macro for this
	
			if (mouseLeft && firingDelay < NOT_MOVING) {
		
				//set firing delay back up to whatever the counter macro is so that we can only fire once every (FIRING_COUNTER) frames
				firingDelay = FIRING_COUNTER;
				firingRecoil = GUN_KICKBACK; //set recoil timer as well
		
				//make an oBullet instance and act on that exact instance w/ 'with', and then place it on the projectiles layer at oGun's position
				with (instance_create_layer(x, y, "projectiles", oBullet)) {
			
					//the speed keyword is good for objects where you know the speed shouldn't change, and this is our disp. vector length
					speed = BULLET_SPEED;
					//set the bullet's displacement vector angle/direction to be that of our gun, and then randomize it slightly
					direction = other.image_angle + random_range(-BULLET_RANGE, BULLET_RANGE);
					image_angle = direction; //set our image angle to be our direction
			
				}
			}
	
			//use a displacement vector to calculate gun kickback X, and subtract it to flip the whole disp. vector 180 degrees
			x -= lengthdir_x(firingRecoil, image_angle)
			//use a displacement vector to calculate gun kickback Y, and subtract it to flip the whole disp. vector 180 degrees
			y -= lengthdir_y(firingRecoil, image_angle)
	
			//if facing to the left, flip the Y so its not upside-down. otherwise, set back to facing right.
			if (image_angle > UP_ANGLE && image_angle < DOWN_ANGLE) image_yscale = -SCALE_FACTOR else image_yscale = SCALE_FACTOR;
	
		} 
		#endregion

		#region gamepad
		else if (oPlayer.inputType == GAMEPAD) {
	
			var hCheck = gamepad_axis_value(SLOT_ONE, gp_axisrh);
			var vCheck = gamepad_axis_value(SLOT_ONE, gp_axisrv);
			var rightTrigger = gamepad_button_check(SLOT_ONE, gp_shoulderrb);
	
			//if we are outside the deadzone, determine our controllerAngle
			if (abs(hCheck) > DEADZONE || abs(vCheck) > DEADZONE) {
				//figure out the angle by finding a displacement vector in any direction of the analog stick that starts at the analog's origin (0,0)
				controllerAngle = point_direction(ANALOG_ORIGIN, ANALOG_ORIGIN, hCheck, vCheck);
			}
	
			//set our image angle to whatever we determined our controllerAngle to be
			image_angle = controllerAngle;
	
			//add one count to the firing delay every frame to make the counter move
			firingDelay--;
			firingRecoil = max(0, firingRecoil - 1); // do the same with recoil but clamp above 0. also cant use -- here for some reason, not really worth making a macro for this
	
			if (rightTrigger && firingDelay < NOT_MOVING) {
		
				//set firing delay back up to whatever the counter macro is so that we can only fire once every (FIRING_COUNTER) frames
				firingDelay = FIRING_COUNTER;
				firingRecoil = GUN_KICKBACK; //set recoil timer as well
		
				//make an oBullet instance and act on that exact instance w/ 'with', and then place it on the projectiles layer at oGun's position
				with (instance_create_layer(x, y, "projectiles", oBullet)) {
			
					//the speed keyword is good for objects where you know the speed shouldn't change, and this is our disp. vector length
					speed = BULLET_SPEED;
					//set the bullet's displacement vector angle/direction to be that of our gun, and then randomize it slightly
					direction = other.image_angle + random_range(-BULLET_RANGE, BULLET_RANGE);
					image_angle = direction; //set our image angle to be our direction
			
				}
		
				//make an oBullet instance and act on that exact instance w/ 'with', and then place it on the projectiles layer at oGun's position
				with (instance_create_layer(x, y, "projectiles", oBullet)) {
			
					//the speed keyword is good for objects where you know the speed shouldn't change, and this is our disp. vector length
					speed = BULLET_SPEED;
					//set the bullet's displacement vector angle/direction to be that of our gun, and then randomize it slightly
					direction = other.image_angle + random_range(-BULLET_RANGE * 5, BULLET_RANGE * 5);
					image_angle = direction; //set our image angle to be our direction
			
				}
		
			}
	
			//use a displacement vector to calculate gun kickback X, and subtract it to flip the whole disp. vector 180 degrees
			x -= lengthdir_x(firingRecoil, image_angle)
			//use a displacement vector to calculate gun kickback Y, and subtract it to flip the whole disp. vector 180 degrees
			y -= lengthdir_y(firingRecoil, image_angle)
	
			//if facing to the left, flip the Y so its not upside-down. otherwise, set back to facing right.
			if (image_angle > UP_ANGLE && image_angle < DOWN_ANGLE) image_yscale = -SCALE_FACTOR else image_yscale = SCALE_FACTOR;
	
	
		}
		#endregion
	
	} else if (inInventory == true && oPlayer.activeSlot != oPlayer.playerInventory[0]) {
		if (visible == true) visible = false;
	}

}
