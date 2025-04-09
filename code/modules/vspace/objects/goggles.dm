/obj/item/clothing/glasses/vr
	name = "\improper V-Space goggles"
	desc = "A pair of V-Space goggles running a simulation."
	icon_state = "vr"
	item_state = "vr"
	var/network = null

	setupProperties()
		..()
		setProperty("disorient_resist_eye", 28)

	New()
		SPAWN(2 SECONDS)
			if (src)
				src.name += " - '[src.network]'" // They otherwise all look the same (Convair880).
		..()

	equipped(var/mob/user, var/slot)
		..()
		var/mob/living/carbon/human/H = user
		if(istype(H) && slot == SLOT_GLASSES && !H.network_device && !inafterlife(H))
			user.network_device = src
			//user.verbs += /mob/proc/jack_in
			Station_VNet.Enter_Vspace(H, src,src.network)
		return

	unequipped(var/mob/user)
		..()
		if(ishuman(user) && user:network_device == src)
			//user.verbs -= /mob/proc/jack_in
			user:network_device = null
		return


/obj/item/clothing/glasses/vr/detnet
	icon_state = "vr-detective"
	item_state = "vr-detective"
	network = LANDMARK_VR_DET_NET

// is this even used?
/obj/item/clothing/glasses/vr_fake //Only exist IN THE MATRIX.  Used to log out.
	name = "\improper V-Space goggles"
	desc = "A pair of V-Space goggles running a personal simulation.  You should know this, being IN the simulation and all."
	icon_state = "vr"
	item_state = "vr"

	unequipped(var/mob/user)
		..()
		if(istype(user, /mob/living/carbon/human/virtual) && user:body)
			user.death()
		return

/obj/item/clothing/glasses/vr/arcade
	icon_state = "vr"
	item_state = "vr"
	network = LANDMARK_VR_ARCADE

/obj/item/clothing/glasses/vr/bomb
	icon_state = "vr_science"
	item_state = "vr_science"
	network = LANDMARK_VR_BOMBTEST
