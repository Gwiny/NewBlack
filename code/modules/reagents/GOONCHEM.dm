#define REM 1


//------------------------------------------------------------------------------------------------------
								//GOON MEDICINE
//------------------------------------------------------------------------------------------------------


datum/reagent/medicine/silver_sulfadiazine
	name = "Silver Sulfadiazine"
	id = "silver_sulfadiazine"
	description = "On touch, quickly heals burn damage. Basic anti-burn healing drug. On ingestion, deals minor toxin damage."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 5 * REAGENTS_METABOLISM

datum/reagent/medicine/silver_sulfadiazine/reaction_mob(var/mob/living/M as mob, var/method=TOUCH, var/volume, var/show_message = 1)
	if(iscarbon(M))
		if(method == TOUCH)
			M.adjustFireLoss(-volume)
			if(show_message)
				M << "<span class='notice'>You feel your burns healing!</span>"
			M.emote("scream")
		if(method == INGEST)
			M.adjustToxLoss(0.5*volume)
			if(show_message)
				M << "<span class='notice'>You probably shouldn't have eaten that. Maybe you should of splashed it on, or applied a patch?</span>"
	..()
	return

datum/reagent/medicine/silver_sulfadiazine/on_mob_life(var/mob/living/M as mob)
	M.adjustFireLoss(-1*REM)
	..()
	return

datum/reagent/medicine/styptic_powder
	name = "Styptic Powder"
	id = "styptic_powder"
	description = "On touch, quickly heals brute damage. Basic anti-brute healing drug. On ingestion, deals minor toxin damage."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 5 * REAGENTS_METABOLISM

datum/reagent/medicine/styptic_powder/reaction_mob(var/mob/living/M as mob, var/method=TOUCH, var/volume, var/show_message = 1)
	if(iscarbon(M))
		if(method == TOUCH)
			M.adjustBruteLoss(-volume)
			if(show_message)
				M << "<span class='notice'>You feel your wounds knitting back together!</span>"
			M.emote("scream")
		if(method == INGEST)
			M.adjustToxLoss(0.5*volume)
			if(show_message)
				M << "<span class='notice'>You probably shouldn't have eaten that. Maybe you should of splashed it on, or applied a patch?</span>"
	..()
	return

datum/reagent/medicine/styptic_powder/on_mob_life(var/mob/living/M as mob)
	M.adjustBruteLoss(-2*REM)
	..()
	return

datum/reagent/medicine/salglu_solution
	name = "Saline-Glucose Solution"
	id = "salglu_solution"
	description = "Has a 33% chance per metabolism cycle to heal brute and burn damage."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

datum/reagent/medicine/salglu_solution/on_mob_life(var/mob/living/M as mob)
	if(prob(33))
		M.adjustBruteLoss(-0.5*REM)
		M.adjustFireLoss(-0.5*REM)
	..()
	return

datum/reagent/medicine/synthflesh
	name = "Synthflesh"
	id = "synthflesh"
	description = "Has a 100% chance of instantly healing brute and burn damage. One unit of the chemical will heal one point of damage. Touch application only."
	reagent_state = LIQUID
	color = "#C8A5DC"

datum/reagent/medicine/synthflesh/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume,var/show_message = 1)
	if(iscarbon(M))
		if(method == TOUCH)
			M.adjustBruteLoss(-1.5*volume)
			M.adjustFireLoss(-1.5*volume)
			if(show_message)
				M << "<span class='notice'>You feel your burns healing and your flesh knitting together!</span>"
	..()
	return

datum/reagent/medicine/charcoal
	name = "Charcoal"
	id = "charcoal"
	description = "Heals toxin damage, and will also slowly remove any other chemicals."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

datum/reagent/medicine/charcoal/on_mob_life(var/mob/living/M as mob)
	M.adjustToxLoss(-1.5*REM)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.id,0.5)
	..()
	return

datum/reagent/medicine/omnizine
	name = "Omnizine"
	id = "omnizine"
	description = "Heals 1 of each damage type a cycle. If overdosed it will deal significant amounts of each damage type."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30

datum/reagent/medicine/omnizine/on_mob_life(var/mob/living/M as mob)
	M.adjustToxLoss(-0.5*REM)
	M.adjustOxyLoss(-0.5*REM)
	M.adjustBruteLoss(-0.5*REM)
	M.adjustFireLoss(-0.5*REM)
	..()
	return

