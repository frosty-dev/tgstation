/datum/surgery/lipoplasty
	name = "Липопластика"
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/cut_fat,
		/datum/surgery_step/remove_fat,
		/datum/surgery_step/close,
	)

/datum/surgery/lipoplasty/can_start(mob/user, mob/living/carbon/target)
	if(HAS_TRAIT(target, TRAIT_FAT) && target.nutrition >= NUTRITION_LEVEL_WELL_FED)
		return TRUE
	return FALSE


//cut fat
/datum/surgery_step/cut_fat
	name = "отрежьте лишний жир (пила)"
	implements = list(
		TOOL_SAW = 100,
		/obj/item/shovel/serrated = 75,
		/obj/item/hatchet = 35,
		/obj/item/knife/butcher = 25)
	time = 64

/datum/surgery_step/cut_fat/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	user.visible_message(span_notice("[user] начинает отрезать лишний жир у [skloname(target.name, RODITELNI, target.gender)].") , span_notice("Вы начинаете отрезать лишний жир у [skloname(target.name, RODITELNI, target.gender)]..."))
	display_results(user, target, span_notice("Начинаю отрезать лишний жир у [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает отрезать лишний жир у [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] начинает отрезать лишний жир в [target_zone] у [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]."))
	display_pain(target, "Ой-ой! Щекотно!")

/datum/surgery_step/cut_fat/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	display_results(user, target, span_notice("Отрезаю лишний жир у [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] отрезал[user.ru_a()] лишний жир у [skloname(target.name, RODITELNI, target.gender)]!") ,
			span_notice("[user] отрезал[user.ru_a()] лишний жир у [skloname(target.name, RODITELNI, target.gender)]."))
	display_pain(target, "Такое ощущение что у меня живот потек!")
	return TRUE

//remove fat
/datum/surgery_step/remove_fat
	name = "извлеките лишний жир (расширитель)"
	implements = list(
		TOOL_RETRACTOR = 100,
		TOOL_SCREWDRIVER = 45,
		TOOL_WIRECUTTER = 35)
	time = 32

/datum/surgery_step/remove_fat/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target, span_notice("Начинаю извлекать лишний жир из [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает извлекать лишний жир из [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] начинает извлекать лишний жир из [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/remove_fat/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(user, target, span_notice("Вы извлекли лишний жир из [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] извлекает лишний жир из [skloname(target.name, RODITELNI, target.gender)]!") ,
			span_notice("[user] извлекает лишний жир из [skloname(target.name, RODITELNI, target.gender)]!"))
	display_pain(target, "Чувствую себя намного более спортивным!")
	target.overeatduration = 0 //patient is unfatted
	var/removednutriment = target.nutrition
	target.set_nutrition(NUTRITION_LEVEL_WELL_FED)
	removednutriment -= NUTRITION_LEVEL_WELL_FED //whatever was removed goes into the meat
	var/mob/living/carbon/human/human = target
	var/typeofmeat = /obj/item/food/meat/slab/human

	if(human.dna && human.dna.species)
		typeofmeat = human.dna.species.meat

	var/obj/item/food/meat/slab/human/newmeat = new typeofmeat
	newmeat.name = "жирное мясо"
	newmeat.desc = "Очень жирное мясо прямиком из разделочной."
	newmeat.subjectname = human.real_name
	newmeat.subjectjob = human.job
	newmeat.reagents.add_reagent (/datum/reagent/consumable/nutriment, (removednutriment / 15)) //To balance with nutriment_factor of nutriment
	newmeat.forceMove(target.loc)
	return ..()
