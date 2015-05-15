//Sportroom for New Black by M962
//Gift from the Syndicate station 13
//And yes, all items of sportroom in one file. Not so great feature.

//VERSION 0.2,5//
//What we have for now//
/*
	1. Horizontal rod
	2. Sport bed with weight rod
	3. Some turfs
	4. Boombox
	5. Transpiration
	6. Unfinished boxing bag
	7. Running track. bugged and very unfinished.
*/

//What i want to do soon//
/*
	1. Yoga
	2. Maybe something else
	3. Oh, and fix shitting bugs and bad code
*/
//This code touched some files:
//jukebox.dmi
//human.dm
//clothing.dm
//examine.dm //human

//Horizontal rod
//i know about relaymove(), but here i use proc loop
/obj/structure/horizontal_rod
	name = "Horizontal rod"
	desc = "This is rod has mounted on two pieces of iron."
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "horizontal_rod"
	anchored = 1
	layer = 5 //under player
	var/my_pos
	var/climb
	var/up_count

/obj/structure/horizontal_rod/proc/checker(var/mob/living/carbon/human/guy) //this activates while in use
	while(guy.loc == src.loc)
		sleep(10)
		checker(guy)
	if(climb)
		climbing_out(guy)

/obj/structure/horizontal_rod/MouseDrop_T(var/mob/living/carbon/human/H, var/mob/living/carbon/human/user)
	if(climb)
		H << "You are already on the rod"
		return
	if(H.health < 40)
		H << "/red Your wounds is too bad for use this."
	if(src.loc != H.loc)
		return
	climb = 1
	climbing_up(H)


/obj/structure/horizontal_rod/proc/climbing_up(var/mob/living/carbon/human/user) //climb on the rod
	user.visible_message("[user] jump and get [src.name].",	\
				"\blue You grab the rod.")
	if(climb)
		my_pos = user.pixel_y
		user.pixel_y += 2
		checker(user)

/obj/structure/horizontal_rod/proc/climbing_out(var/mob/living/carbon/human/user) //jump off the rod
	user.visible_message("[user] released the [src.name] and landed on floor.",	\
				"\blue You release rod and land on your feet.")
	climb = 0
	user.pixel_y = my_pos
	up_count = 0

/obj/structure/horizontal_rod/attack_hand(var/mob/living/carbon/human/user) //get up!
	if(!climb)
		return
	if(up_count == 6)
		user.visible_message("[user] keeps on top with straight arms.",	\
				"\blue You are on the top of horizontal rod.")
	if(up_count > 6)
		user.pixel_y = my_pos
		up_count = 0
		user.visible_message("[user] do it!",	\
				"\blue You do it!")

	user.visible_message("[user] tries to get up!",	\
				"\blue You tries to get... up! U-u-ugh!")
	user.pixel_y += 2
	up_count++
	if(prob(10))
		user.sweat_lvl++
		if(user.sweat_lvl > 4)
			user.sweat_lvl = 4
		user.perspiration()

//Sport bed
/obj/structure/bed/chair/sport_bed
	name = "sport bed"
	desc = "Simple body trainer. This is always great if you do it when lay"
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "sport_bed"
	anchored = 1

	New()
		new /obj/structure/hands_rod(src.loc)

//hands rod
/obj/structure/hands_rod
	name = "hands rod"
	desc = "Just metal rod with some discs of steel on both sides."
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "rod_weight_0"
	layer = 5
	anchored = 1 //why not?
	var/discs = 0
	var/list/unbalanced = list(1, 3, 5)
	var/up_count
	var/lifted = 0

/obj/structure/hands_rod/proc/lifting()
	for(src.pixel_y, src.pixel_y < 10, src.pixel_y++)
		sleep(1)
	for(src.pixel_y, src.pixel_y > 0, src.pixel_y--)
		sleep(1)
	if(src.pixel_y < 0)
		src.pixel_y = 0

