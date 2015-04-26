obj/item/weapon/pool
	icon='icons/obj/structures.dmi'


///pool

obj/item/weapon/pool/ball1
	name="poolball"
	icon_state="1"
	throwforce = 12

obj/item/weapon/pool/ball2
	name="poolball"
	icon_state="1"
	throwforce = 12

obj/item/weapon/pool/ball3
	name="poolball"
	icon_state="2"
	throwforce = 12

obj/item/weapon/pool/ball4
	name="poolball"
	icon_state="3"
	throwforce = 12

obj/item/weapon/pool/ball5
	name="poolball"
	icon_state="4"
	throwforce = 12

obj/item/weapon/pool/ball6
	name="poolball"
	icon_state="5"
	throwforce = 12

obj/item/weapon/pool/ball7
	name="poolball"
	icon_state="7"
	throwforce = 12

obj/item/weapon/pool/ball8
	name="poolball"
	icon_state="8"
	throwforce = 12

obj/item/weapon/pool/cue
	name="cue"
	icon_state="Cue"
	force = 12
	//throwforce = 12

obj/item/weapon/pool/rack
	name="rack"
	icon_state="Rack"
	//throwforce = 12


/obj/item/weapon/dice
	name = "d6"
	desc = "A dice with six sides."
	icon = 'icons/obj/dice.dmi'
	icon_state = "d66"
	w_class = 1
	var/sides = 6
	attack_verb = list("diced")

/obj/item/weapon/dice/New()
	icon_state = "[name][rand(1,sides)]"

/obj/item/weapon/dice/d20
	name = "d20"
	desc = "A dice with twenty sides."
	icon_state = "d2020"
	sides = 20

/obj/item/weapon/dice/attack_self(mob/user as mob)
	var/result = rand(1, sides)
	var/comment = ""
	if(sides == 20 && result == 20)
		comment = "Nat 20!"
	else if(sides == 20 && result == 1)
		comment = "Ouch, bad luck."
	icon_state = "[name][result]"
	user.visible_message("<span class='notice'>[user] has thrown [src]. It lands on [result]. [comment]</span>", \
						 "<span class='notice'>You throw [src]. It lands on a [result]. [comment]</span>", \
						 "<span class='notice'>You hear [src] landing on a [result]. [comment]</span>")
