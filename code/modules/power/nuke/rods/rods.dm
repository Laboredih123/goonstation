/obj/item/nuke/rod

	icon = 'icons/obj/machines/nuclear.dmi'
	icon_state = "fr0"

	var/initial_volume = 100
	//datum/material/fissile/initial_materials[] = list();
	var/sv_ratio = 1.0

	/* emission ratio per cardinal direction -- these should all add up to 1.0, default is to emit radiation omnidirectionally in equal ratios */
	var/flux_card_n = 0.25
	var/flux_card_e = 0.25
	var/flux_card_s = 0.25
	var/flux_card_w = 0.25

	var/internal_heat = 0
	var/amb_heat = 0

	proc/get_flux()
		var/datum/material/fissile/mat = src.material
		return initial_volume * mat.epv

/obj/item/nuke/rod/u235_test
	name = "U235 for testing"
	desc = "todo"

	initial_volume = 50

	sv_ratio = 1.22

	New()
		..()
		setMaterial(getMaterial("u-235"))

/obj/item/nuke/rod/pu239_test
	name = "Pu239 for testing"
	desc = "todo"

	initial_volume = 50

	sv_ratio = 1.22

	New()
		..()
		setMaterial(getMaterial("pu-239"))


/obj/item/nuke/rod/kfuel_test
	name = "kremlin's fuel for testing"
	desc = "todo"

	initial_volume = 50

	sv_ratio = 1.22

	New()
		..()
		setMaterial(getMaterial("kmetal"))
