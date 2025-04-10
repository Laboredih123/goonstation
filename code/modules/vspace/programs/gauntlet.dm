/obj/item/disk/data/floppy/vspace/gauntlet
	name = "\improper V-Space Program - Gauntlet"
	icon_state = "arcade-disk2"

ABSTRACT_TYPE(/area/gauntlet)
/area/gauntlet
	name = "V-Space Gauntlet Zone"
	icon_state = "dk_yellow"
	virtual = 1
	dont_log_combat = TRUE

/area/gauntlet/arena
	name = "V-Space Gauntlet Arena Zone"
	icon_state = "dk_yellow"

	Entered(var/atom/A)
		..()
		if (!ismob(A))
			return
		if (gauntlet_controller.state == 1)
			for (var/mob/living/L in gauntlet_controller.staging)
				return
			gauntlet_controller.finishStaging()

/area/gauntlet/staging
	name = "V-Space Gauntlet Staging Zone"
	icon_state = "purple"
	virtual = 1
	ambient_light = "#bfbfbf"

	Entered(var/atom/movable/A)
		..()
		if (isliving(A))
			if (gauntlet_controller.state >= 2)
				A:gib()

/area/gauntlet/viewing
	name = "V-Space Gauntlet Spectator Zone"
	icon_state = "green"
	virtual = 1
	ambient_light = "#bfbfbf"


/obj/stagebutton
	name = "Gauntlet Staging Button"
	desc = "By pressing this button, you begin the staging process. No more new attendees will be accepted."
	anchored = ANCHORED
	density = 0
	opacity = 0
	icon = 'icons/effects/VR.dmi'
	icon_state = "doorctrl0"

	attack_hand(var/mob/M)
		if (gauntlet_controller.state != 0)
			return
		if (ticker.round_elapsed_ticks < 3000)
			boutput(usr, SPAN_ALERT("You may not initiate the Gauntlet before 5 minutes into the round."))
			return
		if (alert("Start the Gauntlet? No more players will be given admittance to the staging area!",, "Yes", "No") == "Yes")
			if (gauntlet_controller.state != 0)
				return
			gauntlet_controller.beginStaging()

/turf/unsimulated/floor/setpieces/gauntlet
	name = "Gauntlet Floor"
	desc = "Artist needs effort badly."
	icon = 'icons/effects/VR.dmi'
	icon_state = "gauntfloorDefault"

/turf/unsimulated/wall/setpieces/gauntlet
	name = "Gauntlet Wall"
	desc = "Is this retro? Thank god it's not team ninja."
	icon = 'icons/effects/VR.dmi'
	icon_state = "gauntwall"