datum/reagent/medicine/omnizine/overdose_process(var/mob/living/M as mob)
	M.adjustToxLoss(1.5*REM)
	M.adjustOxyLoss(1.5*REM)
	M.adjustBruteLoss(1.5*REM)
	M.adjustFireLoss(1.5*REM)
	..()
	return

datum/reagent/medicine/calomel
	name = "Calomel"
	id = "calomel"
	description = "Quickly purges the body of all chemicals. If your health is above 20, toxin damage is dealt. When you hit 20 health or lower, the damage will cease."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

datum/reagent/medicine/calomel/on_mob_life(var/mob/living/M as mob)
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.id,2.5)
	if(M.health > 20)
		M.adjustToxLoss(2.5*REM)
	..()
	return

datum/reagent/medicine/potass_iodide
	name = "Potassium Iodide"
	id = "potass_iodide"
	description = "Reduces low radiation damage very effectively."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 2 * REAGENTS_METABOLISM

datum/reagent/medicine/potass_iodide/on_mob_life(var/mob/living/M as mob)
	if(M.radiation > 0)
		M.radiation--
	if(M.radiation < 0)
		M.radiation = 0
	..()
	return

datum/reagent/medicine/pen_acid
	name = "Pentetic Acid"
	id = "pen_acid"
	description = "Reduces massive amounts of radiation and toxin damage while purging other chemicals from the body. Has a chance of dealing brute damage."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

datum/reagent/medicine/pen_acid/on_mob_life(var/mob/living/M as mob)
	if(M.radiation > 0)
		M.radiation -= 4
	M.adjustToxLoss(-2*REM)
	if(prob(33))
		M.adjustBruteLoss(0.5*REM)
	if(M.radiation < 0)
		M.radiation = 0
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if(R != src)
			M.reagents.remove_reagent(R.id,2)
	..()
	return

datum/reagent/medicine/sal_acid
	name = "Salicyclic Acid"
	id = "sal_acid"
	description = "If you have less than 50 brute damage, it heals 0.25 unit. If overdosed it will deal 0.5 brute damage if the patient has less than 50 brute damage already."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 25

datum/reagent/medicine/sal_acid/on_mob_life(var/mob/living/M as mob)
	if(M.getBruteLoss() < 50)
		M.adjustBruteLoss(-0.25*REM)
	..()
	return

datum/reagent/medicine/sal_acid/overdose_process(var/mob/living/M as mob)
	if(M.getBruteLoss() < 50)
		M.adjustBruteLoss(0.5*REM)
	..()
	return

datum/reagent/medicine/salbutamol
	name = "Salbutamol"
	id = "salbutamol"
	description = "Quickly heals oxygen damage while slowing down suffocation. Great for stabilizing critical patients!"
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

datum/reagent/medicine/salbutamol/on_mob_life(var/mob/living/M as mob)
	M.adjustOxyLoss(-3*REM)
	if(M.losebreath >= 4)
		M.losebreath -= 2
	..()
	return

datum/reagent/medicine/perfluorodecalin
	name = "Perfluorodecalin"
	id = "perfluorodecalin"
	description = "Heals suffocation damage so quickly that you could have a spacewalk, but it mutes your voice. Has a 33% chance of healing brute and burn damage per cycle as well."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

datum/reagent/medicine/perfluorodecalin/on_mob_life(var/mob/living/carbon/human/M as mob)
	M.adjustOxyLoss(-12*REM)
	M.silent = max(M.silent, 5)
	if(prob(33))
		M.adjustBruteLoss(-0.5*REM)
		M.adjustFireLoss(-0.5*REM)
	..()
	return

datum/reagent/medicine/ephedrine
	name = "Ephedrine"
	id = "ephedrine"
	description = "Reduces stun times, increases run speed. If overdosed it will deal toxin and oxyloss damage."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 45
	addiction_threshold = 30

datum/reagent/medicine/ephedrine/on_mob_life(var/mob/living/M as mob)
	//M.status_flags |= IGNORESLOWDOWN
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	//M.adjustStaminaLoss(-1*REM)
	..()
	return

datum/reagent/medicine/ephedrine/overdose_process(var/mob/living/M as mob)
	if(prob(33))
		M.adjustToxLoss(0.5*REM)
		M.losebreath++
	..()
	return

