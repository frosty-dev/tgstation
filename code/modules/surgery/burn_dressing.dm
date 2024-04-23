
/////BURN FIXING SURGERIES//////

///// Debride burnt flesh
/datum/surgery/debride
	name = "Травматология: Удаление инфекции"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/burn/flesh
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/debride,
		/datum/surgery_step/dress,
	)

/datum/surgery/debride/can_start(mob/living/user, mob/living/carbon/target)
	if(!istype(target))
		return FALSE
	if(..())
		var/obj/item/bodypart/targeted_bodypart = target.get_bodypart(user.zone_selected)
		var/datum/wound/burn/flesh/burn_wound = targeted_bodypart.get_wound_type(targetable_wound)
		return(burn_wound && burn_wound.infestation > 0)

//SURGERY STEPS

///// Debride
/datum/surgery_step/debride
	name = "удалите инфекцию (зажим)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCALPEL = 85,
		TOOL_SAW = 60,
		TOOL_WIRECUTTER = 40)
	time = 30
	repeatable = TRUE
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/retractor2.ogg'
	failure_sound = 'sound/surgery/organ1.ogg'
	/// How much sanitization is added per step
	var/sanitization_added = 0.5
	/// How much infestation is removed per step (positive number)
	var/infestation_removed = 4

/datum/surgery_step/debride/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		var/datum/wound/burn/flesh/burn_wound = surgery.operated_wound
		if(burn_wound.infestation <= 0)
			to_chat(user, span_notice(" На [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)] нет инфицированной плоти, которую можно удалить!"))
			surgery.status++
			repeatable = FALSE
			return
		display_results(
			user,
			target,
			span_notice("Начинаю удалять инфицированную плоть с [ru_otkuda_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)] ...") ,
			span_notice("[user] начинает удалять инфицированную плоть с [ru_otkuda_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)] при помощи [tool].") ,
			span_notice("[user] начинает удалять инфицированную плоть с [ru_otkuda_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)]."))
	else
		user.visible_message(span_notice("[user] пытается найти [parse_zone(user.zone_selected)] у [skloname(target.name, RODITELNI, target.gender)].") , span_notice("Пытаюсь найти [parse_zone(user.zone_selected)] у [skloname(target.name, RODITELNI, target.gender)]..."))

/datum/surgery_step/debride/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/burn/flesh/burn_wound = surgery.operated_wound
	if(burn_wound)
		display_results(
			user,
			target,
			span_notice("Успешно удалил[user.ru_a()] некоторую инфицированную плоть с [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)] .") ,
			span_notice("[user] успешно удалил[user.ru_a()] некоторую инфицированную плоть с [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]!") ,
			span_notice("[user] успешно удалил[user.ru_a()] некоторую инфицированную плоть с [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!"))
		log_combat(user, target, "excised infected flesh in", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
		surgery.operated_bodypart.receive_damage(brute=3, wound_bonus=CANT_WOUND)
		burn_wound.infestation -= infestation_removed
		burn_wound.sanitization += sanitization_added
		if(burn_wound.infestation <= 0)
			repeatable = FALSE
	else
		to_chat(user, span_warning("У [skloname(target.name, RODITELNI, target.gender)] тут нет инфицированной плоти!"))
	return ..()

/datum/surgery_step/debride/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	display_results(
		user,
		target,
		span_notice("Отрезал[user.ru_a()] немного здоровой плоти с [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)].") ,
		span_notice("[user] отрезал[user.ru_a()] немного здоровой плоти с [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]!") ,
		span_notice("[user] отрезал[user.ru_a()] немного здоровой плоти с [ru_otkuda_zone(parse_zone(target_zone))] [skloname(target.name, RODITELNI, target.gender)]!"))
	surgery.operated_bodypart.receive_damage(brute=rand(4,8), sharpness=TRUE)

/datum/surgery_step/debride/initiate(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail = FALSE)
	if(!..())
		return
	var/datum/wound/burn/flesh/burn_wound = surgery.operated_wound
	while(burn_wound && burn_wound.infestation > 0.25)
		if(!..())
			break

///// Dressing burns
/datum/surgery_step/dress
	name = "обработайте ожоги (бинт/лента)"
	implements = list(
		/obj/item/stack/medical/gauze = 100,
		/obj/item/stack/sticky_tape/surgical = 100)
	time = 40
	/// How much sanitization is added
	var/sanitization_added = 3
	/// How much flesh healing is added
	var/flesh_healing_added = 5


/datum/surgery_step/dress/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/datum/wound/burn/flesh/burn_wound = surgery.operated_wound
	if(burn_wound)
		display_results(user, target, span_notice("Начинаю перевязку ожогов на [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает перевязку ожогов на [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)] при помощи [tool].") ,
			span_notice("[user] начинает перевязку ожогов на [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "Ожоги на моей [ru_gde_zone(parse_zone(user.zone_selected))] адски болят!")
	else
		user.visible_message(span_notice("[user] пытается найти [parse_zone(user.zone_selected)] у [skloname(target.name, RODITELNI, target.gender)].") , span_notice("Пытаюсь найти [parse_zone(user.zone_selected)] у [skloname(target.name, RODITELNI, target.gender)]..."))

/datum/surgery_step/dress/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/burn/flesh/burn_wound = surgery.operated_wound
	if(burn_wound)
		display_results(
			user,
			target,
			span_notice("Успешно обернул[user.ru_a()] [ru_parse_zone(parse_zone(target_zone))] при помощи [tool].") ,
			span_notice("[user] успешно обернул[user.ru_a()] [ru_parse_zone(parse_zone(target_zone))] при помощи [tool]!") ,
			span_notice("[user] спешно обернул[user.ru_a()] [ru_parse_zone(parse_zone(target_zone))]!"))
		log_combat(user, target, "dressed burns in", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
		burn_wound.sanitization += sanitization_added
		burn_wound.flesh_healing += flesh_healing_added
		var/obj/item/bodypart/the_part = target.get_bodypart(target_zone)
		the_part.apply_gauze(tool)
	else
		to_chat(user, span_warning("У [skloname(target.name, RODITELNI, target.gender)] тут нет ожогов!"))
	return ..()

/datum/surgery_step/dress/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)