/obj/structure/hands_rod/attack_hand(var/mob/living/carbon/human/user)
	if(lifted)
		return
	if(user.health < 40)
		user << "/red Your wounds is too bad for use this."
	if(user.buckled)
		if(prob(17))
			user.sweat_lvl++
			if(user.sweat_lvl > 4)
				user.sweat_lvl = 4
			user.perspiration()
		if(discs == 0)
			lifted = 1
			user.visible_message("[user] easily lifted [src]!",	\
				"\blue You easily lifted [src]!")
			src.lifting()
			lifted = 0
		if(discs == 2)
			lifted = 1
			user.visible_message("[user] lifted [src] with little effort!",	\
				"\blue You lifted with little effort [src]!")
			src.lifting()
			lifted = 0
		if(discs == 4)
			lifted = 1
			user.visible_message("[user] lifted [src] with great difficulty!",	\
				"\blue You lifted [src] with great difficulty!")
			src.lifting()
			lifted = 0
		if(discs == 6)
			lifted = 1
			user.visible_message("[user] lifted [src]! So strong!",	\
				"\blue You lifted [src]! You got it! So stonger!")
			src.lifting()
			lifted = 0
		if(discs in unbalanced)
			user.visible_message("\red [user] tried to lift [src], but it's unbalanced!",	\
				"\red You trying to lift this [src], but barely managed to keep this unbalanced rod!")
			src.icon_state = turn(src.icon_state, 30)
			sleep(5)
			src.icon_state = turn(src.icon_state, -30)
	else
		user << "\red You need to be buckled first"

/obj/structure/hands_rod/attackby(var/obj/item/weapon/disc/D, mob/user as mob)
	if(!istype(D, /obj/item/weapon/disc)) //ugh
		return
	if(discs > 5)
		user << "\red not enough space for this disc"
		return
	if(discs < 0) //what a shame
		discs = 1
	discs++
	icon_state = "rod_weight_[discs]"
	user << "\blue You attach [D] to [src.name]"
	del D //yep, i can use D.loc = src, but naaah

/obj/structure/hands_rod/verb/get_off_disc()
	set name = "Remove the disc"
	set category = "Object"
	set src in oview(1)


	if(discs)
		discs--
		new /obj/item/weapon/disc(src.loc)
		usr << "\blue You remove disc from the rod"
	else
		usr << "Disc? Where?"
	icon_state = "rod_weight_[discs]"

/obj/item/weapon/disc
	name = "Disc"
	desc = "Steel piece of metal with hole in a center."
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "disc"
	force = 3.2

	New()
		src.pixel_y = rand(-8, 8)
		src.pixel_x = rand(-8, 8)

//space yoga
/obj/item/weapon/yoga
	name = "Yoga rug"
	desc = "Smooth synthetic fabric special for sport, meditation and space yoga."
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "yoga1_rug_roll"
	var/rug_col = 1 //color of rug. 1 is orange, 2 is green and 3 is navy, blue

	New()
		rug_col = rand(1, 3)
		icon_state = "yoga[rug_col]_rug_roll"

/obj/item/weapon/yoga/attack_self(mob/user)
	var/obj/structure/yoga/Y = new(user.loc)
	Y.change_icon(src.rug_col)
	user.visible_message("[user] unrolles their [src].",	\
				"\blue You unroll your [src].")
	if(istype(user.get_active_hand(),src))
		user.drop_item()
	src.loc = Y

/obj/structure/yoga
	name = "Yoga rug"
	desc = "Smooth synthetic fabric special for sport, meditation and space yoga."
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "yoga1_rug_unroll"
	var/col

/obj/structure/yoga/proc/change_icon(var/rug_col)
	icon_state = "yoga[rug_col]_rug_unroll"
	src.col = rug_col

/obj/structure/yoga/MouseDrop_T(var/mob/living/carbon/human/user)
	for(var/obj/item/weapon/yoga/Y in src.contents)
		Y.loc = user.loc
	user.visible_message("[user] rolles their [src].",	\
				"\blue You roll your [src].")
	del src

//So and this is end of yoga and my ideas. I add other in next update, but before i think about it. - M962


//boxing bag. Oh, yeah. This ported from syndie by part, eh.
//Not working yet.
/obj/structure/boxing_stand
	name = "Boxing stand"
	desc = "This stand hang up the boxing bag."
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "boxing_stand"
	density = 1
	anchored = 1 //yep, why not?

	New()
		new /obj/structure/boxing_bag(src.loc)

/obj/structure/boxing_bag
	name = "Boxing bag"
	desc = "Boxing bag for train your fists and your body."
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "boxing_part"
	anchored = 1
//	var/forcing //coming soon...

/obj/structure/boxing_bag/attack_hand(var/mob/living/carbon/human/user)
	user.visible_message("[user] beats the [src]!",	\
				"\blue You attack this [src]!")
	flick("boxing_part_anim", src)
	if(prob(12))
		user.sweat_lvl++
		if(user.sweat_lvl > 4)
			user.sweat_lvl = 4
		user.perspiration()
	/*forcing += 4
	if(forcing > 8)
		forcing = 8
	while(forcing >= 1)
		var/turn_out = round(forcing + (forcing/2)) ////// I'm working under physics sim. Stay waitguy :c
		for(forcing, forcing < 1, forcing--)
			sleep(4)
			src.icon = turn(src.icon, 5)
			world << "kitty"
		forcing = round(forcing - (forcing/2))
		sleep(8)
		for(turn_out, turn_out < 1, turn_out--)
			sleep(4)
			src.icon = turn(src.icon, -5)
		forcing = round(turn_out + (turn_out/2))*/