datum/reagent/medicine/ephedrine/addiction_act_stage1(var/mob/living/M as mob)
	if(prob(33))
		M.adjustToxLoss(2*REM)
		M.losebreath += 2
	..()
	return
datum/reagent/medicine/ephedrine/addiction_act_stage2(var/mob/living/M as mob)
	if(prob(33))
		M.adjustToxLoss(3*REM)
		M.losebreath += 3
	..()
	return
datum/reagent/medicine/ephedrine/addiction_act_stage3(var/mob/living/M as mob)
	if(prob(33))
		M.adjustToxLoss(4*REM)
		M.losebreath += 4
	..()
	return
datum/reagent/medicine/ephedrine/addiction_act_stage4(var/mob/living/M as mob)
	if(prob(33))
		M.adjustToxLoss(5*REM)
		M.losebreath += 5
	..()
	return

datum/reagent/medicine/diphenhydramine
	name = "Diphenhydramine"
	id = "diphenhydramine"
	description = "Purges body of lethal Histamine and reduces jitteriness while causing minor drowsiness."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

datum/reagent/medicine/diphenhydramine/on_mob_life(var/mob/living/M as mob)
	if(prob(50))
		M.drowsyness += 1
	M.jitteriness -= 1
	M.reagents.remove_reagent("histamine",1.5)
	..()
	return

datum/reagent/medicine/morphine
	name = "Morphine"
	id = "morphine"
	description = "Will allow you to ignore slowdown from equipment and damage. Will eventually knock you out if you take too much. If overdosed it will cause jitteriness, dizziness, force the victim to drop items in their hands and eventually deal toxin damage."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30
	addiction_threshold = 25


datum/reagent/medicine/morphine/on_mob_life(var/mob/living/M as mob)
	//M.status_flags |= IGNORESLOWDOWN
	if(current_cycle >= 36)
		M.sleeping += 3
	..()
	return

datum/reagent/medicine/morphine/overdose_process(var/mob/living/M as mob)
	if(prob(33))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
		M.Dizzy(2)
		M.Jitter(2)
	..()
	return

datum/reagent/proc/overdose_process(var/mob/living/M as mob)
	return


datum/reagent/medicine/morphine/addiction_act_stage1(var/mob/living/M as mob)
	if(prob(33))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
		M.Dizzy(2)
		M.Jitter(2)
	..()
	return
datum/reagent/medicine/morphine/addiction_act_stage2(var/mob/living/M as mob)
	if(prob(33))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
		M.adjustToxLoss(1*REM)
		M.Dizzy(3)
		M.Jitter(3)
	..()
	return
datum/reagent/medicine/morphine/addiction_act_stage3(var/mob/living/M as mob)
	if(prob(33))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
		M.adjustToxLoss(2*REM)
		M.Dizzy(4)
		M.Jitter(4)
	..()
	return
datum/reagent/medicine/morphine/addiction_act_stage4(var/mob/living/M as mob)
	if(prob(33))
		var/obj/item/I = M.get_active_hand()
		if(I)
			M.drop_item()
		M.adjustToxLoss(3*REM)
		M.Dizzy(5)
		M.Jitter(5)
	..()
	return

datum/reagent/medicine/oculine
	name = "Oculine"
	id = "oculine"
	description = "Cures blindness and heals eye damage over time."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM

datum/reagent/medicine/oculine/on_mob_life(var/mob/living/M as mob)
	if(M.eye_blind > 0 && current_cycle > 20)
		if(prob(30))
			M.eye_blind = 0
		else if(prob(80))
			M.eye_blind = 0
			M.eye_blurry = 1
		if(M.eye_blurry > 0)
			if(prob(80))
				M.eye_blurry = 0
	..()
	return

datum/reagent/medicine/atropine
	name = "Atropine"
	id = "atropine"
	description = "If patients health is below -25 it will heal 1.5 brute and burn damage per cycle, as well as stop any oxyloss. Good for stabilising critical patients."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 35

datum/reagent/medicine/atropine/on_mob_life(var/mob/living/M as mob)
	if(M.health > -60)
		M.adjustToxLoss(0.5*REM)
	if(M.health < -25)
		M.adjustBruteLoss(-1.5*REM)
		M.adjustFireLoss(-1.5*REM)
	if(M.oxyloss > 65)
		M.setOxyLoss(65)
	if(M.losebreath > 5)
		M.losebreath = 5
	if(prob(20))
		M.Dizzy(5)
		M.Jitter(5)
	..()
	return

