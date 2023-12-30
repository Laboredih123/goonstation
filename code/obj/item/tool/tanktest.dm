/obj/item/tanktest
	name = "tanktest"
	icon = 'icons/obj/items/tools/crowbar.dmi'
	icon_state = "crowbar"

	var/datum/gas_mixture/tank1
	var/datum/gas_mixture/tank2
	var/datum/gas_mixture/tank3
	var/tank3integrity = 3
	var/whathappened = ""
	var/oxyperc = 1
	var/oxyperc2 = 1
	var/prestarget1 = 1013.25
	var/prestarget2 = 1013.25

/obj/item/tanktest/New()
	..()
	src.tank1 = new
	src.tank1.volume = 70
	src.tank1.temperature = T20C
	src.tank2 = new
	src.tank2.volume = 70
	src.tank2.temperature = T20C
	src.tank3 = new
	src.tank3.volume = 70
	src.tank3.temperature = T20C

/obj/item/tanktest/attack_self(mob/user)
	src.ui_interact(user)

/obj/item/tanktest/ui_interact(mob/user, datum/tgui/ui)
	ui = tgui_process.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "TankTesting", name)
		ui.open()

/obj/item/tanktest/ui_data(mob/user)
	. = list(
		"oxygen1" = src.oxyperc*100,
		"plasma1" = (1 - src.oxyperc)*100,
		"pressure1" = src.prestarget1,
		"temp1" = src.tank1.temperature,
		"oxygen2" = src.oxyperc2*100,
		"plasma2" = (1 - src.oxyperc2)*100,
		"pressure2" = src.prestarget2,
		"temp2" = src.tank2.temperature,
		"pressure3" = MIXTURE_PRESSURE(src.tank3),
		"tank3integrity" = src.tank3integrity,
		"tank3range" = min(((MIXTURE_PRESSURE(src.tank3) - TANK_FRAGMENT_PRESSURE)/TANK_FRAGMENT_SCALE), 12),
		"events" = src.whathappened,
	)

/obj/item/tanktest/ui_static_data(mob/user)
	. = list(
		"tankleak" = TANK_LEAK_PRESSURE,
		"tankbreak" = TANK_RUPTURE_PRESSURE,
		"tankblow" = TANK_FRAGMENT_PRESSURE,
	)

/obj/item/tanktest/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return
	switch(action)
		if("mix")
			var/datum/gas_mixture/temp = new
			temp.copy_from(src.tank1)
			src.tank3.merge(temp)
			temp = new
			temp.copy_from(src.tank2)
			src.tank3.merge(temp)
			src.tank3.remove_ratio(0.5)
			src.whathappened = "Tanks merged into result and halved."
			. = TRUE
		if("step")
			src.whathappened = ""
			if(src.tank3.react() && COMBUSTION_ACTIVE)
				src.whathappened = "Tank experienced combustion. "
			var/pressure = MIXTURE_PRESSURE(src.tank3)
			if(pressure > TANK_FRAGMENT_PRESSURE) // 50 atmospheres, or: 5066.25 kpa under current _setup.dm conditions
				//Give the gas a chance to build up more pressure through reacting
				src.tank3.react()
				src.tank3.react()
				src.tank3.react()
				src.whathappened += "Tank passed fragment pressure, reacted thrice, and blew!"

			else if(pressure > TANK_RUPTURE_PRESSURE)
				if(src.tank3integrity <= 0)
					ZERO_GASES(src.tank3)
					src.whathappened += "Tank reached 0 integrity, ruptured, and lost all air."
				else
					src.whathappened += "Tank lost integrity."
					src.tank3integrity--

			else if(pressure > TANK_LEAK_PRESSURE)
				if(src.tank3integrity <= 0)
					src.tank3.remove_ratio(0.25)
					src.whathappened += "Tank reached 0 integrity and is leaking! 25% of air lost."
				else
					src.whathappened += "Tank lost integrity."
					src.tank3integrity--

			else if(src.tank3integrity < 3)
				src.whathappened += "Tank gained integrity."
				src.tank3integrity++
			else
				src.whathappened += "Nothing of note."
			. = TRUE
		if("reset")
			src.whathappened = "Tank reset."
			src.tank3integrity = 3
			ZERO_GASES(src.tank3)
			. = TRUE
		if("adjustoxy1")
			src.oxyperc = params["percent"]/100
			src.tank1.oxygen = (src.oxyperc*src.prestarget1*src.tank1.volume)/(R_IDEAL_GAS_EQUATION * src.tank1.temperature)
			src.tank1.toxins = ((1 - src.oxyperc)*src.prestarget1*src.tank1.volume)/(R_IDEAL_GAS_EQUATION * src.tank1.temperature)
			. = TRUE
		if("adjusttox1")
			src.oxyperc = (1 - params["percent"]/100)
			src.tank1.oxygen = (src.oxyperc*src.prestarget1*src.tank1.volume)/(R_IDEAL_GAS_EQUATION * src.tank1.temperature)
			src.tank1.toxins = ((1 - src.oxyperc)*src.prestarget1*src.tank1.volume)/(R_IDEAL_GAS_EQUATION * src.tank1.temperature)
			. = TRUE
		if("adjusttemp1")
			src.tank1.temperature = params["kelvin"]
			. = TRUE
		if("adjustpres1")
			src.prestarget1 = params["kpa"]
			src.tank1.oxygen = (src.oxyperc*src.prestarget1*src.tank1.volume)/(R_IDEAL_GAS_EQUATION * src.tank1.temperature)
			src.tank1.toxins = ((1 - src.oxyperc)*src.prestarget1*src.tank1.volume)/(R_IDEAL_GAS_EQUATION * src.tank1.temperature)
			. = TRUE
		if("adjustoxy2")
			src.oxyperc2 = params["percent"]/100
			src.tank2.oxygen = (src.oxyperc2*src.prestarget2*src.tank2.volume)/(R_IDEAL_GAS_EQUATION * src.tank2.temperature)
			src.tank2.toxins = ((1 - src.oxyperc2)*src.prestarget2*src.tank2.volume)/(R_IDEAL_GAS_EQUATION * src.tank2.temperature)
			. = TRUE
		if("adjusttox2")
			src.oxyperc2 = (1 - params["percent"]/100)
			src.tank2.oxygen = (src.oxyperc2*src.prestarget2*src.tank2.volume)/(R_IDEAL_GAS_EQUATION * src.tank2.temperature)
			src.tank2.toxins = ((1 - src.oxyperc2)*src.prestarget2*src.tank2.volume)/(R_IDEAL_GAS_EQUATION * src.tank2.temperature)
			. = TRUE
		if("adjusttemp2")
			src.tank2.temperature = params["kelvin"]
			. = TRUE
		if("adjustpres2")
			src.prestarget2 = params["kpa"]
			src.tank2.oxygen = ((src.oxyperc2)*src.prestarget2*src.tank2.volume)/(R_IDEAL_GAS_EQUATION * src.tank2.temperature)
			src.tank2.toxins = ((1 - src.oxyperc2)*src.prestarget2*src.tank2.volume)/(R_IDEAL_GAS_EQUATION * src.tank2.temperature)
			. = TRUE
