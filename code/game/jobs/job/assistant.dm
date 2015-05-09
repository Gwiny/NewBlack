/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	alt_titles = list("Technical Assistant","Medical Intern","Research Assistant","Security Cadet","Visitor")

/datum/job/assistant/equip(var/mob/living/carbon/human/H)
<<<<<<< HEAD
//	if(!H)	return 0
	//	HEAD (MACLEOD, EROR!)
	if(!slot_w_uniform)
		var/obj/item/rand_under = pick(random_under)
		H.equip_to_slot_or_del(new rand_under(H), slot_w_uniform)
=======
	if(!H)	return 0
<<<<<<< HEAD
	if(!slot_w_uniform)
		var/obj/item/rand_under = pick(random_under)
		H.equip_to_slot_or_del(new rand_under(H), slot_w_uniform)
=======
>>>>>>> 17db324c8b74cadd548477e2501ee5f3f8bbbff7
	if(H.ckey == "ssting")
		H.equip_to_slot_or_del(new /obj/item/clothing/head/fluff/bruce_hachert(H), slot_head)
	if(H.ckey == "ravager966")
		H.equip_to_slot_or_del(new /obj/item/clothing/under/psyche(H), slot_w_uniform)
	if(H.ckey == "perfectian")
		H.equip_to_slot_or_del(new /obj/item/weapon/deck/PERFECTIAN(H), slot_l_hand)
	//H.equip_to_slot_or_del(new /obj/item/clothing/under/color/grey(H), slot_w_uniform)
<<<<<<< HEAD
//>>>>>>> 595f624f9fe06d553e2d0e2ebed957d29d779038
=======
>>>>>>> 595f624f9fe06d553e2d0e2ebed957d29d779038
>>>>>>> 17db324c8b74cadd548477e2501ee5f3f8bbbff7
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
	return 1

/datum/job/assistant/get_access()
	if(config.assistant_maint)
		return list(access_maint_tunnels)
	else
		return list()