datum/reagent/medicine/atropine/overdose_process(var/mob/living/M as mob)
	M.adjustToxLoss(0.5*REM)
	M.Dizzy(1)
	M.Jitter(1)
	..()
	return

datum/reagent/medicine/epinephrine
	name = "Epinephrine"
	id = "epinephrine"
	description = "Reduces most of the knockout/stun effects, minor stamina regeneration buff. Attempts to stop you taking too much oxygen damage. If the patient is in low to severe crit, heals toxins, brute, and burn very effectively. Will not heal patients who are almost dead. If overdosed will stun and deal toxin damage"
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30

datum/reagent/medicine/epinephrine/on_mob_life(var/mob/living/M as mob)
	if(M.health < -10 && M.health > -65)
		M.adjustToxLoss(-0.5*REM)
		M.adjustBruteLoss(-0.5*REM)
		M.adjustFireLoss(-0.5*REM)
	if(M.oxyloss > 35)
		M.setOxyLoss(35)
	if(M.losebreath >= 4)
		M.losebreath -= 2
	if(M.losebreath < 0)
		M.losebreath = 0
	//M.adjustStaminaLoss(-0.5*REM)
	if(prob(20))
		M.AdjustParalysis(-1)
		M.AdjustStunned(-1)
		M.AdjustWeakened(-1)
	..()
	return

datum/reagent/medicine/epinephrine/overdose_process(var/mob/living/M as mob)
	if(prob(33))
		//M.adjustStaminaLoss(2.5*REM)
		M.adjustToxLoss(1*REM)
		M.losebreath++
	..()
	return

datum/reagent/medicine/strange_reagent
	name = "Strange Reagent"
	id = "strange_reagent"
	description = "A miracle drug that can bring a dead body back to life! If the corpse has suffered too much damage, however, no change will occur to the body. If used on a living person it will deal Brute and Burn damage."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/*
datum/reagent/medicine/strange_reagent/reaction_mob(var/mob/living/carbon/human/M as mob, var/method=TOUCH, var/volume)
	if(M.stat == DEAD)
		if(M.getBruteLoss() >= 100 || M.getFireLoss() >= 100)
			M.visible_message("<span class='warning'>[M]'s body convulses a bit, and then falls still once more.</span>")
			return
		var/mob/dead/observer/ghost = M.get_ghost()
		M.visible_message("<span class='warning'>[M]'s body convulses a bit.</span>")
		if(!M.suiciding && !(NOCLONE in M.mutations))
			if(ghost)
				ghost << "<span class='ghostalert'>Someone is trying to revive you. Return to your body if you want to be revived!</span> (Verbs -> Ghost -> Re-enter corpse)"
				//ghost << sound('sound/effects/genetics.ogg')
			else
				M.stat = 1
				M.adjustOxyLoss(-20)
				M.adjustToxLoss(-20)
				dead_mob_list -= M
				living_mob_list |= list(M)
				M.emote("gasp")
				add_logs(M, M, "revived", object="strange reagent")
	..()
	return

datum/reagent/medicine/strange_reagent/on_mob_life(var/mob/living/M as mob)
	M.adjustBruteLoss(0.5*REM)
	M.adjustFireLoss(0.5*REM)
	..()
	return


*/

/datum/reagent/medicine/mannitol
	name = "Mannitol"
	id = "mannitol"
	description = "Heals brain damage effectively. Use it in cyro tubes alongside Cryoxadone."
	color = "#C8A5DC"

/datum/reagent/medicine/mannitol/on_mob_life(mob/living/M as mob)
	M.adjustBrainLoss(-3*REM)
	..()
	return

/datum/reagent/medicine/mutadone
	name = "Mutadone"
	id = "mutadone"
	description = "Heals your genetic defects."
	color = "#C8A5DC"

//datum/reagent/medicine/mutadone/on_mob_life(var/mob/living/carbon/human/M as mob)
//	M.jitteriness = 0
//	if(istype(M) && M.dna)
	//	M.dna.remove_all_mutations()
