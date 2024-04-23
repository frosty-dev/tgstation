/datum/surgery/healing
	target_mobtypes = list(/mob/living)
	requires_bodypart_type = NONE
	replaced_by = /datum/surgery
	surgery_flags = SURGERY_IGNORE_CLOTHES | SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/heal,
		/datum/surgery_step/close,
	)

	var/healing_step_type
	var/antispam = FALSE

/datum/surgery/healing/can_start(mob/user, mob/living/patient)
	. = ..()
	if(!(patient.mob_biotypes & (MOB_ORGANIC|MOB_HUMANOID)))
		return FALSE

/datum/surgery/healing/New(surgery_target, surgery_location, surgery_bodypart)
	..()
	if(healing_step_type)
		steps = list(
			/datum/surgery_step/incise/nobleed,
			healing_step_type, //hehe cheeky
			/datum/surgery_step/close)

/datum/surgery_step/heal
	name = "восстановить тело (зажим)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCREWDRIVER = 65,
		/obj/item/pen = 55)
	repeatable = TRUE
	time = 25
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
	var/brutehealing = 0
	var/burnhealing = 0
	var/brute_multiplier = 0 //multiplies the damage that the patient has. if 0 the patient wont get any additional healing from the damage he has.
	var/burn_multiplier = 0

/// Returns a string letting the surgeon know roughly how much longer the surgery is estimated to take at the going rate
/datum/surgery_step/heal/proc/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	return

