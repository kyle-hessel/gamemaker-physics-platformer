/// @description switch input types

if (oPlayer.inputType == KEYBOARD) {
	oPlayer.inputType = GAMEPAD;	
} else if (oPlayer.inputType == GAMEPAD) {
	oPlayer.inputType = KEYBOARD;
}
