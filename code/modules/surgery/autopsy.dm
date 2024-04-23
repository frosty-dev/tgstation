/datum/surgery/autopsy
	name = "Вскрытие"
	surgery_flags = SURGERY_IGNORE_CLOTHES | SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_MORBID_CURIOSITY
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/autopsy,
		/datum/surgery_step/close,
	)

/datum/surgery/autopsy/can_start(mob/user, mob/living/patient)
	. = ..()
	if(patient.stat != DEAD)
		return FALSE
	if(HAS_TRAIT_FROM(patient, TRAIT_DISSECTED, AUTOPSY_TRAIT))
		return FALSE
	return TRUE

/datum/surgery_step/autopsy
	name = "Исследовать (сканер)"
	implements = list(/obj/item/autopsy_scanner = 100)
	time = 10 SECONDS
	success_sound = 'sound/machines/printer.ogg'

/datum/surgery_step/autopsy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Начинаю патологоанатомическое вскрытие [target]"),
		span_notice("[user] начинает патологоанатомическое вскрытие [target]..."),
		span_notice("[user] начинает патологоанатомическое вскрытие!"),
	)

/datum/surgery_step/autopsy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/autopsy_scanner/tool, datum/surgery/surgery, default_display_results = FALSE)
	ADD_TRAIT(target, TRAIT_DISSECTED, AUTOPSY_TRAIT)
	if(!HAS_TRAIT(src, TRAIT_SURGICALLY_ANALYZED))
		ADD_TRAIT(target, TRAIT_SURGICALLY_ANALYZED, AUTOPSY_TRAIT)
	tool.scan_cadaver(user, target)
	var/obj/machinery/computer/operating/operating_computer = surgery.locate_operating_computer(get_turf(target))
	if (!isnull(operating_computer))
		SEND_SIGNAL(operating_computer, COMSIG_OPERATING_COMPUTER_AUTOPSY_COMPLETE, target)
	if(HAS_MIND_TRAIT(user, TRAIT_MORBID) && ishuman(user))
		var/mob/living/carbon/human/morbid_weirdo = user
		morbid_weirdo.add_mood_event("morbid_dissection_success", /datum/mood_event/morbid_dissection_success)
	return ..()

/datum/surgery_step/autopsy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("Кажется я это был не очень аккуратный разрез! Впрочем пациенту кажется уже все равно..."),
		span_notice("[user] действует очень неаккуратно! Впрочем пациенту кажется уже все равно..."),
		span_notice("[user] действует очень неаккуратно! Впрочем пациенту кажется уже все равно...!")
	)

	target.adjustOrganLoss(pick(
		ORGAN_SLOT_APPENDIX,
		ORGAN_SLOT_BRAIN,
		ORGAN_SLOT_HEART,
		ORGAN_SLOT_LIVER,
		ORGAN_SLOT_LUNGS,
		ORGAN_SLOT_STOMACH,
	), 20)

	target.adjustBruteLoss(5)
