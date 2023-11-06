/// @description manage player state and non-state code

//NOTE: might rewrite some of this later to use functions when 2.3 hits
//I would put some of this into a script now but things are going to vary a lot depending on the input type/state, but I could make some tiny scripts.

#region singleplayer code

//SINGLEPLAYER (lock to one control type only, let the player switch in the menu)
if (global.gameMode == SINGLEPLAYER) {
	


	#region manage input types, vary depending on player state

	#region death inputs
	//only allow for death menu inputs if dead
	
	//determine input type
	
	if (playerState == playerStates.DEAD) {
		
		if (inputType == KEYBOARD) {
			
		}
		else if (inputType == GAMEPAD) {
			
		}
		else if (inputType == TOUCH) {
			
		}
		
	}
	#endregion
	
	#region cutscene inputs
	//only allow for text click-through if in a cutscene, or skipping
	else if (playerState == playerStates.CUTSCENE) {
		
		if (inputType == KEYBOARD) {
			
		}
		else if (inputType == GAMEPAD) {
			
		}
		else if (inputType == TOUCH) {
			
		}
		
	}
	#endregion
	
	#region menu inputs
	//if in the menu, only allow for menu inputs
	else if (playerState == playerStates.MENU) {
		
		if (inputType == KEYBOARD) {
			
		}
		else if (inputType == GAMEPAD) {
			
		}
		else if (inputType == TOUCH) {
			
		}
		
	}
	#endregion

	#region movement inputs
	//if not dead, in the menu, or in a cutscene, check inputs (even when teleporting, for now)
	else {

		//determine input type

		#region kb+m
		//keyboard + mouse
		if (inputType == KEYBOARD) {
	
			//for now set common keys, hopefully later let players bind them!
		
			//for platforming and 0G
			moveLeft = keyboard_check(vk_left) || keyboard_check(ord("A"));
			moveRight = keyboard_check(vk_right) || keyboard_check(ord("D"));
		
			//platformer-specific
			//keyboard_check_pressed is used so that the player cannot infinitely jump
			if (playerState = playerStates.PLATFORMER) jump = keyboard_check_pressed(vk_space);
	
			//0G-specific
			if (playerState = playerStates.ZEROG) {
				moveDown = keyboard_check(vk_up) || keyboard_check(ord("W"));
				moveUp = keyboard_check(vk_down) || keyboard_check(ord("S"));
				//for pressing gravity buttons
				bSwitch = keyboard_check_pressed(vk_space);
			}
	
		}
		#endregion
	
		#region controller
		//gamepad
		else if (inputType == GAMEPAD) {
		
			//start by checking if we are moving the gamepad left analogue stick at all
			hCheck = gamepad_axis_value(SLOT_ONE, gp_axislh);
			vCheck = gamepad_axis_value(SLOT_ONE, gp_axislv);
		
			//platformer-specific
			if (playerState = playerStates.PLATFORMER) jump = gamepad_button_check_pressed(SLOT_ONE, gp_face1); //A (or X) button
		
			
			//only move player if pushing outside of deadzone (0.2)
		
			//platforming and 0G
			if (abs(hCheck) > DEADZONE) {
				//clamps left movement between -integer to 0, and then makes it absolute
				moveLeft = abs(min(hCheck, STICK_LIMITER));
				//clamps right movement between 0 and +integer
				moveRight = max(hCheck, STICK_LIMITER);
			
			} 
			//if in the deadzone, don't move horizontally at all (without this the player slides because the values never get defaulted back to zero)
			else {
				moveRight = NOT_MOVING;
				moveLeft = NOT_MOVING;
			}
		
			//0G specific
			if (playerState = playerStates.ZEROG) {
				if (abs(vCheck) > DEADZONE) {
					//clamps downward movement between -integer to 0, and then makes it absolute
					moveDown = abs(min(vCheck, STICK_LIMITER));
					//clamps upward movement between 0 and +integer
					moveUp = max(vCheck, STICK_LIMITER);
					
				} 
				//if in the deadzone, don't move vertically at all (without this the player slides because the values never get defaulted back to zero)
				else {
					moveUp = NOT_MOVING;
					moveDown = NOT_MOVING;
				}
				
				//for pressing gravity buttons
				bSwitch = gamepad_button_check_pressed(SLOT_ONE, gp_face1);
			}
	
	
		}
		#endregion
		
		#region touch-controls
		//touch
		else if (inputType == TOUCH) {
			
		}
		
		#endregion
	
	}
	#endregion
	
	#region inventory inputs
	
	if (inputType == KEYBOARD) {
	
		cycleLeft = keyboard_check_pressed(ord("Q"));
		cycleRight = keyboard_check_pressed(ord("E"));
	
	} else if (inputType == GAMEPAD) {
		
	}
	
	#endregion

	#endregion
	
	#region Inventory management
	
	if (inputType == KEYBOARD) {
		//picking up default gun
		if (oGun.inInventory == false && place_meeting(x, y, oGun) && keyboard_check_pressed(vk_space)) {
	
			oGun.inInventory = true;
			playerInventory[0] = oGun;
			activeSlot = playerInventory[0];
	
		}
		//picking up double shot gun
		if (oGunDoubleBounce.inInventory == false && place_meeting(x, y, oGunDoubleBounce) && keyboard_check_pressed(vk_space)) {
	
			oGunDoubleBounce.inInventory = true;
			playerInventory[1] = oGunDoubleBounce;
			activeSlot = playerInventory[1];
	
		}
	
		//weapon switching
		if (oGun.inInventory == true && oGunDoubleBounce.inInventory == true) {
			if (cycleLeft) {
			
				if (activeSlot == playerInventory[1]) {	
					activeSlot = playerInventory[0];
				}
			
			} else if (cycleRight) {
			
				if (activeSlot == playerInventory[0]) {	
					activeSlot = playerInventory[1];
				}
			
			}
		}
	
	
	
	}
	
	#endregion
	
	#region Player States

	//state management and applying inputs
	switch (playerState) {
	
			//ON zero gravity disable (default)
			
			#region platformer state
			
			case playerStates.PLATFORMER:
			
				#region state-switching
				
				//state-switch to zeroG
				if (jump && place_meeting(x, y, oButton) && healthState != healthStates.DEAD) { //only do this if alive
					
					//grab y position before state-switch to use as an arbitrary upwards limiter (or the player will go on forever when gravity is turned off)
					yOriginal = y;
					
					//kill any existing hSpeed to stop problems with quick state-switching
					hSpeed = NOT_MOVING;
					//set state to be zeroG and declare state as being initialized (important especially for zeroG)
					playerState = playerStates.ZEROG;
					stateInit = true;
					
					//update sprite
					sprite_index = sPlayer;
					
					//break out of the switch statement early
					break;
				}
				#endregion
				
				//calculate movement left or right (positive or negative on the X axis) if the player is alive
				if (healthState != healthStates.DEAD) {
					var movePlayerH = moveRight - moveLeft;
				} else { //if dead, don't add movement
					var movePlayerH = NOT_MOVING;
				}
				
				//temporary
				if (movePlayerH != NOT_MOVING) image_xscale = sign(movePlayerH) * SCALE_FACTOR;
				
				
				#region state initialization
				
				//initialize platformer state (doesn't run until after first state-switch back)
				if (stateInit == true) {
					
					hSpeed = NOT_MOVING;
					//nothing yet
					stateInit = false;
				}
				#endregion
				
				#region gravity, v-collide
				
				//apply gravity and vertical collision-checking regardless of input-type, as it will always happen, and run it beforehand to avoid conflict
				vSpeed += playerGravity
				
				if (place_meeting(x, y + vSpeed, oWall)) {
					
					//precision collisions
					if (place_meeting(x, y + vSpeed, oWall)) while (!place_meeting(x, y + sign(vSpeed), oWall)) y += sign(vSpeed);	
					
					vSpeed = NOT_MOVING;
					
				}
				
				//jump is already assigned to the right input type earlier in the frame, so specific checking isn't required, it's only required below for optimization
				
				//if we are contacting the floor, allow for jumping by adding a negative amount to our vertical speed. only do this if alive.
				if (place_meeting(x, y + FLOOR_CONTACT, oWall) && jump && healthState != healthStates.DEAD) vSpeed = -jumpVelocity; 
				
				//apply vSpeed (gravity)
				y+= vSpeed;
				
				#endregion
				
				#region kb+m horizontal movement and collisions
				if (inputType == KEYBOARD) {
					
					//if we stop pressing movement keys but still have horizontal velocity, decelerate
					if (movePlayerH == NOT_MOVING && hSpeed != NOT_MOVING) {
						
						//if we are moving, begin deceleration
						if (abs(hSpeed) > NOT_MOVING) {
							
							//deceleration calculation (use sign of hSpeed since movePlayerH is 0).
							hSpeed -= (playerDecel * sign(hSpeed));
							
							//check if there's a collision before moving (only for deceleration)
							if (place_meeting(x + hSpeed, y, oWall)) {
							
								//precise collisions
								while (!place_meeting(x + sign(hSpeed), y, oWall)) x += sign(hSpeed);
								//set to 0 if colliding
								hSpeed = NOT_MOVING;	
							}
							
							//apply horizontal deceleration
							x += (hSpeed);
							
						//if our horizontal velocity drops below 0, clamp at 0.
						} else if (hSpeed <= NOT_MOVING) {
							hSpeed = NOT_MOVING;
						}
					} 
					//if we press a movement key, start movement
					else if (movePlayerH != NOT_MOVING) {
						
						//if our horizontal speed is less than our set walk speed, accelerate
						if (abs(hSpeed) < walkSpeed) {
						
							//increase player acceleration by the acceleration increment in either direction each frame
							hSpeed += (playerAccel * movePlayerH);
						
						}
						//if our horizontal movement is equal to hSpeed, normal movement and collisions
						else if ((abs(hSpeed) >= walkSpeed))  {
						
							//run a check that only lets the player keep constant velocity if they are not switching directions
							if (sign(hSpeed) == movePlayerH) {
								//multiply by default walk speed
								hSpeed = walkSpeed * movePlayerH;
								
							//if switching directions, decelerate
							} else hSpeed -= (playerDecel * sign(hSpeed));
							
						}
							
						//check if there's a collision before moving
						if (place_meeting(x + hSpeed, y, oWall)) {
							
							//precise collisions
							while (!place_meeting(x + sign(hSpeed), y, oWall)) x += sign(hSpeed);
							
							//set to 0 if colliding
							hSpeed = NOT_MOVING;	
						}
						
						//apply hSpeed (horizontal movement)
						x += (hSpeed);
							
					}
					
				}
				#endregion
				
				#region gamepad horizontal movement and collisions
				//only attempt to move the player and apply collisions if left analogue stick input is above the deadzone (0.2)
				else if (inputType == GAMEPAD) {
					
					//if we stop pressing movement keys but still have horizontal velocity, decelerate
					if (abs(movePlayerH) < DEADZONE) {
						
						//if we are moving, begin deceleration
						if (abs(hSpeed) > NOT_MOVING) {
							
							//deceleration calculation (use sign of hSpeed since movePlayerH is 0).
							hSpeed -= (playerDecel * sign(hSpeed));
							
							if (abs(hSpeed) < playerDecel && abs(movePlayerH) < DEADZONE) hSpeed = NOT_MOVING;
							
							//check if there's a collision before moving (only for deceleration)
							if (place_meeting(x + hSpeed, y, oWall)) {
							
								//precise collisions
								while (!place_meeting(x + sign(hSpeed), y, oWall)) x += sign(hSpeed);
							
								//set to 0 if colliding
								hSpeed = NOT_MOVING;
							}
							
							//apply horizontal deceleration
							x += (hSpeed);
							
						//if our horizontal velocity drops below 0, clamp at 0.
						} else if (hSpeed <= NOT_MOVING) {
							hSpeed = NOT_MOVING;
						}
					} 
					//if we press a movement key, start movement
					else if (movePlayerH != NOT_MOVING) {
						
						//if our horizontal speed is less than our set walk speed, accelerate
						if (abs(hSpeed) < walkSpeed) {
						
							//increase player acceleration by the acceleration increment in either direction each frame
							hSpeed += (playerAccel * movePlayerH);
						
						}
						//if our horizontal movement is equal to hSpeed, normal movement and collisions
						else if ((abs(hSpeed) >= walkSpeed))  {
						
							//run a check that only lets the player keep constant velocity if they are not switchign directions
							if (sign(hSpeed) == movePlayerH) {
								//multiply by default walk speed
								hSpeed = walkSpeed * movePlayerH;
								
							//if switching directions, decelerate
							} else hSpeed -= (playerDecel * sign(hSpeed));
							
						}
							
						//check if there's a collision before moving
						if (place_meeting(x + hSpeed, y, oWall)) {
							
							//precise collisions
							while (!place_meeting(x + sign(hSpeed), y, oWall)) x += sign(hSpeed);
							
							//set to 0 if colliding
							hSpeed = NOT_MOVING;	
						}
						
						//apply hSpeed (horizontal movement)
						x += (hSpeed);
							
					}

				}
				#endregion
				
				#region touch horizontal movement and collisions
				else if (inputType == TOUCH) {
					//nothing yet
				}
				#endregion
				
				#region sprite animation updating
				
				if (abs(movePlayerH) > NOT_MOVING && place_meeting(x, y + FLOOR_CONTACT, oWall)) {
					sprite_index = sPlayerRun;
				} else if (movePlayerH == NOT_MOVING && place_meeting(x, y + FLOOR_CONTACT, oWall)) {
					sprite_index = sPlayerStill;	
				}
				if (vSpeed > NOT_MOVING && !place_meeting(x, y + FLOOR_CONTACT, oWall)) {
					sprite_index = sPlayerFall;	
				} else if (vSpeed < NOT_MOVING && !place_meeting(x, y + FLOOR_CONTACT, oWall)) {
					sprite_index = sPlayerJump;	
				}
				
				#endregion
				
				break;
				
			#endregion
			
			#region zeroG state
			
			//ON zero gravity enable
			case playerStates.ZEROG:
			
				#region state-switching
				
				//state-switch to platformer
				if (bSwitch && place_meeting(x, y, oButton) && healthState != healthStates.DEAD) { //only do this if alive

					//remove any remaining vertical velocity so that it's not applied in platformer state on next frame
					vSpeed = NOT_MOVING;
					//same with hSpeed (later i would like to keep some of this velocity and reuse it on platformer state init)
					hSpeed = NOT_MOVING;
					
					//set state back to platformer and declare that state is being initialized
					playerState = playerStates.PLATFORMER;
					stateInit = true;
					
					//update sprite
					sprite_index = sPlayerStill;
					
					break;
				}
				#endregion
			
				/* these checks must be ran before any collision or movement code*/
				//determine if player is moving left or right if alive
				if (healthState != healthStates.DEAD) {
					var movePlayerH = moveRight - moveLeft;
				} else { //if dead don't add movement horizontally
					var movePlayerH = NOT_MOVING;
				}
				
				//determine if player is moving up or down if alive
				if (healthState != healthStates.DEAD) {
					var movePlayerV = moveUp - moveDown;
				} else { //if dead don't add movement vertically
					var movePlayerV = NOT_MOVING;	
				}
				
				//temporary?
				if (movePlayerH != NOT_MOVING) image_xscale = sign(movePlayerH) * SCALE_FACTOR;		
				
				#region state init
				//initialize state by adding some upwards velocity to indicate to the player that gravity is turned off, only do this if touching the floor (regardless of input type)
				if ((stateInit == true) && (place_meeting(x, y + FLOOR_CONTACT, oWall))) {
					vSpeed = -walkSpeed * ZEROG_COLLISION;//we are technically just making it so we bounce off the floor here, in a way
					stateInit = false;
				//if not touching floor just set to false
				} else if ((stateInit == true) && (!place_meeting(x, y + FLOOR_CONTACT, oWall))) stateInit = false;
				#endregion
				
				
				#region kb+m movement and collisions
				
				//only run if using keyboard
				if (inputType == KEYBOARD) {
					
					//vertical movement
					
					//if our vertical speed is less than our set walk speed, accelerate
					if (abs(vSpeed) < walkSpeed) {
						
						//increase player acceleration by the acceleration increment in either direction each frame
						vSpeed += (playerAccel * movePlayerV) ;
						
					}
					//if our horizontal movement is equal to vSpeed, normal movement and collisions
					else if (abs(vSpeed) >= walkSpeed)  {
						
						//run a check that only lets the player keep constant velocity if they are not switching directions
						if (sign(vSpeed) == movePlayerV) {
							
							//multiply by default walk speed
							vSpeed = (walkSpeed * movePlayerV);
								
						//if switching directions, decelerate (this else if ensures we don't lose vSpeed when not switching directions, but just letting go of the movement key)
						} else if (sign(vSpeed) != movePlayerV && movePlayerV != NOT_MOVING) vSpeed -= (playerDecel * sign(vSpeed));
					
					}
					
					//check if there's a collision before moving
					if (place_meeting(x, y + vSpeed, oWall)) {
							
						//precise collisions
						while (!place_meeting(x, y + sign(vSpeed), oWall)) y += sign(vSpeed);
							
						//reverse our vSpeed and slow it down if colliding to bounce off of objects
						vSpeed = -vSpeed * ZEROG_COLLISION;	
					}
					
					//apply vSpeed (vertical movement)
					y += (vSpeed);
					
					
					//horizontal movement
					
					//if our horizontal speed is less than our set walk speed, accelerate
					if (abs(hSpeed) < walkSpeed) {
						
						//increase player acceleration by the acceleration increment in either direction each frame
						hSpeed += (playerAccel * movePlayerH);
						
					}
					//if our horizontal movement is equal to hSpeed, normal movement and collisions
					else if ((abs(hSpeed) >= walkSpeed))  {
						
						//run a check that only lets the player keep constant velocity if they are not switching directions
						if (sign(hSpeed) == movePlayerH) {
							
							//multiply by default walk speed
							hSpeed = (walkSpeed * movePlayerH);
								
						//if switching directions, decelerate (this else if ensures we don't lose vSpeed when not switching directions, but just letting go of the movement key)
						} else if (sign(hSpeed) != movePlayerH && movePlayerH != NOT_MOVING) hSpeed -= (playerDecel * sign(hSpeed));
						
					}
							
					//check if there's a collision before moving
					if (place_meeting(x + hSpeed, y, oWall)) {
							
						//precise collisions
						while (!place_meeting(x + sign(hSpeed), y, oWall)) x += sign(hSpeed);
							
						//reverse our hSpeed and slow it down if colliding to bounce off of objects
						hSpeed = -hSpeed * ZEROG_COLLISION;
					}
						
					//apply hSpeed (horizontal movement)
					x += (hSpeed);
					
					
				}
				
				
				#endregion
				
				#region gamepad movement and collisions
				
				else if (inputType == GAMEPAD) {
					
					//vertical movement
					
					//if our vertical speed is less than our set walk speed, accelerate
					if (abs(vSpeed) < walkSpeed) {
						
						//increase player acceleration by the acceleration increment in either direction each frame
						vSpeed += (playerAccel * movePlayerV);
						
					}
					//if our horizontal movement is equal to vSpeed, normal movement and collisions
					else if (abs(vSpeed) >= walkSpeed)  {
						
						//run a check that only lets the player keep constant velocity if they are not switching directions
						if (sign(vSpeed) == movePlayerV) {
							
							//multiply by default walk speed
							vSpeed = (walkSpeed * movePlayerV);
								
						//if switching directions, decelerate
						} else if (sign(movePlayerV) != sign(vSpeed) && abs(movePlayerV) > DEADZONE) vSpeed -= (playerDecel * sign(vSpeed));
					
					}
					
					//check if there's a collision before moving
					if (place_meeting(x, y + vSpeed, oWall)) {
							
						//precise collisions
						while (!place_meeting(x, y + sign(vSpeed), oWall)) y += sign(vSpeed);
							
						//set to 0 if colliding
						vSpeed = -vSpeed * ZEROG_COLLISION;	
					}
					
					//apply vSpeed (vertical movement)
					y += (vSpeed);
					
						
					//horizontal movement
					
					//if our horizontal speed is less than our set walk speed, accelerate
					if (abs(hSpeed) < walkSpeed) {
						
						//increase player acceleration by the acceleration increment in either direction each frame
						hSpeed += (playerAccel * movePlayerH);
						
					}
					//if our horizontal movement is equal to hSpeed, normal movement and collisions
					else if ((abs(hSpeed) >= walkSpeed))  {
						
						//run a check that only lets the player keep constant velocity if they are not switching directions
						if (sign(hSpeed) == movePlayerH) {
							
							//multiply by default walk speed
							hSpeed = (walkSpeed * movePlayerH);
								
						//if switching directions, decelerate
						} else if (sign(movePlayerH) != sign(hSpeed) && abs(movePlayerH) > DEADZONE) hSpeed -= (playerDecel * sign(hSpeed));
						
					}
						
					//check if there's a collision before moving
					if (place_meeting(x + hSpeed, y, oWall)) {
							
						//precise collisions
						while (!place_meeting(x + sign(hSpeed), y, oWall)) x += sign(hSpeed);
							
						//set to 0 if colliding
						hSpeed = -hSpeed * ZEROG_COLLISION
					}
					
					//apply hSpeed (horizontal movement)
					x += (hSpeed);
					
						
				}
				
				#endregion
				
				#region touch movement and collisions
				else if (inputType == TOUCH) {
					//nothing yet	
				}
				#endregion

				#region sprite animation updating
				
				//vertical
				if (place_meeting(x, y + vSpeed, oWall) && !movePlayerV) {
					sprite_index = sPlayerBump;
					bumpTimer = WALL_OOF
				} else {
					if (bumpTimer > NOT_MOVING) bumpTimer--;	
					if (sprite_index == sPlayerBump && bumpTimer <= NOT_MOVING) sprite_index = sPlayer;	
				}
				
				//horizontal
				if (place_meeting(x + hSpeed, y, oWall) && !movePlayerH) {
					sprite_index = sPlayerBump;
					bumpTimer = WALL_OOF
				} else {
					if (bumpTimer > NOT_MOVING) bumpTimer--;	
					if (sprite_index == sPlayerBump && bumpTimer <= NOT_MOVING) sprite_index = sPlayer;	
				}
				#endregion
				
				break;
				
			#endregion
			
			#region cutscene state
			
			//ON cutscene start (this could be a broader game state too?)
			case playerStates.CUTSCENE:
		
				break;
				
			#endregion
			
			#region teleport state
			
			//ON player teleport
			case playerStates.TELEPORT:
		
				break;
				
			#endregion
				
			#region menu state
			
			//ON menu open
			case playerStates.MENU:
			
				break;
				
			#endregion
	}
	
	#endregion
	
	#region Health States
	
	switch (healthState) {
		
		case healthStates.HEALTHY:
		
			if (place_meeting(x, y, oEnemy) && flinchTimer == NOT_MOVING) {
				
				playerHealth--;
				
				if (playerHealth > NOT_MOVING) {
					healthState = healthStates.DAMAGED;
					flinchTimer = ATTACK_OOF;
				} else if (playerHealth <= NOT_MOVING) {
					healthState = healthStates.DEAD;	
				}
			}
		
		break;
		
		case healthStates.DAMAGED:
		
			if (flinchTimer > NOT_MOVING) {
				flinchTimer--; 
				sprite_index = sPlayerBump;
			} else if (flinchTimer == NOT_MOVING) {
				healthState = healthStates.HEALTHY;	
			}
		
		break;
		
		case healthStates.DEAD:

		//game over screen or something, 
		//stopping player movement is managed in the other player states by checking this state the next frame
		
		//death sprite
		sprite_index = sPlayerDead;
		
		break;
	
	}
	
	#endregion

} 
#endregion

#region co-op code


//CO-OP (keyboard + controller, controller + controller, probably PC only)
else if (global.gameMode == CO_OP) {
	
		#region multi-input
		//kb+m AND gamepad
		if (inputType == KB_AND_PAD) {
			//only for co-op
		}
		#endregion
		
	
}

#endregion
