
/////BONE FIXING SURGERIES//////

///// Repair Hairline Fracture (Severe)
/datum/surgery/repair_bone_hairline
	name = "Травматология: Лечение трещины"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/blunt/bone/severe
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/repair_bone_hairline,
		/datum/surgery_step/close,
	)

/datum/surgery/repair_bone_hairline/can_start(mob/living/user, mob/living/carbon/target)
	. = ..()
	if(.)
		var/obj/item/bodypart/targeted_bodypart = target.get_bodypart(user.zone_selected)
		return(targeted_bodypart.get_wound_type(targetable_wound))


///// Repair Compound Fracture (Critical)
/datum/surgery/repair_bone_compound
	name = "Травматология: Лечение перелома"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/blunt/bone/critical
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/reset_compound_fracture,
		/datum/surgery_step/repair_bone_compound,
		/datum/surgery_step/close,
	)

/datum/surgery/repair_bone_compound/can_start(mob/living/user, mob/living/carbon/target)
	. = ..()
	if(.)
		var/obj/item/bodypart/targeted_bodypart = target.get_bodypart(user.zone_selected)
		return(targeted_bodypart.get_wound_type(targetable_wound))

//SURGERY STEPS

///// Repair Hairline Fracture (Severe)
/datum/surgery_step/repair_bone_hairline
	name = "восстановите костную структуру (костоправ/костный гель/лента)"
	implements = list(
		/obj/item/bonesetter = 100,
		/obj/item/stack/medical/bone_gel = 100,
		/obj/item/stack/sticky_tape/surgical = 100,
		/obj/item/stack/sticky_tape/super = 50,
		/obj/item/stack/sticky_tape = 30)
	time = 40

/datum/surgery_step/repair_bone_hairline/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		display_results(
			user,
			target,
			span_notice("Начинаю восстанавливать костную структуру в [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает восстанавливать костную структуру в [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)] используя [tool].") ,
			span_notice("[user] начинает восстанавливать костную структуру в [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "Моя [parse_zone(user.zone_selected)] болезненно ноет!")
	else
		user.visible_message(span_notice("[user] пытается найти [parse_zone(user.zone_selected)] у [skloname(target.name, RODITELNI, target.gender)].") , span_notice("Пытаюсь найти [parse_zone(user.zone_selected)] у [skloname(target.name, RODITELNI, target.gender)]..."))

/datum/surgery_step/repair_bone_hairline/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_wound)
		if(isstack(tool))
			var/obj/item/stack/used_stack = tool
			used_stack.use(1)
		display_results(
			user,
			target,
			span_notice("Успешно восстанавливаю костную структуру в [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] успешно восстановил[user.ru_a()] костную структуру в [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)] используя [tool]!") ,
			span_notice("[user] успешно восстановил[user.ru_a()] костную структуру в [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)]!"))

		log_combat(user, target, "repaired a hairline fracture in", addition="COMBAT_MODE: [uppertext(user.combat_mode)]")
		qdel(surgery.operated_wound)
	else
		to_chat(user, span_warning("[target] не имеет травм!"))
	return ..()

/datum/surgery_step/repair_bone_hairline/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)



///// Reset Compound Fracture (Crticial)
/datum/surgery_step/reset_compound_fracture
	name = "вправьте кость (костоправ)"
	implements = list(
		/obj/item/bonesetter = 100,
		/obj/item/stack/sticky_tape/surgical = 60,
		/obj/item/stack/sticky_tape/super = 40,
		/obj/item/stack/sticky_tape = 20)
	time = 40

/datum/surgery_step/reset_compound_fracture/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		display_results(
			user,
			target,
			span_notice("Начинаю вправлять кость в [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает вправлять кость в [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)] при помощи [tool].") ,
			span_notice("[user] начинает вправлять кость в [ru_gde_zone(parse_zone(user.zone_selected))] [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "Ноющая боль в моей [ru_gde_zone(parse_zone(user.zone_selected))] невыносима!")
	else
		user.visible_message(span_notice("[user] пытается найти [parse_zone(user.zone_selected)] у [skloname(target.name, RODITELNI, target.gender)].") , span_notice("Пытаюсь найти [parse_zone(user.zone_selected)] у [skloname(target.name, RODITELNI, target.gender)]..."))

/datum/surgery_step/reset_compound_fracture/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_wound)
		if(isstack(tool))
			var/obj/item/stack/used_stack = tool
			used_stack.use(1)
		display_results(
			user,
			target,
			span_notice("Успешно вправляю кость в [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] успешно вправил[user.ru_a()] кость в [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]!") ,
			span_notice("[user] успешно вправил[user.ru_a()] кость в [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)]!"))

		log_combat(user, target, "reset a compound fracture in", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
	else
		to_chat(user, span_warning("[target] не имеет травм!"))
	return ..()

/datum/surgery_step/reset_compound_fracture/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)


///// Repair Compound Fracture (Crticial)
/datum/surgery_step/repair_bone_compound
	name = "восстановите костную структуру (костный гель/лента)"
	implements = list(
		/obj/item/stack/medical/bone_gel = 100,
		/obj/item/stack/sticky_tape/surgical = 100,
		/obj/item/stack/sticky_tape/super = 50,
		/obj/item/stack/sticky_tape = 30)
	time = 40

/datum/surgery_step/repair_bone_compound/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(surgery.operated_wound)
		display_results(
			user,
			target,
			span_notice("Вы начинаете восстанавливать костную структуру в [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)]...") ,
			span_notice("[user] начинает восстанавливать костную структуру в [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)] при помощи [tool].") ,
			span_notice("[user] начинает восстанавливать костную структуру в [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)]."))
		display_pain(target, "Ноющая боль в моей [parse_zone(user.zone_selected)] невыносима!!")
	else
		user.visible_message(span_notice("[user] пытается найти [parse_zone(user.zone_selected)] у [skloname(target.name, RODITELNI, target.gender)].") , span_notice("Пытаюсь найти [parse_zone(user.zone_selected)] у [skloname(target.name, RODITELNI, target.gender)]..."))

/datum/surgery_step/repair_bone_compound/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(surgery.operated_wound)
		if(isstack(tool))
			var/obj/item/stack/used_stack = tool
			used_stack.use(1)
		display_results(user, target, span_notice("Успешно восстанавливаю костную структуру в [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)].") ,
			span_notice("[user] успешно восстановил[user.ru_a()] костную структуру в [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)] при помощи [tool]!") ,
			span_notice("[user] успешно восстановил[user.ru_a()] костную структуру в [parse_zone(user.zone_selected)] [skloname(target.name, RODITELNI, target.gender)]!"))

		log_combat(user, target, "repaired a compound fracture in", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
		qdel(surgery.operated_wound)
	else
		to_chat(user, span_warning("[target] не имеет травм!"))
	return ..()

/datum/surgery_step/repair_bone_compound/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	..()
	if(isstack(tool))
		var/obj/item/stack/used_stack = tool
		used_stack.use(1)
