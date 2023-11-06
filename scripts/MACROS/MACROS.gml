/// @desc MACROS
function MACROS() {

	//NOTE: don't use semicolon at the end of macro declarations or you will get malformed assignment errors, as GML doesn't expect a semicolon or equals sign.

#region gamemode types

	//sp, co-op macros
#macro SINGLEPLAYER 0
#macro CO_OP 1

#endregion

#region input types

	//input type consts
#macro KEYBOARD 0
#macro GAMEPAD 1
#macro TOUCH 2
#macro KB_AND_PAD 3 //co-op only
#endregion

#region controller consts

	//controller deadzone control const
#macro DEADZONE 0.2
	//controller slot one const
#macro SLOT_ONE 0

	//limits analogue stick inputs to positive or negative for specific variables that are used by the movement system
#macro STICK_LIMITER 0

	//for aiming
#macro ANALOG_ORIGIN 0

#endregion

#region physics defaults

	//defaults for physics
#macro NOT_MOVING 0
#macro GRAVITY_WEIGHT 0.2
#macro ZEROG_COLLISION 0.3 //0G collision slowdown
#macro ZEROG_SLOW 0.5
#macro WALK_SPEED 4 
#macro ACCEL_AMOUNT 0.1
#macro DECEL_AMOUNT 0.2
#macro FLOOR_CONTACT 1 
#macro JUMP_SPEED 8 //platformer only

	//temporary
#macro SCALE_FACTOR 2

#endregion

#region camera defaults

#macro VIEW_HALF 0.5
#macro PAN_INCREMENT 10

#endregion

#region gun defaults

#macro GUN_XOFFSET 8
#macro GUN_YOFFSET 3
#macro FIRING_COUNTER 10
#macro BULLET_SPEED 20
#macro GUN_KICKBACK 3
#macro BULLET_RANGE 1

#endregion

#region macros for angles

#macro RIGHT_ANGLE 0
#macro LEFT_ANGLE 180
#macro UP_ANGLE 90
#macro DOWN_ANGLE 270

#endregion

#region player defaults

#macro PLAYER_HITPOINTS 5
#macro WALL_OOF 30 //how long the timer lasts when hitting walls in 0G
#macro ATTACK_OOF 40

#endregion

#region enemy defaults
#macro ROTATION_RATE 1
#macro ENEMY_HITPOINTS 9
#macro ENEMY_ATTACK_OOF 10
#endregion


}
