/obj/item/atmosconstruct
	name = "Atmos Construct"
	desc = "A atmospheric device waiting to be placed."
	icon = 'icons/obj/atmospherics/atmositem.dmi'
	icon_state = ""
	var/pipe_type

	w_class = W_CLASS_GIGANTIC
	p_class = 3

	New()
		..()
		BLOCK_SETUP(BLOCK_ROD)

	attackby(var/obj/item/W as obj, var/mob/user as mob)
		if(isweldingtool(W) && isturf(src.loc))
			var/obj/machinery/atmospherics/spawneditem
			switch(pipe_type)
				if("pipe", "bentpipe")
					var/obj/machinery/atmospherics/pipe/simple/spawned = new(src.loc)
					spawned.parent = null
					spawneditem = spawned
				if("manifold")
					var/obj/machinery/atmospherics/pipe/manifold/spawned = new(src.loc)
					spawned.parent = null
					spawneditem = spawned
			spawneditem.dir = dir
			spawneditem.color = src.color
			spawneditem.level = src.level
			spawneditem.initialize()
			qdel(src)
		else
			..()
	attack_hand(mob/user)
		dir = turn(dir, 90)
		..()


