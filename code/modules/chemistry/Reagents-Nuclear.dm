/*
	vars:
		nuke_compat: 1 to mark reagent as suitable for nuclear reactor input. all reagents in this file should set this
		fissile: 1 if reagent emits particle radition suitable for fission-type reactions. "is it nuclear fuel"
		part_type: emission particle type. currently only 'neutron' is valid
		epv: emissivity per volume unit -- rate at which particles emit per mass (err, "vol") unit
		hpe: heat generated per emission -- rate at which heat is generated per scalar emission amount
		absorb: percentage of incoming particle flux absorbed -- 1.0 = perfect particle shield, 0 = vaccum
		k_factor: criticality factor, rate at which new particles are generated/emitted per particle absorbtion. "The six factor formula effective neutron multiplication factor"
		products: list of byproducts created when parent reagent undergoes fission. requires products_r
		products_r: percentage at which the above byproducts are created. 1-to-1, must match index of above. requires products
*/

/datum/reagent/nuclear
	var/nuke_compat = 1
	var/fissile = 0
	var/part_type = "neutron"
	var/epv = 0
	var/hpe = 0
	var/absorb = 0.0
	var/k_factor = 0

/datum/reagent/nuclear/u238
	name = "uranium-238"
	id = "u238"
	description = "A slightly radioactive heavy metal not suitable for nuclear fission. This is the unenriched byproduct form."
	fluid_r = 30
	fluid_g = 70
	fluid_b = 30
	transparency = 255

	nuke_compat = 1
	fissile = 1
	part_type = "neutron"
	epv = 0.1
	hpe = 20
	absorb = 0.90
	k_factor = 0.3

	on_mob_life(var/mob/M, var/mult = 1 )
		if(!M) M = holder.my_atom
		M.changeStatus("radiation", 0.5 SECONDS * mult, 1)
		..()

	on_plant_life(var/obj/machinery/plantpot/P)
		P.HYPdamageplant("radiation",2)
		if (prob(24))
			P.HYPmutateplant(1)

/datum/reagent/nuclear/u235
	name = "uranium-235"
	id = "u235"
	description = "A radioactive dull silver-green heavy metal. This is the enriched form suitable for use as nuclear fuel."
	reagent_state = SOLID
	fluid_r = 40
	fluid_g = 100
	fluid_b = 40
	transparency = 255

	nuke_compat = 1
	fissile = 1
	part_type = "neutron"
	epv = 5
	hpe = 20
	absorb = 0.80
	k_factor = 3.0

	on_mob_life(var/mob/M, var/mult = 1 )
		if(!M)
			M = holder.my_atom
		M.changeStatus("radiation", 4 SECONDS * mult, 1)
		..()

	on_plant_life(var/obj/machinery/plantpot/P)
		P.HYPdamageplant("radiation",2)
		if (prob(24))
			P.HYPmutateplant(1)

/datum/reagent/nuclear/pu239
	name = "plutonium-239"
	id = "pu239"
	description = "A highly radioactive dull silver-blue heavy metal. This is the enriched form suitable for use as nuclear fuel."
	reagent_state = SOLID
	fluid_r = 40
	fluid_g = 40
	fluid_b = 100
	transparency = 255

	nuke_compat = 1
	fissile = 1
	part_type = "neutron"
	epv = 7
	hpe = 30
	absorb = 0.85
	k_factor = 5.0

	on_mob_life(var/mob/M, var/mult = 1 )
		if(!M)
			M = holder.my_atom
		M.changeStatus("radiation", 5.5 SECONDS * mult, 1)
		..()

	on_plant_life(var/obj/machinery/plantpot/P)
		P.HYPdamageplant("radiation",2)
		if (prob(24))
			P.HYPmutateplant(1)


/datum/reagent/nuclear/kremfuel
	name = "kremlinium"
	id = "kremfuel"
	description = "debug metal"
	reagent_state = SOLID
	fluid_r = 150
	fluid_g = 0
	fluid_b = 0
	transparency = 255

	nuke_compat = 1
	fissile = 1
	part_type = "neutron"
	epv = 400
	hpe = 400
	absorb = 1.0
	k_factor = 20.0
