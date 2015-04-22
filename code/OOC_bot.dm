mob/OOC_bot
	var/speak_chance = 6
	var/BOT_NAME
	var/BOT_MESSAGE
	mouse_opacity = 0
	density = 0

mob/OOC_bot/Life()
	BOT_NAME = pick("Howard", "Pony", "Gergonus", "Jevan Vovan", "EbaEbatel", "Abraamich", "Moolhui")
	BOT_MESSAGE = pick("Ку, посаны", "Да", "Nyet", "Hi", "Привет", "Маслину поймал", "Мудак", "ГРАФОООН", "Nope", "Ну да", ":3", "В прошлом раунде заебись поиграли", "Отличный билд", "Хорошие игроки", "Заебись поиграли", "Plin HUI", "Индиго не нужно")
	if(speak_chance)
		if(rand(0,200) < speak_chance)
			world << "<span class='ooc'><span class='everyone'>" + create_text_tag("ooc", "OOC:") + " <EM>[BOT_NAME]:</EM> <span class='message'>[BOT_MESSAGE]</span></span></span>"