/datum/surgery_step/heal/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/woundtype
	if(brutehealing && burnhealing)
		woundtype = "раны"
	else if(brutehealing)
		woundtype = "синяки"
	else //why are you trying to 0,0...?
		woundtype = "ожоги"
	if(istype(surgery,/datum/surgery/healing))
		var/datum/surgery/healing/the_surgery = surgery
		if(!the_surgery.antispam)
			display_results(user, target, span_notice("Пытаюсь залатать [woundtype] [skloname(target.name, RODITELNI, target.gender)].") ,
				span_notice("[user] пытается залатать [woundtype] [skloname(target.name, RODITELNI, target.gender)].") ,
				span_notice("[user] пытается залатать [woundtype] [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/heal/initiate(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	if(!..())
		return
	while((brutehealing && target.getBruteLoss()) || (burnhealing && target.getFireLoss()))
		if(!..())
			break

/datum/surgery_step/heal/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/user_msg = "Успешно залатываю некоторые раны [skloname(target.name, RODITELNI, target.gender)]" //no period, add initial space to "addons"
	var/target_msg = "[user] залатывает некоторые раны [skloname(target.name, RODITELNI, target.gender)]" //see above
	var/brute_healed = brutehealing
	var/burn_healed = burnhealing
	var/dead_patient = FALSE
	if(target.stat == DEAD) //dead patients get way less additional heal from the damage they have.
		brute_healed += round((target.getBruteLoss() * (brute_multiplier * 0.2)),0.1)
		burn_healed += round((target.getFireLoss() * (burn_multiplier * 0.2)),0.1)
		dead_patient = TRUE
	else
		brute_healed += round((target.getBruteLoss() * brute_multiplier),0.1)
		burn_healed += round((target.getFireLoss() * burn_multiplier),0.1)
		dead_patient = FALSE
	if(!get_location_accessible(target, target_zone))
		brute_healed *= 0.55
		burn_healed *= 0.55
		user_msg += " настолько хорошо, насколько может из-за мешающейся одежды."
		target_msg += " настолько хорошо, насколько может из-за мешающейся одежды."
	target.heal_bodypart_damage(brute_healed,burn_healed)

	user_msg += get_progress(user, target, brute_healed, burn_healed)

	if(HAS_MIND_TRAIT(user, TRAIT_MORBID) && ishuman(user) && !dead_patient) //Morbid folk don't care about tending the dead as much as tending the living
		var/mob/living/carbon/human/morbid_weirdo = user
		morbid_weirdo.add_mood_event("morbid_tend_wounds", /datum/mood_event/morbid_tend_wounds)

	display_results(
		user,
		target,
		span_notice("[user_msg]."),
		span_notice("[target_msg]."),
		span_notice("[target_msg]."),
	)
	if(istype(surgery, /datum/surgery/healing))
		var/datum/surgery/healing/the_surgery = surgery
		the_surgery.antispam = TRUE
	return ..()

/datum/surgery_step/heal/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_warning("[gvorno(TRUE)], но я облажался!"),
		span_warning("[user] облажался!") ,
		span_notice("[user] залатывает некоторые раны [skloname(target.name, RODITELNI, target.gender)]."),
		target_detailed = TRUE,
	)
	var/brute_dealt = brutehealing * 0.8
	var/burn_dealt = burnhealing * 0.8
	brute_dealt += round((target.getBruteLoss() * (brute_multiplier * 0.5)),0.1)
	burn_dealt += round((target.getFireLoss() * (burn_multiplier * 0.5)),0.1)
	target.take_bodypart_damage(brute_dealt, burn_dealt, wound_bonus=CANT_WOUND)
	return FALSE

/***************************BRUTE***************************/
/datum/surgery/healing/brute
	name = "Лечение ран (Ушибов)"

/datum/surgery/healing/brute/basic
	name = "Лечение ран (Ушибов, Базовое)"
	desc = "Хирургическая операция которая оказывает базовую медицинскую помощь при физических ранах. Лечение немного более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/brute/upgraded
	healing_step_type = /datum/surgery_step/heal/brute/basic

/datum/surgery/healing/brute/upgraded
	name = "Лечение ран (Ушибов, Продвинутое)"
	desc = "Хирургическая операция которая оказывает продвинутую медицинскую помощь при физических ранах. Лечение более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/brute/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/brute/upgraded
	desc = "A surgical procedure that provides advanced treatment for a patient's brute traumas. Heals more when the patient is severely injured."

/datum/surgery/healing/brute/upgraded/femto
	name = "Лечение ран (Ушибов, Экспертное)"
	desc = "Хирургическая операция которая оказывает экспертную медицинскую помощь при физических ранах. Лечение намного более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/brute/upgraded/femto
	desc = "A surgical procedure that provides experimental treatment for a patient's brute traumas. Heals considerably more when the patient is severely injured."

/********************BRUTE STEPS********************/
/datum/surgery_step/heal/brute/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	return

/datum/surgery_step/heal/brute/basic
	name = "лечение ран (зажим)"
	brutehealing = 5
	brute_multiplier = 0.07

/datum/surgery_step/heal/brute/upgraded
	brutehealing = 5
	brute_multiplier = 0.1

/datum/surgery_step/heal/brute/upgraded/femto
	brutehealing = 5
	brute_multiplier = 0.2

/***************************BURN***************************/
/datum/surgery/healing/burn
	name = "Лечение ран (Ожогов)"

/datum/surgery/healing/burn/basic
	name = "Лечение ран (Ожогов, Базовое)"
	desc = "Хирургическая операция которая оказывает базовую медицинскую помощь при ожоговых ранах. Лечение немного более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/burn/upgraded
	healing_step_type = /datum/surgery_step/heal/burn/basic

/datum/surgery/healing/burn/upgraded
	name = "Лечение ран (Ожогов, Продвинутое)"
	desc = "Хирургическая операция которая оказывает продвинутую медицинскую помощь при ожоговых ранах. Лечение более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/burn/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/burn/upgraded

/datum/surgery/healing/burn/upgraded/femto
	name = "Лечение ран (Ожогов, Экспертное)"
	desc = "Хирургическая операция которая оказывает экспертную медицинскую помощь при ожоговых ранах. Лечение намного более эффективно при серьезных травмах."
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/burn/upgraded/femto

/********************BURN STEPS********************/
/datum/surgery_step/heal/burn/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	return

/datum/surgery_step/heal/burn/basic
	name = "лечение ожогов (зажим)"
	burnhealing = 5
	burn_multiplier = 0.07

/datum/surgery_step/heal/burn/upgraded
	burnhealing = 5
	burn_multiplier = 0.1

/datum/surgery_step/heal/burn/upgraded/femto
	burnhealing = 5
	burn_multiplier = 0.2

/***************************COMBO***************************/
/datum/surgery/healing/combo


/datum/surgery/healing/combo
	name = "Лечение ран (Смешанных, Основное)"
	replaced_by = /datum/surgery/healing/combo/upgraded
	requires_tech = TRUE
	healing_step_type = /datum/surgery_step/heal/combo
	desc = "Хирургическая операция которая оказывает базовую медицинскую помощь при смешанных физических и ожоговых ранах. Лечение немного более эффективно при серьезных травмах."

/datum/surgery/healing/combo/upgraded
	name = "Лечение ран (Смешанных, Продвинутое)"
	replaced_by = /datum/surgery/healing/combo/upgraded/femto
	healing_step_type = /datum/surgery_step/heal/combo/upgraded
	desc = "Хирургическая операция которая оказывает продвинутую медицинскую помощь при смешанных физических и ожоговых ранах. Лечение более эффективно при серьезных травмах."


/datum/surgery/healing/combo/upgraded/femto //no real reason to type it like this except consistency, don't worry you're not missing anything
	name = "Лечение ран (Смешанных, Экспертное)"
	replaced_by = null
	healing_step_type = /datum/surgery_step/heal/combo/upgraded/femto
	desc = "Хирургическая операция которая оказывает экспертную медицинскую помощь при смешанных физических и ожоговых ранах. Лечение намного более эффективно при серьезных травмах."

/********************COMBO STEPS********************/
/datum/surgery_step/heal/combo/get_progress(mob/user, mob/living/carbon/target, brute_healed, burn_healed)
	return

/datum/surgery_step/heal/combo
	name = "лечение физических травм"
	brutehealing = 3
	burnhealing = 3
	brute_multiplier = 0.07
	burn_multiplier = 0.07
	time = 10

/datum/surgery_step/heal/combo/upgraded
	brutehealing = 3
	burnhealing = 3
	brute_multiplier = 0.1
	burn_multiplier = 0.1

/datum/surgery_step/heal/combo/upgraded/femto
	brutehealing = 1
	burnhealing = 1
	brute_multiplier = 0.4
	burn_multiplier = 0.4

/datum/surgery_step/heal/combo/upgraded/femto/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_warning("[gvorno(TRUE)], но я облажался!"),
		span_warning("[user] облажался!") ,
		span_notice("[user] залатывает некоторые раны [skloname(target.name, RODITELNI, target.gender)]."),
		target_detailed = TRUE,
	)
	target.take_bodypart_damage(5,5)
