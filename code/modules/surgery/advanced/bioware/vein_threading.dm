/datum/surgery/advanced/bioware/vein_threading
	name = "Сплетение вен"
	desc = "A surgical procedure which severely reduces the amount of blood lost in case of injury."
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/incise,
		/datum/surgery_step/incise,
		/datum/surgery_step/thread_veins,
		/datum/surgery_step/close,
	)

	bioware_target = BIOWARE_CIRCULATION

/datum/surgery_step/thread_veins
	name = "переплетите вены (мануальное действие)"
	accept_hand = TRUE
	time = 125

/datum/surgery_step/thread_veins/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You start weaving [target]'s circulatory system."),
		span_notice("[user] starts weaving [target]'s circulatory system."),
		span_notice("[user] starts manipulating [target]'s circulatory system."),
	)
	display_pain(target, "Your entire body burns in agony!")

/datum/surgery_step/thread_veins/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("You weave [target]'s circulatory system into a resistant mesh!"),
		span_notice("[user] weaves [target]'s circulatory system into a resistant mesh!"),
		span_notice("[user] finishes manipulating [target]'s circulatory system."),
	)
	display_pain(target, "You can feel your blood pumping through reinforced veins!")
	new /datum/bioware/threaded_veins(target)
	return ..()

/datum/bioware/threaded_veins
	name = "Threaded Veins"
	desc = "The circulatory system is woven into a mesh, severely reducing the amount of blood lost from wounds."
	mod_type = BIOWARE_CIRCULATION

/datum/bioware/threaded_veins/on_gain()
	..()
	owner.physiology.bleed_mod *= 0.25

/datum/bioware/threaded_veins/on_lose()
	..()
	owner.physiology.bleed_mod *= 4
