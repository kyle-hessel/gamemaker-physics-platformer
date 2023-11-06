/// @description update the enemy object

//temporary?
//image_xscale = SCALE_FACTOR;
//image_yscale = SCALE_FACTOR;

//rotate this object
image_angle += ROTATION_RATE;

//movement
if (place_meeting(x + hSpeed, y, oWall)) {
	//while (!place_meeting(x + sign(hSpeed), y, oWall)) x += sign(hSpeed);
	hSpeed = -hSpeed;
}
if (place_meeting(x, y + vSpeed, oWall)) {
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

//nearly identical to the player's, but looks for bullets instead
#region Health States
	
switch (enemyHealthState) {
		
	case enemyHealthStates.HEALTHY:
		
		if (place_meeting(x, y, oBullet) && flinchTimer == NOT_MOVING) {
				
			if (enemyHealth > NOT_MOVING) {
				enemyHealthState = enemyHealthStates.DAMAGED;
				flinchTimer = ENEMY_ATTACK_OOF;
			} else if (enemyHealth <= NOT_MOVING) {
				enemyHealthState = enemyHealthStates.DEAD;	
			}
			
		}
		
	break;
		
	case enemyHealthStates.DAMAGED:
		
		if (flinchTimer > NOT_MOVING) {
			flinchTimer--; 
		} else if (flinchTimer == NOT_MOVING) {
			enemyHealthState = enemyHealthStates.HEALTHY;	
		}
		
	break;
		
	case enemyHealthStates.DEAD:
	
	//just destroy the enemy for now
	instance_destroy();

	break;
	
}
	
#endregion