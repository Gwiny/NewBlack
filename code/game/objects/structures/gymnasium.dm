//Sportroom for New Black by M962
//Gift from the Syndicate station 13
//And yes, all items of sportroom in one file. Not so great feature.

//VERSION 0.2//
//What we have for now//
/*
	1. Horizontal rod
	2. Sport bed with weight rod
	3. Some turfs
	4. Boombox
	5. Transpiration
	6. Unfinished boxing bag
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
	var/forcing

/obj/structure/boxing_bag/attack_hand(var/mob/living/user)
	user.visible_message("[user] beats the [src]!",	\
				"\blue you attack this [src]!")
	forcing += 4
	if(forcing > 8)
		forcing = 8
	while(forcing > 0)
		if(forcing < 1 && forcing > 0)
			forcing = 0
		if(forcing)
			var/turn_out = round(forcing/2)
			for(forcing, forcing > 0, forcing--)
				sleep(1)
				src.icon = turn(src.icon, 5)
			forcing = round(turn_out/2)
			for(turn_out, turn_out > 0, turn_out--)
				sleep(1)
				src.icon = turn(src.icon, -5)
	src.icon = turn(src.icon, 0)
	return


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