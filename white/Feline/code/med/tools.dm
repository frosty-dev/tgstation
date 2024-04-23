// 	Дыхательная груша
/obj/item/breathing_bag
	name = "дыхательная груша"
	desc = "Она же мешок Амбу — механическое ручное устройство для выполнения искусственной вентиляции лёгких."
	icon = 'white/Feline/icons/med_items.dmi'
	icon_state = "breathing_bag"
	lefthand_file = 'white/Feline/icons/clothing_lefthand.dmi'
	righthand_file = 'white/Feline/icons/clothing_righthand.dmi'
	inhand_icon_state = "m_mask"
	custom_materials = list(/datum/material/iron=5000, /datum/material/glass=2500)
	w_class = WEIGHT_CLASS_SMALL
	toolspeed = 1

/obj/item/breathing_bag/attack(mob/living/M, mob/user)
	if(M == user)
		return
	if (M.is_mouth_covered())
		to_chat(user, span_warning("Для произведения ИВЛ с пациента надо снять маску!"))
		return
	to_chat(user, span_notice("Прикладываю дыхательную маску к лицу [skloname(M.name, RODITELNI, M.gender)]."))
	if(!do_after(user, 30, user))
		to_chat(user, span_warning("Не получается!"))
		return
	. = ..()
	playsound(user,'white/Feline/sound/breathing_bag.ogg', 100, TRUE)
	for(var/ivl in 1 to 15)
		if(!do_after(user, 10, user))
			return
		to_chat(user, span_notice("Произвожу искуственную вентиляцию легких!"))
		M.adjustOxyLoss(-15)
