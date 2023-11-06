/// @description change sprite depending on player state

if (oPlayer.playerState == playerStates.PLATFORMER) {
	sprite_index = sButtonOff;	
} else if (oPlayer.playerState == playerStates.ZEROG) {
	sprite_index = sButtonOn;	
}
