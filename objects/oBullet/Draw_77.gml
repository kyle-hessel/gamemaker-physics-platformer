/// @description destroy bullet on wall or enemy impact, after drawing it on that frame

if (place_meeting(x, y, oWall)) instance_destroy();

//if we hit the enemy, lower their health and destroy this bullet
if (place_meeting(x, y, oEnemy)) {
	
	oEnemy.enemyHealth--;
	instance_destroy();
	
}

//add optimization for destroying if going outside the room? camera view?