//	src.icon = turn(src.icon, 5)
	return

//Running track
/obj/machinery/running_track_terminal
	name = "Running track's terminal"
	desc = "This terminal controls running track, you see small pad and display on it"
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "running_terminal"
	anchored = 1
	density = 1
	var/working = 0
	var/speed = 0
	var/dat = ""
	var/obj/structure/running_track/begin/B
	var/obj/structure/running_track/T
	var/obj/structure/running_track/end/E
	idle_power_usage = 60
	active_power_usage = 180


	New()
		if(dir in cardinal)
			B = new(get_step(src, dir))
			B.dir = dir
			B.main_machine = src
			T = new(get_step(B, dir))
			T.dir = dir
			T.main_machine = B
			E = new(get_step(T, dir))
			E.dir = dir
			E.main_machine = T

/obj/machinery/running_track_terminal/attack_hand(mob/user)
	dat = "<html><head><title>RTT</title></head><body><TT><p align=center><B>RUNNING TRACK TERMINAL</B></p><HR>"
	dat += "Status: <A href='?src=\ref[src];button=1'>[working ? "On" : "Off"]</A><BR>"
	if(working == 1)
		dat += "<A href='?src=\ref[src];minus=1'>-</A>[speed]<A href='?src=\ref[src];plus=1'>+</A>"
	dat += "</TT></body></html>"
	user << browse(dat, "window=running_track;size=400x680")
	onclose(user, "running_track")
	return


/obj/machinery/running_track_terminal/Topic(href, href_list)
	if(href_list["minus"])
		src.speed--
	if(href_list["plus"])
		src.speed++
	if(href_list["button"])
		if(working)
			working = 0
			src.speed = 0
		else
			src.work_in()
			working = 1
			src.speed = 1
	updating()

/obj/machinery/running_track_terminal/proc/updating()
	usr << browse(dat, "window=running_track")
	src.attack_hand(usr)
	return

/obj/machinery/running_track_terminal/proc/work_in()
	if(working)
		while(speed > 0)
			sleep(1)
			B.moving()
			T.moving()
			E.moving()
		if(src.speed < 1)
			src.speed = 0

/obj/structure/running_track
	name = "Running track"
	desc = "Running track. Peoples stands here, press some buttons on terminal's pad and just run."
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "running_track"
	anchored = 1
	var/obj/machinery/running_track_terminal/RTT
	var/obj/structure/running_track/main_machine
	var/working
	var/speed


/obj/structure/running_track/proc/moving()
	var/mob/user = locate()
	if(istype(src, /obj/structure/running_track/begin))
		speed = RTT.speed
	else
		speed = main_machine.speed
	if(main_machine.working)
		working = 1
	if(working)
		sleep(11 - speed * 10)
		if(user in src.loc.loc)
			user.Move(get_step(src, dir))
			if(istype(src, /obj/structure/running_track/end))
				if(speed > 4)
					user.Weaken(5)
	if(main_machine.speed < 1)
		working = 0
		speed = 0

/obj/structure/running_track/begin
	name = "Running track"
	desc = "Running track. Peoples stands here, press some buttons on terminal's pad and just run."
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "running_begin"

/obj/structure/running_track/end
	name = "Running track"
	desc = "Running track. Peoples stands here, press some buttons on terminal's pad and just run."
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "running_end"

//Eye of the tige-e-er!
//First: Later, i do it like item. Second: this is child of jukebox, but why not? - M962
//Rework this shit in future. But before, i do a 3d sound, yep.
/obj/machinery/media/jukebox/boombox
	name = "Boombox"
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "boombox"
	state_base = "boombox" //shit

	tracks = list(new/datum/track("Eye of the tiger", 'sound/music/eye_of_the_tiger.ogg'))

//Some turfs for sportroom here
/turf/simulated/floor/sport_turf_main
	icon = 'icons/obj/sportroom.dmi'
	icon_state = "sportroom_main"

/turf/simulated/floor/sport_turf_main/line_corner
	icon_state = "sportroom_line"

/turf/simulated/floor/sport_turf_main/line
	icon_state = "sportroom_line2"