//	..()
//	return
/*
datum/reagent/medicine/antihol
	name = "Antihol"
	id = "antihol"
	description = "Helps remove Alcohol from someone's body, as well as eliminating its side effects."
	color = "#C8A5DC"

datum/reagent/medicine/antihol/on_mob_life(var/mob/living/M as mob)
	M.dizziness = 0
	M.drowsyness = 0
	M.slurring = 0
	M.confused = 0
	M.reagents.remove_all_type(/datum/reagent/consumable/ethanol, 3*REM, 0, 1)
	M.adjustToxLoss(-0.2*REM)
	..()
*/

/datum/reagent/medicine/stimulants
	name = "Stimulants"
	id = "stimulants"
	description = "Increases run speed and eliminates stuns, can heal minor damage. If overdosed it will deal toxin damage and stun."
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 60

datum/reagent/medicine/stimulants/on_mob_life(var/mob/living/M as mob)
	//M.status_flags |= IGNORESLOWDOWN
	if(M.health < 50 && M.health > 0)
		M.adjustOxyLoss(-1*REM)
		M.adjustToxLoss(-1*REM)
		M.adjustBruteLoss(-1*REM)
		M.adjustFireLoss(-1*REM)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	//M.adjustStaminaLoss(-1.5*REM)
	..()

datum/reagent/medicine/stimulants/overdose_process(var/mob/living/M as mob)
	if(prob(33))
		//M.adjustStaminaLoss(2.5*REM)
		M.adjustToxLoss(1*REM)
		M.losebreath++
	..()
	return

datum/reagent/medicine/insulin
	name = "Insulin"
	id = "insulin"
	description = "Increases sugar depletion rates."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

datum/reagent/medicine/insulin/on_mob_life(var/mob/living/M as mob)
	if(M.sleeping)
		M.sleeping--
	M.reagents.remove_reagent("sugar", 3)
	..()
	return



// GOON OTHERS



datum/reagent/oil
	name = "Oil"
	id = "oil"
	description = "Burns in a small smoky fire, mostly used to get Ash."
	reagent_state = LIQUID
	color = "#C8A5DC"

datum/reagent/stable_plasma
	name = "Stable Plasma"
	id = "stable_plasma"
	description = "Non-flammable plasma locked into a liquid form that cannot ignite or become gaseous/solid."
	reagent_state = LIQUID
	color = "#C8A5DC"

datum/reagent/iodine
	name = "Iodine"
	id = "iodine"
	description = "A slippery solution."
	reagent_state = LIQUID
	color = "#C8A5DC"

datum/reagent/fluorine
	name = "Fluorine"
	id = "fluorine"
	description = "A slippery solution."
	reagent_state = LIQUID
	color = "#C8A5DC"

datum/reagent/carpet
	name = "Carpet"
	id = "carpet"
	description = "A slippery solution."
	reagent_state = LIQUID
	color = "#C8A5DC"

/datum/reagent/carpet/reaction_turf(var/turf/simulated/T, var/volume)
	if(istype(T, /turf/simulated/floor/plating))
		var/turf/simulated/floor/F = T
		F.ChangeTurf(/turf/simulated/floor/carpet)
	..()
	return

datum/reagent/bromine
	name = "Bromine"
	id = "bromine"
	description = "A slippery solution."
	reagent_state = LIQUID
	color = "#C8A5DC"

datum/reagent/phenol
	name = "Phenol"
	id = "phenol"
	description = "Used for certain medical recipes."
	reagent_state = LIQUID
	color = "#C8A5DC"

datum/reagent/ash
	name = "Ash"
	id = "ash"
	description = "Basic ingredient in a couple of recipes."
	reagent_state = LIQUID
	color = "#C8A5DC"

datum/reagent/acetone
	name = "Acetone"
	id = "acetone"
	description = "Common ingredient in other recipes."
	reagent_state = LIQUID
	color = "#C8A5DC"

datum/reagent/colorful_reagent
	name = "Colorful Reagent"
	id = "colorful_reagent"
	description = "A solution."
	reagent_state = LIQUID
	color = "#C8A5DC"
	var/list/random_color_list = list("#00aedb","#a200ff","#f47835","#d41243","#d11141","#00b159","#00aedb","#f37735","#ffc425","#008744","#0057e7","#d62d20","#ffa700")


