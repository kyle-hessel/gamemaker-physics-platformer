/// @description init enemy variables

hSpeed = WALK_SPEED;
vSpeed = WALK_SPEED;

enemyHealth = ENEMY_HITPOINTS;

flinchTimer = NOT_MOVING;

enum enemyHealthStates {
	
	HEALTHY,
	DAMAGED,
	DEAD

}

enemyHealthState = enemyHealthStates.HEALTHY;