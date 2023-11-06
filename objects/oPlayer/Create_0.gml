/// @description setup player vars, states

//temporary?
image_xscale = SCALE_FACTOR;
image_yscale = SCALE_FACTOR;

#region set default input type
//input type (0 kb+m, 1 gamepad, 2 touch, 3 kb+m&&gamepad combo), keyboard is default for now, change this later in oInit within rInit (i'd assume)
inputType = KEYBOARD;
#endregion

#region state machine setup

//establish state machine

enum playerStates {
	
	PLATFORMER,
	ZEROG,
	DEAD,
	CUTSCENE,
	TELEPORT,
	MENU
	
	
}

enum healthStates {

	HEALTHY,
	DAMAGED,
	DEAD
	
}

//default to platformer
playerState = playerStates.PLATFORMER;
healthState = healthStates.HEALTHY;

//for special events on state-switch, just for executing different chunks of code if just entering a state or not
stateInit = false;
#endregion

#region variables related to state-switching
yOriginal = y; //for switching from platformer to 0G
//xOriginal = x; //not sure if i want this

#endregion

#region declare general physics variables

//variables for both platformer and 0G
hSpeed = NOT_MOVING;
vSpeed = NOT_MOVING;
playerAccel = ACCEL_AMOUNT;
playerDecel = DECEL_AMOUNT;
#endregion

#region declare platforming physics variables

//traditional platformer variables
playerGravity = GRAVITY_WEIGHT;
walkSpeed = WALK_SPEED;
jumpVelocity = JUMP_SPEED;
#endregion

#region declare 0-gravity (8-directional) physics variables

//zero-gravity variables
//check macros

#endregion

#region declare variables for player vitality

playerHealth = PLAYER_HITPOINTS;

#endregion

#region extra variables
bumpTimer = NOT_MOVING; //amount of frames bump sprite shows when hitting walls in 0G
flinchTimer = NOT_MOVING; //for flinching from attacks

#endregion