datum/reagent/colorful_reagent/on_mob_life(var/mob/living/M as mob)
	if(M && isliving(M))
		M.color = pick(random_color_list)
	..()
	return

datum/reagent/colorful_reagent/reaction_mob(var/mob/living/M, var/volume)
	if(M && isliving(M))
		M.color = pick(random_color_list)
	..()
	return
datum/reagent/colorful_reagent/reaction_obj(var/obj/O, var/volume)
	if(O)
		O.color = pick(random_color_list)
	..()
	return
datum/reagent/colorful_reagent/reaction_turf(var/turf/T, var/volume)
	if(T)
		T.color = pick(random_color_list)
	..()
	return

/*
datum/reagent/hair_dye
	name = "Quantum Hair Dye"
	id = "hair_dye"
	description = "A solution."
	reagent_state = LIQUID
	color = "#C8A5DC"
	var/list/potential_colors = list("0ad","a0f","f73","d14","d14","0b5","0ad","f73","fc2","084","05e","d22","fa0") // fucking hair code

datum/reagent/hair_dye/reaction_mob(var/mob/living/M, var/volume)
	if(M && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.hair_color = pick(potential_colors)
		H.facial_hair_color = pick(potential_colors)
		H.update_hair()
	..()
	return

datum/reagent/barbers_aid
	name = "Barber's Aid"
	id = "barbers_aid"
	description = "A solution to hair loss across the world."
	reagent_state = LIQUID
	color = "#C8A5DC"

datum/reagent/barbers_aid/reaction_mob(var/mob/living/M, var/volume)
	if(M && ishuman(M))
		var/mob/living/carbon/human/H = M
		var/datum/sprite_accessory/hair/picked_hair = pick(hair_styles_list)
		var/datum/sprite_accessory/facial_hair/picked_beard = pick(facial_hair_styles_list)
		H.hair_style = picked_hair
		H.facial_hair_style = picked_beard
		H.update_hair()
	..()
	return

datum/reagent/concentrated_barbers_aid
	name = "Concentrated Barber's Aid"
	id = "concentrated_barbers_aid"
	description = "A concentrated solution to hair loss across the world."
	reagent_state = LIQUID
	color = "#C8A5DC"

datum/reagent/concentrated_barbers_aid/reaction_mob(var/mob/living/M, var/volume)
	if(M && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.hair_style = "Very Long Hair"
		H.facial_hair_style = "Very Long Beard"
		H.update_hair()
	..()
	return

/datum/reagent/saltpetre
	name = "Saltpetre"
	id = "saltpetre"
	description = "Volatile."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132

*/

//////////////////////////////////// Other goon stuff ///////////////////////////////////////////

/datum/chemical_reaction/acetone
	name = "acetone"
	id = "acetone"
	result = "acetone"
	required_reagents = list("oil" = 1, "fuel" = 1, "oxygen" = 1)
	result_amount = 3

/datum/chemical_reaction/carpet
	name = "carpet"
	id = "carpet"
	result = "carpet"
	required_reagents = list("space_drugs" = 1, "blood" = 1)
	result_amount = 2


/datum/chemical_reaction/oil
	name = "Oil"
	id = "oil"
	result = "oil"
	required_reagents = list("fuel" = 1, "carbon" = 1, "hydrogen" = 1)
	result_amount = 3

/datum/chemical_reaction/phenol
	name = "phenol"
	id = "phenol"
	result = "phenol"
	required_reagents = list("water" = 1, "chlorine" = 1, "oil" = 1)
	result_amount = 3

/datum/chemical_reaction/ash
	name = "Ash"
	id = "ash"
	result = "ash"
	required_reagents = list("oil" = 1)
	result_amount = 1
	required_temp = 480

/datum/chemical_reaction/colorful_reagent
	name = "colorful_reagent"
	id = "colorful_reagent"
	result = "colorful_reagent"
	required_reagents = list("stable_plasma" = 1, "radium" = 1, "space_drugs" = 1, "cryoxadone" = 1, "triple_citrus" = 1)
	result_amount = 5

/datum/chemical_reaction/life
	name = "Life"
	id = "life"
	result = null
	required_reagents = list("strange_reagent" = 1, "synthflesh" = 1, "blood" = 1)
	result_amount = 1
	required_temp = 374

datum/reagent/proc/addiction_act_stage1(var/mob/living/M as mob)
	if(prob(30))
		M << "<span class = 'notice'>You feel like some [name] right about now.</span>"
	return

