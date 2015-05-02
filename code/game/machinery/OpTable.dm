/obj/machinery/optable
	name = "Operating Table"
	desc = "Used for advanced medical procedures."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "table2-idle"
	density = 1
	anchored = 1.0
	use_power = 1
	idle_power_usage = 1
	active_power_usage = 5
	var/mob/living/carbon/human/victim = null
	var/strapped = 0.0
	var/dispenser = 0
	var/breakouttime = 1200 //Deciseconds = 120s = 2 minutes
	var/cuff_sound = 'sound/weapons/handcuffs.ogg'

	var/obj/machinery/computer/operating/computer = null

/obj/machinery/optable/New()
	..()
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		computer = locate(/obj/machinery/computer/operating, get_step(src, dir))
		if (computer)
			computer.table = src
			break
//	spawn(100) //Wont the MC just call this process() before and at the 10 second mark anyway?
//		process()

/obj/machinery/optable/ex_act(severity)

	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				//SN src = null
				del(src)
				return
		if(3.0)
			if (prob(25))
				src.density = 0
		else
	return

/obj/machinery/optable/blob_act()
	if(prob(75))
		del(src)

/obj/machinery/optable/attack_hand(mob/user as mob)
	if(locate(/mob/living/carbon/human, src.loc))
		var/mob/living/carbon/human/M = locate(/mob/living/carbon/human, src.loc)
		if(M.lying)
			src.victim = M
		//var/mob/living/carbon/human/M = locate(/mob/living/carbon/human, src.loc)
		if (!istype(M, /mob/living/carbon/human))
			usr << "\red You don't have the dexterity to do this!"
			return
		if ((CLUMSY in M.mutations) && prob(50))
			usr << "\red Uh ... how do those things work?!"
			place_handcuffs(M, usr)
			return
		if(!M.handcuffed)
			if (M == usr)
				place_handcuffs(M, usr)
				return

			//check for an aggressive grab
			for (var/obj/item/weapon/grab/G in M.grabbed_by)
				if (G.loc == usr && G.state >= GRAB_AGGRESSIVE)
					place_handcuffs(M, usr)
					return
			usr << "\red You need to have a firm grip on [M] before you can put \the [src] on!"

/obj/machinery/optable/proc/place_handcuffs(var/mob/living/carbon/target, var/mob/user)
	playsound(src.loc, cuff_sound, 30, 1, -2)

	if (ishuman(target))
		var/mob/living/carbon/human/H = target

		if (!H.has_organ_for_slot(slot_handcuffed))
			user << "<span class='danger'>\The [H] needs at least two wrists before you can cuff them together!</span>"
			return

		if(istype(H.gloves,/obj/item/clothing/gloves/rig)) // Can't cuff someone who's in a deployed hardsuit.
			user << "<span class='danger'>The cuffs won't fit around \the [H.gloves]!</span>"
			return

		H.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been handcuffed (attempt) by [user.name] ([user.ckey])</font>")
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to handcuff [H.name] ([H.ckey])</font>")
		msg_admin_attack("[key_name(user)] attempted to handcuff [key_name(H)]")

		var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
		O.source = user
		O.target = H
		//O.item = user.get_active_hand()
		O.s_loc = user.loc
		O.t_loc = H.loc
		O.place = "handcuff"
		H.requests += O
		spawn( 0 )
			feedback_add_details("handcuffs","H")
			O.process()
		return

	if (ismonkey(target))
		var/mob/living/carbon/monkey/M = target
		var/obj/effect/equip_e/monkey/O = new /obj/effect/equip_e/monkey(  )
		O.source = user
		O.target = M
		O.item = user.get_active_hand()
		O.s_loc = user.loc
		O.t_loc = M.loc
		O.place = "handcuff"
		M.requests += O
		spawn( 0 )
			O.process()
		return


/obj/machinery/optable/attack_hand(mob/user as mob)
	if (HULK in usr.mutations)
		usr << text("\blue You destroy the table.")
		visible_message("\red [usr] destroys the operating table!")
		src.density = 0
		del(src)
	return

/obj/machinery/optable/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0


/obj/machinery/optable/MouseDrop_T(obj/O as obj, mob/user as mob)

	if ((!( istype(O, /obj/item/weapon) ) || user.get_active_hand() != O))
		return
	user.drop_item()
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/machinery/optable/proc/check_victim()
	if(locate(/mob/living/carbon/human, src.loc))
		var/mob/living/carbon/human/M = locate(/mob/living/carbon/human, src.loc)
		if(M.lying)
			src.victim = M
			icon_state = M.pulse ? "table2-active" : "table2-idle"
			return 1
	src.victim = null
	icon_state = "table2-idle"
	return 0

/obj/machinery/optable/process()
	check_victim()

/obj/machinery/optable/proc/take_victim(mob/living/carbon/C, mob/living/carbon/user as mob)
	if (C == user)
		user.visible_message("[user] climbs on the operating table.","You climb on the operating table.")
	else
		visible_message("\red [C] has been laid on the operating table by [user].", 3)
	if (C.client)
		C.client.perspective = EYE_PERSPECTIVE
		C.client.eye = src
	C.resting = 1
	C.loc = src.loc
	for(var/obj/O in src)
		O.loc = src.loc
	src.add_fingerprint(user)
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		src.victim = H
		icon_state = H.pulse ? "table2-active" : "table2-idle"
	else
		icon_state = "table2-idle"

/obj/machinery/optable/verb/climb_on()
	set name = "Climb On Table"
	set category = "Object"
	set src in oview(1)

	if(usr.stat || !ishuman(usr) || usr.restrained() || !check_table(usr))
		return

	take_victim(usr,usr)

/obj/machinery/optable/attackby(obj/item/weapon/W as obj, mob/living/carbon/user as mob)
	if (istype(W, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = W
		if(iscarbon(G.affecting) && check_table(G.affecting))
			take_victim(G.affecting,usr)
			del(W)
			return

/obj/machinery/optable/proc/check_table(mob/living/carbon/patient as mob)
	if(src.victim)
		usr << "\blue <B>The table is already occupied!</B>"
		return 0

	if(patient.buckled)
		usr << "\blue <B>Unbuckle first!</B>"
		return 0

	return 1
