/obj/item/disk/surgery/brainwashing
	name = "Хирургический диск для промывания мозгов"
	desc = "На диске содержатся инструкции по тому, как запечатлеть приказ в мозгу, делая его основной директивой пациента."
	surgeries = list(/datum/surgery/advanced/brainwashing)

/datum/surgery/advanced/brainwashing
	name = "Операция на мозге: Промывка мозгов"
	desc = "Хирургическая процедура, которая запечатляет приказ в мозге пациента, делая его основной директивой. Эту директиву можно отменить используя имплант защиты разума."
	possible_locs = list(BODY_ZONE_HEAD)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/brainwash,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/brainwashing/can_start(mob/user, mob/living/carbon/target)
	if(!..())
		return FALSE
	var/obj/item/organ/internal/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		return FALSE
	return TRUE

/datum/surgery_step/brainwash
	name = "промывание мозга"
	implements = list(
		TOOL_HEMOSTAT = 85,
		TOOL_WIRECUTTER = 50,
		/obj/item/stack/package_wrap = 35,
		/obj/item/stack/cable_coil = 15)
	time = 200
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/hemostat1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'
	var/objective

/datum/surgery_step/brainwash/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	objective = tgui_input_text(user, "Выберите директиву, которую хотите запечатлеть в мозге вашей жертвы", "Промывание мозгов")
	if(!objective)
		return SURGERY_STEP_FAIL
	display_results(
		user,
		target,
		span_notice("Начинаю промывать мозги [skloname(target.name, RODITELNI, target.gender)]...") ,
		span_notice("[user] начинает исправлять мозг [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] начинает проводить операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))

/datum/surgery_step/brainwash/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(!target.mind)
		to_chat(user, span_warning("[target] не реагирует на промывание мозга, кажется, что [target.ru_who()] лишился ума..."))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_MINDSHIELD))
		to_chat(user, span_warning("Слышу слабое жужание устройства в мозгу [skloname(target.name, RODITELNI, target.gender)] и новая директива стирается."))
		return FALSE
	display_results(
		user,
		target,
		span_notice("Успешно промыл[user.ru_a()] мозг [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] успешно исправил[user.ru_a()] мозг [skloname(target.name, RODITELNI, target.gender)]!") ,
		span_notice("[user] завершил[user.ru_a()] операцию на мозге [skloname(target.name, RODITELNI, target.gender)]."))
	to_chat(target, span_userdanger("Что-то заполняет мой разум, принуждая... подчиниться!"))

	brainwash(target, objective)
	message_admins("[ADMIN_LOOKUPFLW(user)] surgically brainwashed [ADMIN_LOOKUPFLW(target)] with the objective '[objective]'.")
	user.log_message("has brainwashed [key_name(target)] with the objective '[objective]' using brainwashing surgery.", LOG_ATTACK)
	target.log_message("has been brainwashed with the objective '[objective]' by [key_name(user)] using brainwashing surgery.", LOG_VICTIM, log_globally=FALSE)
	user.log_message("surgically brainwashed [key_name(target)] with the objective '[objective]'.", LOG_GAME)
	return ..()

/datum/surgery_step/brainwash/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(target.get_organ_slot(ORGAN_SLOT_BRAIN))
		display_results(user,
			target,
			span_warning("Облажалися, повредив мозговую ткань!") ,
			span_warning("[user] облажался, нанеся урон мозгу!") ,
			span_notice("[user] завершил[user.ru_a()] операцию на мозге [target]."))
		target.adjustOrganLoss(ORGAN_SLOT_BRAIN, 40)
	else
		user.visible_message(span_warning("[user] внезапно замечает что мозг над которым [user.ru_who()] работал[user.ru_a()] исчез.") , span_warning("Внезапно обнаруживаю что мозг, над которым я работал[user.ru_a()], исчез."))
	return FALSE