datum/reagent/proc/addiction_act_stage2(var/mob/living/M as mob)
	if(prob(30))
		M << "<span class = 'notice'>You feel like you need [name]. You just can't get enough.</span>"
	return

datum/reagent/proc/addiction_act_stage3(var/mob/living/M as mob)
	if(prob(30))
		M << "<span class = 'danger'>You have an intense craving for [name].</span>"
	return

datum/reagent/proc/addiction_act_stage4(var/mob/living/M as mob)
	if(prob(30))
		M << "<span class = 'boldannounce'>You're not feeling good at all! You really need some [name].</span>"
	return



//datum/chemical_reaction/life/on_reaction(var/datum/reagents/holder, var/created_volume)
	//chemical_mob_spawn(holder, 1, "Life")

/datum/chemical_reaction/corgium
	name = "corgium"
	id = "corgium"
	result = null
	required_reagents = list("nutriment" = 1, "colorful_reagent" = 1, "strange_reagent" = 1, "blood" = 1)
	result_amount = 1
	required_temp = 374

/datum/chemical_reaction/hair_dye
	name = "hair_dye"
	id = "hair_dye"
	result = "hair_dye"
	required_reagents = list("colorful_reagent" = 1, "radium" = 1, "space_drugs" = 1)
	result_amount = 5

/datum/chemical_reaction/barbers_aid
	name = "barbers_aid"
	id = "barbers_aid"
	result = "barbers_aid"
	required_reagents = list("carpet" = 1, "radium" = 1, "space_drugs" = 1)
	result_amount = 5

/datum/chemical_reaction/concentrated_barbers_aid
	name = "concentrated_barbers_aid"
	id = "concentrated_barbers_aid"
	result = "concentrated_barbers_aid"
	required_reagents = list("barbers_aid" = 1, "mutagen" = 1)
	result_amount = 2

/datum/chemical_reaction/saltpetre
	name = "saltpetre"
	id = "saltpetre"
	result = "saltpetre"
	required_reagents = list("potassium" = 1, "nitrogen" = 1, "oxygen" = 3)
	result_amount = 3


// GOON PYROTECH //////////////////////////////////////////////////////////////////////

/datum/chemical_reaction/sorium
	name = "Sorium"
	id = "sorium"
	result = "sorium"
	required_reagents = list("mercury" = 1, "oxygen" = 1, "nitrogen" = 1, "carbon" = 1)
	result_amount = 4

/datum/chemical_reaction/sorium/on_reaction(var/datum/reagents/holder, var/created_volume)
	if(holder.has_reagent("stabilizing_agent"))
		return
	holder.remove_reagent("sorium", created_volume)
	var/turf/simulated/T = get_turf(holder.my_atom)
	goonchem_vortex(T, 1, 5, 6)

/datum/chemical_reaction/sorium_vortex
	name = "sorium_vortex"
	id = "sorium_vortex"
	result = null
	required_reagents = list("sorium" = 1)
	required_temp = 474

/datum/chemical_reaction/sorium_vortex/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/simulated/T = get_turf(holder.my_atom)
	goonchem_vortex(T, 1, 5, 6)


/datum/chemical_reaction/liquid_dark_matter
	name = "Liquid Dark Matter"
	id = "liquid_dark_matter"
	result = "liquid_dark_matter"
	required_reagents = list("stable_plasma" = 1, "radium" = 1, "carbon" = 1)
	result_amount = 3

/datum/chemical_reaction/liquid_dark_matter/on_reaction(var/datum/reagents/holder, var/created_volume)
	if(holder.has_reagent("stabilizing_agent"))
		return
	holder.remove_reagent("liquid_dark_matter", created_volume)
	var/turf/simulated/T = get_turf(holder.my_atom)
	goonchem_vortex(T, 0, 5, 6)


/datum/chemical_reaction/ldm_vortex
	name = "LDM Vortex"
	id = "ldm_vortex"
	result = null
	required_reagents = list("liquid_dark_matter" = 1)
	required_temp = 474

/datum/chemical_reaction/ldm_vortex/on_reaction(var/datum/reagents/holder, var/created_volume)
	var/turf/simulated/T = get_turf(holder.my_atom)
	goonchem_vortex(T, 0, 5, 6)