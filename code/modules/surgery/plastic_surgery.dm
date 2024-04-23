/// Disk containing info for doing advanced plastic surgery. Spawns in maint and available as a role-restricted item in traitor uplinks.
/obj/item/disk/surgery/advanced_plastic_surgery
	name = "Advanced Plastic Surgery Disk"
	desc = "The disk provides instructions on how to do an Advanced Plastic Surgery, this surgery allows one-self to completely remake someone's face with that of another. Provided they have a picture of them in their offhand when reshaping the face. With the surgery long becoming obsolete with the rise of genetics technology. This item became an antique to many collectors, With only the cheaper and easier basic form of plastic surgery remaining in use in most places."
	surgeries = list(/datum/surgery/plastic_surgery/advanced)

/datum/surgery/plastic_surgery
	name = "Пластическая хирургия"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB | SURGERY_MORBID_CURIOSITY
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/reshape_face,
		/datum/surgery_step/close,
	)

/datum/surgery/plastic_surgery/advanced
	name = "advanced plastic surgery"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/insert_plastic,
		/datum/surgery_step/reshape_face,
		/datum/surgery_step/close,
	)

//Insert plastic step, It ain't called plastic surgery for nothing! :)
/datum/surgery_step/insert_plastic
	name = "insert plastic (plastic)"
	implements = list(
		/obj/item/stack/sheet/plastic = 100,
		/obj/item/stack/sheet/meat = 100)
	time = 3.2 SECONDS
	preop_sound = 'sound/effects/blobattack.ogg'
	success_sound = 'sound/effects/attackblob.ogg'
	failure_sound = 'sound/effects/blobattack.ogg'

/datum/surgery_step/insert_plastic/preop(mob/user, mob/living/target, target_zone, obj/item/stack/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You begin to insert [tool] into the incision in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to insert [tool] into the incision in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] begins to insert [tool] into the incision in [target]'s [parse_zone(target_zone)]."),
	)
	display_pain(target, "You feel something inserting just below the skin in your [parse_zone(target_zone)].")

/datum/surgery_step/insert_plastic/success(mob/user, mob/living/target, target_zone, obj/item/stack/tool, datum/surgery/surgery, default_display_results)
	. = ..()
	tool.use(1)

//reshape_face
/datum/surgery_step/reshape_face
	name = "изменить лицо (скальпель)"
	implements = list(
		TOOL_SCALPEL = 100,
		/obj/item/knife = 50,
		TOOL_WIRECUTTER = 35)
	time = 64

/datum/surgery_step/reshape_face/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message(span_notice("[user] начинает менять внешность [skloname(target.name, RODITELNI, target.gender)].") , span_notice("Начинаю менять внешность [skloname(target.name, RODITELNI, target.gender)]..."))
	display_results(user, target, span_notice("Начинаю менять внешность [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает менять внешность [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] делает надрез на лице [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Лицо горит от множественных порезов!")

/datum/surgery_step/reshape_face/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(HAS_TRAIT_FROM(target, TRAIT_DISFIGURED, TRAIT_GENERIC))
		REMOVE_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)
		display_results(user, target, span_notice("Успешно изменил внешность [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] успешно изменил внешность [skloname(target.name, RODITELNI, target.gender)]!") ,
			span_notice("[user] завершил операцию на лице [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "Все лицо щиплет!")
	else
		var/list/names = list()
		if(!isabductor(user))
			var/obj/item/offhand = user.get_inactive_held_item()
			if(istype(offhand, /obj/item/photo) && istype(surgery, /datum/surgery/plastic_surgery/advanced))
				var/obj/item/photo/disguises = offhand
				for(var/namelist as anything in disguises.picture?.names_seen)
					names += namelist
			else
				user.visible_message(span_warning("You have no picture to base the appearance on, reverting to random appearances."))
				for(var/i in 1 to 10)
					names += target.dna.species.random_name(target.gender, TRUE)
		else
			for(var/_i in 1 to 9)
				names += "Субъект [target.gender == MALE ? "i" : "o"]-[pick("a", "b", "c", "d", "e")]-[rand(10000, 99999)]"
			names += target.dna.species.random_name(target.gender, TRUE) //give one normal name in case they want to do regular plastic surgery
		var/chosen_name = tgui_input_list(user, "Выберите новое имя.", "Plastic Surgery", names)
		if(isnull(chosen_name))
			return
		var/oldname = target.real_name
		target.real_name = chosen_name
		var/newname = target.real_name //something about how the code handles names required that I use this instead of target.real_name
		display_results(user, target, span_notice("Лицо [oldname] полностью изменено, и [target.ru_who()] новое имя [newname].") ,
			span_notice("[user] изменяет внешность [oldname], и [target.ru_who()] новое имя [newname]!") ,
			span_notice("[user] завершает операцию на лице [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "Я сегодня не такой как вчера!")
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		human_target.sec_hud_set_ID()
	if(HAS_MIND_TRAIT(user, TRAIT_MORBID) && ishuman(user))
		var/mob/living/carbon/human/morbid_weirdo = user
		morbid_weirdo.add_mood_event("morbid_abominable_surgery_success", /datum/mood_event/morbid_abominable_surgery_success)
	return ..()

/datum/surgery_step/reshape_face/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_warning("[gvorno(TRUE)], но я облажался, изуродовав внешность [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] облажался, изуродовав внешность [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] завершил операцию на лице [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Мое лицо! Мое прекрастное лицо! Оно обезображено!")
	ADD_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)
	return FALSE
