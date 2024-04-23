//This file contains loot you can obtain from tendril chests.

//KA modkit design discs
/obj/item/disk/design_disk/modkit_disc
	name = "KA Mod Disk"
	desc = "A design disc containing the design for a unique kinetic accelerator modkit. It's compatible with a research console."
	icon_state = "datadisk1"
	var/modkit_design = /datum/design/unique_modkit

/obj/item/disk/design_disk/modkit_disc/Initialize(mapload)
	. = ..()
	blueprints += new modkit_design

/obj/item/disk/design_disk/modkit_disc/mob_and_turf_aoe
	name = "Offensive Mining Explosion Mod Disk"
	modkit_design = /datum/design/unique_modkit/offensive_turf_aoe

/obj/item/disk/design_disk/modkit_disc/rapid_repeater
	name = "Rapid Repeater Mod Disk"
	modkit_design = /datum/design/unique_modkit/rapid_repeater

/obj/item/disk/design_disk/modkit_disc/resonator_blast
	name = "Resonator Blast Mod Disk"
	modkit_design = /datum/design/unique_modkit/resonator_blast

/obj/item/disk/design_disk/modkit_disc/bounty
	name = "Death Syphon Mod Disk"
	modkit_design = /datum/design/unique_modkit/bounty

/datum/design/unique_modkit
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_PKA_MODS,
	)
	build_type = PROTOLATHE
	departmental_flags = DEPARTMENT_BITFLAG_CARGO

/datum/design/unique_modkit/offensive_turf_aoe
	name = "Kinetic Accelerator Offensive Mining Explosion Mod"
	desc = "A device which causes kinetic accelerators to fire AoE blasts that destroy rock and damage creatures."
	id = "hyperaoemod"
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*3.5, /datum/material/glass = SHEET_MATERIAL_AMOUNT*1.5, /datum/material/silver =SHEET_MATERIAL_AMOUNT*1.5, /datum/material/gold =SHEET_MATERIAL_AMOUNT*1.5, /datum/material/diamond = SHEET_MATERIAL_AMOUNT*2)
	build_path = /obj/item/borg/upgrade/modkit/aoe/turfs/andmobs

/datum/design/unique_modkit/rapid_repeater
	name = "Kinetic Accelerator Rapid Repeater Mod"
	desc = "A device which greatly reduces a kinetic accelerator's cooldown on striking a living target or rock, but greatly increases its base cooldown."
	id = "repeatermod"
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT * 5, /datum/material/glass =SHEET_MATERIAL_AMOUNT * 2.5, /datum/material/uranium = SHEET_MATERIAL_AMOUNT*4, /datum/material/bluespace =SHEET_MATERIAL_AMOUNT)
	build_path = /obj/item/borg/upgrade/modkit/cooldown/repeater

/datum/design/unique_modkit/resonator_blast
	name = "Kinetic Accelerator Resonator Blast Mod"
	desc = "A device which causes kinetic accelerators to fire shots that leave and detonate resonator blasts."
	id = "resonatormod"
	materials = list(/datum/material/iron =HALF_SHEET_MATERIAL_AMOUNT*5, /datum/material/glass =HALF_SHEET_MATERIAL_AMOUNT*5, /datum/material/silver =HALF_SHEET_MATERIAL_AMOUNT*5, /datum/material/uranium =SHEET_MATERIAL_AMOUNT * 2.5)
	build_path = /obj/item/borg/upgrade/modkit/resonator_blasts

/datum/design/unique_modkit/bounty
	name = "Kinetic Accelerator Death Syphon Mod"
	desc = "A device which causes kinetic accelerators to permanently gain damage against creature types killed with it."
	id = "bountymod"
	materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*2, /datum/material/silver = SHEET_MATERIAL_AMOUNT*2, /datum/material/gold = SHEET_MATERIAL_AMOUNT*2, /datum/material/bluespace = SHEET_MATERIAL_AMOUNT*2)
	build_path = /obj/item/borg/upgrade/modkit/bounty

//Spooky special loot

//Rod of Asclepius
/obj/item/rod_of_asclepius
	name = "жезл асклепия"
	desc = "Небольшой деревянный жезл с обвившейся вокруг него змеей. Весь его вид внушает вам чувство долга и нужду помогать страждущим."
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/staves_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/staves_righthand.dmi'
	icon_state = "asclepius_dormant"
	inhand_icon_state = "asclepius_dormant"
	var/activated = FALSE

/obj/item/rod_of_asclepius/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/rod_of_asclepius/update_desc(updates)
	. = ..()
	desc = activated ? "Небольшой деревянный жезл с мистической змеей, обвившей жезл и мою руку. Он источает целительную энергию, которая окутывает меня и всех окружающих. Я чувствую, что способен одним только касанием поднять мертвеца!" : initial(desc)

/obj/item/rod_of_asclepius/update_icon_state()
	. = ..()
	icon_state = inhand_icon_state = "asclepius_[activated ? "active" : "dormant"]"

/obj/item/rod_of_asclepius/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, activated) && activated)
		activated()

/obj/item/rod_of_asclepius/attack_self(mob/user)
	if(activated)
		return
	if(!iscarbon(user))
		to_chat(user, span_warning("Змея на жезле на мгновение оживает и смотрит на меня, но через мгновение разочаровано отворачивается и снова замирает, как будто она знает, что я неспособен сдержать свою клятву."))
		return
	var/mob/living/carbon/item_user = user
	var/usedHand = item_user.get_held_index_of_item(src)
	if(item_user.has_status_effect(/datum/status_effect/hippocratic_oath))
		to_chat(user, span_warning("Не в моих силах нести больше ответственности, чем я могу на себя принять!"))
		return
	var/fail_text = span_warning("Змея, похоже, недовольна моей неполной клятвой и вновь замирает, возвращаясь в свое спящее, деревянное состояние. Я должен подойти к этому дело ответственно и стоять неподвижно во время принесения торжественной клятвы!")
	to_chat(item_user, span_notice("Деревянная змея, вырезанная на жезле, внезапно оживает и обвивает мою руку! У меня проявляется необычайно сильное желание помогать другим..."))
	if(do_after(item_user, 40, target = item_user))
		item_user.say("Получая высокое звание врача и приступая к профессиональной деятельности, я торжественно клянусь:", forced = "hippocratic oath")
	else
		to_chat(item_user, fail_text)
		return
	if(do_after(item_user, 30, target = item_user))
		item_user.say("Честно исполнять свой врачебный долг, посвятить свои знания и умения предупреждению и лечению заболеваний, сохранению и укреплению здоровья человека", forced = "hippocratic oath")
	else
		to_chat(item_user, fail_text)
		return
	if(do_after(item_user, 50, target = item_user))
		item_user.say("Быть всегда готовым оказать медицинскую помощь, хранить врачебную тайну, внимательно и заботливо относиться к пациенту, действовать исключительно в его интересах независимо от пола, расы, национальности, языка, происхождения, имущественного и должностного положения, места жительства, отношения к религии, убеждений, принадлежности к общественным объединениям, а также других обстоятельств", forced = "hippocratic oath")
	else
		to_chat(item_user, fail_text)
		return
	if(do_after(item_user, 20, target = item_user))
		item_user.say("Проявлять высочайшее уважение к жизни человека, никогда не прибегать к осуществлению эвтаназии", forced = "hippocratic oath")
	else
		to_chat(item_user, fail_text)
		return
	if(do_after(item_user, 20, target = item_user))
		item_user.say("Хранить благодарность и уважение к своим учителям, быть требовательным и справедливым к своим ученикам, способствовать их профессиональному росту", forced = "hippocratic oath")
	else
		to_chat(item_user, fail_text)
		return
	if(do_after(item_user, 30, target = item_user))
		item_user.say("Доброжелательно относиться к коллегам, обращаться к ним за помощью и советом, если этого требуют интересы пациента, и самому никогда не отказывать коллегам в помощи и совете", forced = "hippocratic oath")
	else
		to_chat(item_user, fail_text)
		return
	if(do_after(item_user, 20, target = item_user))
		item_user.say("Постоянно совершенствовать свое профессиональное мастерство, беречь и развивать благородные традиции медицины.", forced = "hippocratic oath")
	else
		to_chat(item_user, fail_text)
		return
	to_chat(item_user, span_notice("Змея, удовлетворенная моей клятвой, обвивает мою руку и жезл, теперь я не смогу отпустить его, даже если захочу. Мои мысли, сконцентрированы исключительно на помощи страждущим, а в голове запечетлелась фраза: \"Не навреди\"..."))
	var/datum/status_effect/hippocratic_oath/effect = item_user.apply_status_effect(/datum/status_effect/hippocratic_oath)
	effect.hand = usedHand
	activated()

/obj/item/rod_of_asclepius/proc/activated()
	item_flags = DROPDEL
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT(type))
	activated = TRUE
	update_appearance()

//Memento Mori
/obj/item/clothing/neck/necklace/memento_mori
	name = "память о смерти"
	desc = "Мистический талисман. На нем выгравирована надпись: \"Memento mori - Верная смерть завтра означает верную жизнь сегодня.\""
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "memento_mori"
	worn_icon_state = "memento"
	actions_types = list(/datum/action/item_action/hands_free/memento_mori)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/mob/living/carbon/human/active_owner

/obj/item/clothing/neck/necklace/memento_mori/item_action_slot_check(slot)
	return (slot & ITEM_SLOT_NECK)

/obj/item/clothing/neck/necklace/memento_mori/dropped(mob/user)
	..()
	if(active_owner)
		mori()

//Just in case
/obj/item/clothing/neck/necklace/memento_mori/Destroy()
	if(active_owner)
		mori()
	return ..()

/obj/item/clothing/neck/necklace/memento_mori/proc/memento(mob/living/carbon/human/user)
	to_chat(user, span_warning("Чувствую, как кулон высасывает мою жизнь..."))
	if(do_after(user, 40, target = user))
		to_chat(user, span_notice("Моя жизненная сила теперь связана с кулоном! Чувствую, что не стоит его снимать..."))
		user.add_traits(list(TRAIT_NODEATH, TRAIT_NOHARDCRIT, TRAIT_NOCRITDAMAGE), CLOTHING_TRAIT)
		RegisterSignal(user, COMSIG_LIVING_HEALTH_UPDATE, PROC_REF(check_health))
		icon_state = "memento_mori_active"
		active_owner = user

/obj/item/clothing/neck/necklace/memento_mori/proc/mori()
	icon_state = "memento_mori"
	if(!active_owner)
		return
	UnregisterSignal(active_owner, COMSIG_LIVING_HEALTH_UPDATE)
	var/mob/living/carbon/human/H = active_owner //to avoid infinite looping when dust unequips the pendant
	active_owner = null
	to_chat(H, span_userdanger("Чувствую, как жизненная сила стремительно ускользает!"))
	H.dust(TRUE, TRUE)

/obj/item/clothing/neck/necklace/memento_mori/proc/check_health(mob/living/source)
	SIGNAL_HANDLER

	var/list/guardians = source.get_all_linked_holoparasites()
	if(!length(guardians))
		return
	if(source.health <= HEALTH_THRESHOLD_DEAD)
		for(var/mob/guardian in guardians)
			if(guardian.loc == src)
				continue
			consume_guardian(guardian)
	else if(source.health > HEALTH_THRESHOLD_CRIT)
		for(var/mob/guardian in guardians)
			if(guardian.loc != src)
				continue
			regurgitate_guardian(guardian)

/obj/item/clothing/neck/necklace/memento_mori/proc/consume_guardian(mob/living/simple_animal/hostile/guardian/guardian)
	new /obj/effect/temp_visual/guardian/phase/out(get_turf(guardian))
	guardian.locked = TRUE
	guardian.forceMove(src)
	to_chat(guardian, span_userdanger("Заперт в кулоне хозяина!"))
	guardian.playsound_local(get_turf(guardian), 'sound/magic/summonitems_generic.ogg', 50, TRUE)

/obj/item/clothing/neck/necklace/memento_mori/proc/regurgitate_guardian(mob/living/simple_animal/hostile/guardian/guardian)
	guardian.locked = FALSE
	guardian.recall(forced = TRUE)
	to_chat(guardian, span_notice("Высвобождаюсь из кулона хозяина!"))
	guardian.playsound_local(get_turf(guardian), 'sound/magic/repulse.ogg', 50, TRUE)

/datum/action/item_action/hands_free/memento_mori
	check_flags = NONE
	name = "Memento Mori"
	desc = "Свяжи свою жизнь с кулоном."

/datum/action/item_action/hands_free/memento_mori/Trigger(trigger_flags)
	var/obj/item/clothing/neck/necklace/memento_mori/MM = target
	if(!MM.active_owner)
		if(ishuman(owner))
			MM.memento(owner)
			Remove(MM.active_owner) //Remove the action button, since there's no real use in having it now.

//Wisp Lantern
/obj/item/wisp_lantern
	name = "жуткий фонарь"
	desc = "Этот фонарь не излучает света, но является домом для дружелюбного огонька."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "lantern-blue-on"
	inhand_icon_state = "lantern-blue-on"
	lefthand_file = 'icons/mob/inhands/equipment/mining_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/mining_righthand.dmi'
	var/obj/effect/wisp/wisp

/obj/item/wisp_lantern/attack_self(mob/user)
	if(!wisp)
		to_chat(user, span_warning("Огонёк пропал!"))
		icon_state = "lantern-blue"
		inhand_icon_state = "lantern-blue"
		return

	if(wisp.loc == src)
		to_chat(user, span_notice("Выпускаю огонёк. Он начинает кружиться вокруг моей головы."))
		icon_state = "lantern-blue"
		inhand_icon_state = "lantern-blue"
		wisp.orbit(user, 20)
		SSblackbox.record_feedback("tally", "wisp_lantern", 1, "Freed")

	else
		to_chat(user, span_notice("Возвращаю огонёк в лампу."))
		icon_state = "lantern-blue-on"
		inhand_icon_state = "lantern-blue-on"
		wisp.forceMove(src)
		SSblackbox.record_feedback("tally", "wisp_lantern", 1, "Returned")

/obj/item/wisp_lantern/Initialize(mapload)
	. = ..()
	wisp = new(src)

/obj/item/wisp_lantern/Destroy()
	if(wisp)
		if(wisp.loc == src)
			qdel(wisp)
		else
			wisp.visible_message(span_notice("На мгновение огонёк выглядит грустным."))
	return ..()

/obj/effect/wisp
	name = "дружелюбный огонёк"
	desc = "Рад помочь вам осветить путь."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "orb"
	light_system = MOVABLE_LIGHT
	light_range = 7
	light_flags = LIGHT_ATTACHED
	layer = ABOVE_ALL_MOB_LAYER
	plane = ABOVE_GAME_PLANE
	var/sight_flags = SEE_MOBS
	var/list/color_cutoffs = list(10, 25, 25)

/obj/effect/wisp/orbit(atom/thing, radius, clockwise, rotation_speed, rotation_segments, pre_rotation, lockinorbit)
	. = ..()
	if(ismob(thing))
		RegisterSignal(thing, COMSIG_MOB_UPDATE_SIGHT, PROC_REF(update_user_sight))
		var/mob/being = thing
		being.update_sight()
		to_chat(thing, span_notice("Огонёк светится!"))

/obj/effect/wisp/stop_orbit(datum/component/orbiter/orbits)
	. = ..()
	if(ismob(orbits.parent))
		UnregisterSignal(orbits.parent, COMSIG_MOB_UPDATE_SIGHT)
		to_chat(orbits.parent, span_notice("Зрение возвращается к норме."))

/obj/effect/wisp/proc/update_user_sight(mob/user)
	SIGNAL_HANDLER
	user.add_sight(sight_flags)
	if(!isnull(color_cutoffs))
		user.lighting_color_cutoffs = blend_cutoff_colors(user.lighting_color_cutoffs, color_cutoffs)

//Red/Blue Cubes
/obj/item/warp_cube
	name = "синий куб"
	desc = "Мистический синий куб."
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "blue_cube"
	var/teleport_color = "#3FBAFD"
	var/obj/item/warp_cube/linked
	var/teleporting = FALSE

/obj/item/warp_cube/Destroy()
	if(!QDELETED(linked))
		qdel(linked)
	linked = null
	return ..()

/obj/item/warp_cube/attack_self(mob/user)
	var/turf/current_location = get_turf(user)
	var/area/current_area = current_location.loc
	if(!linked || (current_area.area_flags & NOTELEPORT))
		to_chat(user, span_warning("[src] не реагирует."))
		return
	if(teleporting)
		return
	teleporting = TRUE
	linked.teleporting = TRUE
	var/turf/T = get_turf(src)
	new /obj/effect/temp_visual/warp_cube(T, user, teleport_color, TRUE)
	SSblackbox.record_feedback("tally", "warp_cube", 1, type)
	new /obj/effect/temp_visual/warp_cube(get_turf(linked), user, linked.teleport_color, FALSE)
	var/obj/effect/warp_cube/link_holder = new /obj/effect/warp_cube(T)
	user.forceMove(link_holder) //mess around with loc so the user can't wander around
	sleep(0.25 SECONDS)
	if(QDELETED(user))
		qdel(link_holder)
		return
	if(QDELETED(linked))
		user.forceMove(get_turf(link_holder))
		qdel(link_holder)
		return
	link_holder.forceMove(get_turf(linked))
	sleep(0.25 SECONDS)
	if(QDELETED(user))
		qdel(link_holder)
		return
	teleporting = FALSE
	if(!QDELETED(linked))
		linked.teleporting = FALSE
	user.forceMove(get_turf(link_holder))
	qdel(link_holder)

/obj/item/warp_cube/red
	name = "красный куб"
	desc = "Мистический красный куб."
	icon_state = "red_cube"
	teleport_color = "#FD3F48"

/obj/item/warp_cube/red/Initialize(mapload)
	. = ..()
	if(!linked)
		var/obj/item/warp_cube/blue = new(src.loc)
		linked = blue
		blue.linked = src

/obj/effect/warp_cube
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE

//Immortality Talisman
/obj/item/immortality_talisman
	name = "талисман бессмертия"
	desc = "Жуткий талисман, который может сделать вас совершенно неуязвимым."
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "talisman"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	actions_types = list(/datum/action/item_action/immortality)
	var/cooldown = 0

/obj/item/immortality_talisman/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, ALL)

/datum/action/item_action/immortality
	name = "Immortality"

/obj/item/immortality_talisman/attack_self(mob/user)
	if(cooldown < world.time)
		SSblackbox.record_feedback("amount", "immortality_talisman_uses", 1)
		cooldown = world.time + 600
		new /obj/effect/immortality_talisman(get_turf(user), user)
	else
		to_chat(user, span_warning("[src] не готов!"))

/obj/effect/immortality_talisman
	name = "разрыв пространства"
	desc = "Своей формой удивительно похож на человека."
	icon_state = "blank"
	icon = 'icons/effects/effects.dmi'
	var/vanish_description = "исчезает"
	// Weakref to the user who we're "acting" on
	var/datum/weakref/user_ref

/obj/effect/immortality_talisman/Initialize(mapload, mob/new_user)
	. = ..()
	if(new_user)
		vanish(new_user)

/obj/effect/immortality_talisman/Destroy()
	// If we have a mob, we need to free it before cleanup
	// This is a safety to prevent nuking a human, not so much a good pattern in general
	unvanish()
	return ..()

/obj/effect/immortality_talisman/proc/unvanish()
	var/mob/user = user_ref?.resolve()
	user_ref = null

	if(!user)
		return

	user.status_flags &= ~GODMODE
	REMOVE_TRAIT(user, TRAIT_NO_TRANSFORM, REF(src))
	user.forceMove(get_turf(src))
	user.visible_message(span_danger("[user] возвращается в реальность!"))

/obj/effect/immortality_talisman/proc/vanish(mob/user)
	user.visible_message(span_danger("[user] [vanish_description], оставляя дыру на своем месте!"))
	desc = "Своей формой удивительно похож на [user.name]."
	setDir(user.dir)

	user.forceMove(src)
	ADD_TRAIT(user, TRAIT_NO_TRANSFORM, REF(src))
	user.status_flags |= GODMODE

	user_ref = WEAKREF(user)

	addtimer(CALLBACK(src, PROC_REF(dissipate)), 10 SECONDS)

/obj/effect/immortality_talisman/proc/dissipate()
	qdel(src)

/obj/effect/immortality_talisman/attackby()
	return

/obj/effect/immortality_talisman/relaymove(mob/living/user, direction)
	// Won't really come into play since our mob has TRAIT_NO_TRANSFORM and cannot move,
	// but regardless block all relayed moves, because no, you cannot move in the void.
	return

/obj/effect/immortality_talisman/singularity_pull()
	return

/obj/effect/immortality_talisman/void
	vanish_description = "исчезает"

//Shared Bag

/obj/item/shared_storage
	name = "сумка-парадокс"
	desc = "Каким-то образом находится в двух местах одновременно."
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "paradox_bag"
	worn_icon_state = "paradoxbag"
	slot_flags = ITEM_SLOT_BELT
	resistance_flags = INDESTRUCTIBLE

/obj/item/shared_storage/red
	name = "сумка-парадокс"
	desc = "Каким-то образом находится в двух местах одновременно."

/obj/item/shared_storage/red/Initialize(mapload)
	. = ..()

	create_storage(max_total_storage = 15, max_slots = 21)

	new /obj/item/shared_storage/blue(drop_location(), src)

/obj/item/shared_storage/blue/Initialize(mapload, atom/master)
	. = ..()
	if(!istype(master))
		return INITIALIZE_HINT_QDEL
	create_storage(max_total_storage = 15, max_slots = 21)

	atom_storage.set_real_location(master)

//Book of Babel

/obj/item/book_of_babel
	name = "книга Вавилона"
	desc = "Древний фолиант, написанный на бесчисленных языках."
	icon = 'icons/obj/service/library.dmi'
	icon_state = "book1"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/book_of_babel/attack_self(mob/user)
	if(user.is_blind())
		to_chat(user, span_warning("Не могу ничего разглядеть!"))
		return FALSE
	if(!user.can_read(src))
		return FALSE
	to_chat(user, span_notice("Листаю страницы книги. Кажется, теперь я могу говорить на всех языках!"))
	cure_curse_of_babel(user) // removes tower of babel if we have it
	user.grant_all_languages(source = LANGUAGE_BABEL)
	user.remove_blocked_language(GLOB.all_languages, source = LANGUAGE_ALL)
	if(user.mind)
		ADD_TRAIT(user.mind, TRAIT_TOWER_OF_BABEL, MAGIC_TRAIT) // this makes you immune to babel effects
	new /obj/effect/decal/cleanable/ash(get_turf(user))
	qdel(src)


//Potion of Flight
/obj/item/reagent_containers/cup/bottle/potion
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "potionflask"
	fill_icon = 'icons/obj/mining_zones/artefacts.dmi'
	fill_icon_state = "potion_fill"
	fill_icon_thresholds = list(0, 1)

/obj/item/reagent_containers/cup/bottle/potion/update_overlays()
	. = ..()
	if(reagents?.total_volume)
		. += "potionflask_cap"

/obj/item/reagent_containers/cup/bottle/potion/flight
	name = "странный эликсир"
	desc = "Флакон, от которого исходит почти священная аура. На этикетке бутылки написано: من يقرأها سيموت."
	list_reagents = list(/datum/reagent/flightpotion = 5)

/datum/reagent/flightpotion
	name = "Зелье полёта"
	description = "Странная жидкость неизвестного происхождения."
	reagent_state = LIQUID
	color = "#976230"

/datum/reagent/flightpotion/expose_mob(mob/living/exposed_mob, methods=TOUCH, reac_volume, show_message = TRUE)
	. = ..()
	if(!ishuman(exposed_mob) || exposed_mob.stat == DEAD)
		return
	if(!(methods & (INGEST | TOUCH)))
		return
	var/mob/living/carbon/human/exposed_human = exposed_mob
	var/obj/item/bodypart/chest/chest = exposed_human.get_bodypart(BODY_ZONE_CHEST)
	if(!chest.wing_types || reac_volume < 5 || !exposed_human.dna)
		if((methods & INGEST) && show_message)
			to_chat(exposed_human, span_notice("<i>Чувствую лишь ужасное послевкусие.</i>"))
		return
	if(exposed_human.get_organ_slot(ORGAN_SLOT_EXTERNAL_WINGS))
		to_chat(exposed_human, span_userdanger("Мои крылья меняют свою форму с ужасающей болью!"))
	else
		to_chat(exposed_human, span_userdanger("Ужасающая боль пронзает мою спину!"))
	var/obj/item/organ/external/wings/functional/wings = get_wing_choice(exposed_human, chest)
	wings = new wings()
	wings.Insert(exposed_human)
	exposed_human.dna.species.handle_mutant_bodyparts(exposed_human)
	playsound(exposed_human.loc, 'sound/items/poster_ripped.ogg', 50, TRUE, -1)
	exposed_human.apply_damage(20, def_zone = BODY_ZONE_CHEST, forced = TRUE, wound_bonus = CANT_WOUND)
	exposed_human.emote("scream")

/datum/reagent/flightpotion/proc/get_wing_choice(mob/needs_wings, obj/item/bodypart/chest/chest)
	var/list/wing_types = chest.wing_types.Copy()
	if(wing_types.len == 1 || !needs_wings.client)
		return wing_types[1]
	var/list/radial_wings = list()
	var/list/name2type = list()
	for(var/obj/item/organ/external/wings/functional/possible_type as anything in wing_types)
		var/datum/sprite_accessory/accessory = initial(possible_type.sprite_accessory_override) //get the type
		accessory = GLOB.wings_list[initial(accessory.name)] //get the singleton instance
		var/image/img = image(icon = accessory.icon, icon_state = "m_wingsopen_[accessory.icon_state]_BEHIND") //Process the HUD elements
		img.transform *= 0.5
		img.pixel_x = -32
		if(radial_wings[accessory.name])
			stack_trace("Different wing types with repeated names. Please fix as this may cause issues.")
		else
			radial_wings[accessory.name] = img
			name2type[accessory.name] = possible_type
	var/wing_name = show_radial_menu(needs_wings, needs_wings, radial_wings, tooltips = TRUE)
	var/wing_type = name2type[wing_name]
	if(!wing_type)
		wing_type = pick(wing_types)
	return wing_type

/obj/item/jacobs_ladder
	name = "лестница Иакова"
	desc = "Небесная лестница, нарушающая законы физики."
	icon = 'icons/obj/structures.dmi'
	icon_state = "ladder00"

/obj/item/jacobs_ladder/attack_self(mob/user)
	var/turf/T = get_turf(src)
	var/ladder_x = T.x
	var/ladder_y = T.y
	to_chat(user, span_notice("Разворачиваю лестницу. Она простирается гораздо дальше, чем я ожидал"))
	var/last_ladder = null
	for(var/i in 1 to world.maxz)
		if(is_centcom_level(i) || is_reserved_level(i) || is_away_level(i))
			continue
		var/turf/T2 = locate(ladder_x, ladder_y, i)
		last_ladder = new /obj/structure/ladder/unbreakable/jacob(T2, null, last_ladder)
	qdel(src)

// Inherit from unbreakable but don't set ID, to suppress the default Z linkage
/obj/structure/ladder/unbreakable/jacob
	name = "лестница Иакова"
	desc = "Неразрушимая небесная лестница, нарушающая законы физики."

//Concussive Gauntlets
/obj/item/clothing/gloves/gauntlets
	name = "сотрясающие перчатки"
	desc = "Отбойный молоток в форме перчаток для быстрой добычи полезных ископаемых без необходимости держать в руках инструменты."
	icon_state = "concussive_gauntlets"
	inhand_icon_state = null
	toolspeed = 0.1
	strip_delay = 40
	equip_delay_other = 20
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_TEMP_PROTECT
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_TEMP_PROTECT
	resistance_flags = LAVA_PROOF | FIRE_PROOF //they are from lavaland after all
	armor_type = /datum/armor/gloves_gauntlets

/datum/armor/gloves_gauntlets
	melee = 15
	bullet = 25
	laser = 15
	energy = 15
	bomb = 100
	fire = 100
	acid = 30

/obj/item/clothing/gloves/gauntlets/equipped(mob/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_GLOVES)
		tool_behaviour = TOOL_MINING
		RegisterSignal(user, COMSIG_LIVING_UNARMED_ATTACK, PROC_REF(rocksmash))
		RegisterSignal(user, COMSIG_MOVABLE_BUMP, PROC_REF(rocksmash))
	else
		stopmining(user)

/obj/item/clothing/gloves/gauntlets/dropped(mob/user)
	. = ..()
	stopmining(user)

/obj/item/clothing/gloves/gauntlets/proc/stopmining(mob/user)
	tool_behaviour = initial(tool_behaviour)
	UnregisterSignal(user, COMSIG_LIVING_UNARMED_ATTACK)
	UnregisterSignal(user, COMSIG_MOVABLE_BUMP)

/obj/item/clothing/gloves/gauntlets/proc/rocksmash(mob/living/carbon/human/user, atom/rocks, proximity)
	SIGNAL_HANDLER
	if(!proximity)
		return NONE
	if(!ismineralturf(rocks) && !isasteroidturf(rocks))
		return NONE
	rocks.attackby(src, user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/item/clothing/suit/hooded/berserker
	name = "броня берсерка"
	desc = "Голоса исходящие от скафандра, способны свести пользователя с ума, вогнав в кровавое безумие."
	icon_state = "berserker"
	icon = 'icons/obj/clothing/suits/armor.dmi'
	worn_icon = 'icons/mob/clothing/suits/armor.dmi'
	hoodtype = /obj/item/clothing/head/hooded/berserker
	armor_type = /datum/armor/hooded_berserker
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	resistance_flags = FIRE_PROOF
	clothing_flags = THICKMATERIAL
	allowed = list(
		/obj/item/flashlight,
		/obj/item/tank/internals,
		/obj/item/pickaxe,
		/obj/item/spear,
		/obj/item/organ/internal/monster_core,
		/obj/item/knife,
		/obj/item/kinetic_crusher,
		/obj/item/resonator,
		/obj/item/melee/cleaving_saw,
	)

/datum/armor/hooded_berserker
	melee = 30
	bullet = 30
	laser = 10
	energy = 20
	bomb = 50
	fire = 100
	acid = 100

/obj/item/clothing/suit/hooded/berserker/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, ALL, inventory_flags = ITEM_SLOT_OCLOTHING)

#define MAX_BERSERK_CHARGE 100
#define PROJECTILE_HIT_MULTIPLIER 1.5
#define DAMAGE_TO_CHARGE_SCALE 0.75
#define CHARGE_DRAINED_PER_SECOND 5
#define BERSERK_MELEE_ARMOR_ADDED 50
#define BERSERK_ATTACK_SPEED_MODIFIER 0.25

/obj/item/clothing/head/hooded/berserker
	name = "шлем берсерка"
	desc = "Даже если смотреть в глаза этому шлему, быстро начинаешь осознавать свою ничтожность."
	icon_state = "berserker"
	icon = 'icons/obj/clothing/head/helmet.dmi'
	worn_icon = 'icons/mob/clothing/head/helmet.dmi'
	armor_type = /datum/armor/hooded_berserker
	actions_types = list(/datum/action/item_action/berserk_mode)
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF
	clothing_flags = SNUG_FIT|THICKMATERIAL
	/// Current charge of berserk, goes from 0 to 100
	var/berserk_charge = 0
	/// Status of berserk
	var/berserk_active = FALSE

/obj/item/clothing/head/hooded/berserker/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, LOCKED_HELMET_TRAIT)

/obj/item/clothing/head/hooded/berserker/examine()
	. = ..()
	. += span_notice("<hr>Заряд берсерка [berserk_charge]%.")

/obj/item/clothing/head/hooded/berserker/process(seconds_per_tick)
	if(berserk_active)
		berserk_charge = clamp(berserk_charge - CHARGE_DRAINED_PER_SECOND * seconds_per_tick, 0, MAX_BERSERK_CHARGE)
	if(!berserk_charge)
		if(ishuman(loc))
			end_berserk(loc)

/obj/item/clothing/head/hooded/berserker/dropped(mob/user)
	. = ..()
	end_berserk(user)

/obj/item/clothing/head/hooded/berserker/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(berserk_active)
		return
	var/berserk_value = damage * DAMAGE_TO_CHARGE_SCALE
	if(attack_type == PROJECTILE_ATTACK)
		berserk_value *= PROJECTILE_HIT_MULTIPLIER
	berserk_charge = clamp(round(berserk_charge + berserk_value), 0, MAX_BERSERK_CHARGE)
	if(berserk_charge >= MAX_BERSERK_CHARGE)
		to_chat(owner, span_notice("Режим берсерка заряжен."))
		balloon_alert(owner, "берсерк готов")

/obj/item/clothing/head/hooded/berserker/IsReflect()
	if(berserk_active)
		return TRUE

/// Starts berserk, giving the wearer 50 melee armor, doubled attacking speed, NOGUNS trait, adding a color and giving them the berserk movespeed modifier
/obj/item/clothing/head/hooded/berserker/proc/berserk_mode(mob/living/carbon/human/user)
	to_chat(user, span_warning("ВХОЖУ В РЕЖИМ БЕРСЕРКА!"))
	playsound(user, 'sound/magic/staff_healing.ogg', 50)
	user.add_movespeed_modifier(/datum/movespeed_modifier/berserk)
	user.physiology.armor = user.physiology.armor.generate_new_with_modifiers(list(MELEE = BERSERK_MELEE_ARMOR_ADDED))
	user.next_move_modifier *= BERSERK_ATTACK_SPEED_MODIFIER
	user.add_atom_colour(COLOR_BUBBLEGUM_RED, TEMPORARY_COLOUR_PRIORITY)
	ADD_TRAIT(user, TRAIT_NOGUNS, BERSERK_TRAIT)
	ADD_TRAIT(src, TRAIT_NODROP, BERSERK_TRAIT)
	berserk_active = TRUE
	START_PROCESSING(SSobj, src)

/// Ends berserk, reverting the changes from the proc [berserk_mode]
/obj/item/clothing/head/hooded/berserker/proc/end_berserk(mob/living/carbon/human/user)
	if(!berserk_active)
		return
	berserk_active = FALSE
	if(QDELETED(user))
		return
	to_chat(user, span_warning("Выхожу из режима берсерка."))
	playsound(user, 'sound/magic/summonitems_generic.ogg', 50)
	user.remove_movespeed_modifier(/datum/movespeed_modifier/berserk)
	user.physiology.armor = user.physiology.armor.generate_new_with_modifiers(list(MELEE = -BERSERK_MELEE_ARMOR_ADDED))
	user.next_move_modifier /= BERSERK_ATTACK_SPEED_MODIFIER
	user.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, COLOR_BUBBLEGUM_RED)
	REMOVE_TRAIT(user, TRAIT_NOGUNS, BERSERK_TRAIT)
	REMOVE_TRAIT(src, TRAIT_NODROP, BERSERK_TRAIT)
	STOP_PROCESSING(SSobj, src)

#undef MAX_BERSERK_CHARGE
#undef PROJECTILE_HIT_MULTIPLIER
#undef DAMAGE_TO_CHARGE_SCALE
#undef CHARGE_DRAINED_PER_SECOND
#undef BERSERK_MELEE_ARMOR_ADDED
#undef BERSERK_ATTACK_SPEED_MODIFIER

/obj/item/clothing/glasses/godeye
	name = "глаз бога"
	desc = "Странное око. Говорят, что оно было вырвано из всеведущего существа, которое когда-то бродило по пустоши."
	icon_state = "godeye"
	inhand_icon_state = null
	vision_flags = SEE_TURFS
	// Blue, light blue
	color_cutoffs = list(15, 30, 40)
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	custom_materials = null
	var/datum/action/cooldown/scan/scan_ability

/obj/item/clothing/glasses/godeye/Initialize(mapload)
	. = ..()
	scan_ability = new(src)

/obj/item/clothing/glasses/godeye/Destroy()
	QDEL_NULL(scan_ability)
	return ..()

/obj/item/clothing/glasses/godeye/equipped(mob/living/user, slot)
	. = ..()
	if(ishuman(user) && (slot & ITEM_SLOT_EYES))
		ADD_TRAIT(src, TRAIT_NODROP, EYE_OF_GOD_TRAIT)
		pain(user)
		scan_ability.Grant(user)

/obj/item/clothing/glasses/godeye/dropped(mob/living/user)
	. = ..()
	// Behead someone, their "glasses" drop on the floor
	// and thus, the god eye should no longer be sticky
	REMOVE_TRAIT(src, TRAIT_NODROP, EYE_OF_GOD_TRAIT)
	// And remove the scan ability, note that if we're being called from Destroy
	// that this may already be nulled and removed
	scan_ability?.Remove(user)

/obj/item/clothing/glasses/godeye/proc/pain(mob/living/victim)
	to_chat(victim, span_userdanger("Чувствую острую боль, когда [src] врывается в мой череп."))
	victim.emote("scream")
	victim.flash_act()

/datum/action/cooldown/scan
	name = "Сканировать"
	desc = "Просканируйте противника, чтобы получить его местоположение и ошеломить его, увеличив время между атаками."
	background_icon_state = "bg_clock"
	overlay_icon_state = "bg_clock_border"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "scan"

	click_to_activate = TRUE
	cooldown_time = 45 SECONDS
	ranged_mousepointer = 'icons/effects/mouse_pointers/scan_target.dmi'

/datum/action/cooldown/scan/IsAvailable(feedback = FALSE)
	return ..() && isliving(owner)

/datum/action/cooldown/scan/Activate(atom/scanned)
	StartCooldown(15 SECONDS)

	if(owner.stat != CONSCIOUS)
		return FALSE
	if(!isliving(scanned) || scanned == owner)
		owner.balloon_alert(owner, "неверная цель!")
		return FALSE

	var/mob/living/living_owner = owner
	var/mob/living/living_scanned = scanned
	living_scanned.apply_status_effect(/datum/status_effect/stagger)
	var/datum/status_effect/agent_pinpointer/scan_pinpointer = living_owner.apply_status_effect(/datum/status_effect/agent_pinpointer/scan)
	scan_pinpointer.scan_target = living_scanned

	living_scanned.set_jitter_if_lower(100 SECONDS)
	to_chat(living_scanned, span_warning("Меня трясёт!"))
	living_scanned.add_filter("scan", 2, list("type" = "outline", "color" = COLOR_YELLOW, "size" = 1))
	addtimer(CALLBACK(living_scanned, TYPE_PROC_REF(/datum, remove_filter), "scan"), 30 SECONDS)

	owner.playsound_local(get_turf(owner), 'sound/magic/smoke.ogg', 50, TRUE)
	owner.balloon_alert(owner, "сканирую [living_scanned]")
	addtimer(CALLBACK(src, PROC_REF(send_cooldown_end_message), cooldown_time))

	StartCooldown()
	return TRUE

/datum/action/cooldown/scan/proc/send_cooldown_end_message()
	owner?.balloon_alert(owner, "сканирование готово")

/datum/status_effect/agent_pinpointer/scan
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/agent_pinpointer/scan
	tick_interval = 2 SECONDS
	range_fuzz_factor = 0
	minimum_range = 1
	range_mid = 5
	range_far = 15

/datum/status_effect/agent_pinpointer/scan/scan_for_target()
	return

/atom/movable/screen/alert/status_effect/agent_pinpointer/scan
	name = "Сканировать цель"

/obj/item/organ/internal/cyberimp/arm/shard
	name = "dark spoon shard"
	desc = "An eerie metal shard surrounded by dark energies...of soup drinking. You probably don't think you should have been able to find this."
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "cursed_katana_organ"
	organ_flags = ORGAN_ORGANIC | ORGAN_FROZEN | ORGAN_UNREMOVABLE
	items_to_create = list(/obj/item/kitchen/spoon)
	extend_sound = 'sound/items/unsheath.ogg'
	retract_sound = 'sound/items/sheath.ogg'

/obj/item/organ/internal/cyberimp/arm/shard/attack_self(mob/user, modifiers)
	. = ..()
	to_chat(user, span_userdanger("The mass goes up your arm and goes inside it!"))
	playsound(user, 'sound/magic/demon_consume.ogg', 50, TRUE)
	var/index = user.get_held_index_of_item(src)
	zone = (index == LEFT_HANDS ? BODY_ZONE_L_ARM : BODY_ZONE_R_ARM)
	SetSlotFromZone()
	user.temporarilyRemoveItemFromInventory(src, TRUE)
	Insert(user)

/obj/item/organ/internal/cyberimp/arm/shard/screwdriver_act(mob/living/user, obj/item/screwtool)
	return

/obj/item/organ/internal/cyberimp/arm/shard/katana
	name = "проклятый осколок"
	desc = "Жуткий металлический осколок."
	items_to_create = list(/obj/item/cursed_katana)

/obj/item/organ/internal/cyberimp/arm/shard/katana/Retract()
	var/obj/item/cursed_katana/katana = active_item
	if(!katana || katana.shattered)
		return FALSE
	if(!katana.drew_blood)
		to_chat(owner, span_userdanger("[katana] вырывается из моей плоти!"))
		playsound(owner, 'sound/magic/demon_attack1.ogg', 50, TRUE)
		var/obj/item/bodypart/part = owner.get_holding_bodypart_of_item(katana)
		if(part)
			part.receive_damage(brute = 25, wound_bonus = 10, sharpness = SHARP_EDGED)
	katana.drew_blood = FALSE
	katana.wash(CLEAN_TYPE_BLOOD)
	return ..()

#define ATTACK_STRIKE "Hilt Strike"
#define ATTACK_SLICE "Wide Slice"
#define ATTACK_DASH "Dash Attack"
#define ATTACK_CUT "Tendon Cut"
#define ATTACK_CLOAK "Dark Cloak"
#define ATTACK_SHATTER "Shatter"

/obj/item/cursed_katana
	name = "проклятая катана"
	desc = "Катана, использованная для запечатывания чего-то зловещего давным-давно. \
	Даже после уничтожения оружия все части, содержащие существо, снова собрались вместе, чтобы найти нового хозяина."
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "cursed_katana"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 15
	armour_penetration = 30
	block_chance = 30
	block_sound = 'sound/weapons/parry.ogg'
	sharpness = SHARP_EDGED
	w_class = WEIGHT_CLASS_HUGE
	attack_verb_continuous = list("атакует", "разрезает", "колет", "режет", "рвет", "разрывает", "нарезает")
	attack_verb_simple = list("атакует", "разрезает", "колет", "режет", "рвет", "разрывает", "нарезает")
	hitsound = 'sound/weapons/bladeslice.ogg'
	resistance_flags = LAVA_PROOF | FIRE_PROOF | UNACIDABLE | FREEZE_PROOF
	var/shattered = FALSE
	var/drew_blood = FALSE
	var/static/list/combo_list = list(
		ATTACK_STRIKE = list(COMBO_STEPS = list(LEFT_ATTACK, LEFT_ATTACK, RIGHT_ATTACK), COMBO_PROC = PROC_REF(strike)),
		ATTACK_SLICE = list(COMBO_STEPS = list(RIGHT_ATTACK, LEFT_ATTACK, LEFT_ATTACK), COMBO_PROC = PROC_REF(slice)),
		ATTACK_DASH = list(COMBO_STEPS = list(LEFT_ATTACK, RIGHT_ATTACK, RIGHT_ATTACK), COMBO_PROC = PROC_REF(dash)),
		ATTACK_CUT = list(COMBO_STEPS = list(RIGHT_ATTACK, RIGHT_ATTACK, LEFT_ATTACK), COMBO_PROC = PROC_REF(cut)),
		ATTACK_CLOAK = list(COMBO_STEPS = list(LEFT_ATTACK, RIGHT_ATTACK, LEFT_ATTACK, RIGHT_ATTACK), COMBO_PROC = PROC_REF(cloak)),
		ATTACK_SHATTER = list(COMBO_STEPS = list(RIGHT_ATTACK, LEFT_ATTACK, RIGHT_ATTACK, LEFT_ATTACK), COMBO_PROC = PROC_REF(shatter)),
	)

/obj/item/cursed_katana/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/combo_attacks, \
		combos = combo_list, \
		max_combo_length = 4, \
		examine_message = span_notice("<i>Кажется, на ней есть надписи... надо рассмотреть получше...</i>"), \
		reset_message = "you return to neutral stance", \
		can_attack_callback = CALLBACK(src, PROC_REF(can_combo_attack)) \
	)

/obj/item/cursed_katana/examine(mob/user)
	. = ..()
	. += drew_blood ? span_nicegreen("It's sated... for now.") : span_danger("It will not be sated until it tastes blood.")

/obj/item/cursed_katana/dropped(mob/user)
	. = ..()
	if(isturf(loc))
		qdel(src)

/obj/item/cursed_katana/attack(mob/living/target, mob/user, click_parameters)
	if(target.stat < DEAD && target != user)
		drew_blood = TRUE
		if(ismining(target))
			user.changeNext_move(CLICK_CD_RAPID)
	return ..()

/obj/item/cursed_katana/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK, damage_type = BRUTE)
	if(attack_type == PROJECTILE_ATTACK)
		final_block_chance = 0 //Don't bring a sword to a gunfight
	return ..()

/obj/item/cursed_katana/proc/can_combo_attack(mob/user, mob/living/target)
	return target.stat != DEAD && target != user

/obj/item/cursed_katana/proc/strike(mob/living/target, mob/user)
	user.visible_message(span_warning("[user] strikes [target] with [src]'s hilt!"),
		span_notice("You hilt strike [target]!"))
	to_chat(target, span_userdanger("You've been struck by [user]!"))
	playsound(src, 'sound/weapons/genhit3.ogg', 50, TRUE)
	RegisterSignal(target, COMSIG_MOVABLE_IMPACT, PROC_REF(strike_throw_impact))
	var/atom/throw_target = get_edge_target_turf(target, user.dir)
	target.throw_at(throw_target, 5, 3, user, FALSE, gentle = TRUE)
	target.apply_damage(damage = 17, bare_wound_bonus = 10)
	to_chat(target, span_userdanger("You've been struck by [user]!"))
	user.do_attack_animation(target, ATTACK_EFFECT_PUNCH)

/obj/item/cursed_katana/proc/strike_throw_impact(mob/living/source, atom/hit_atom, datum/thrownthing/thrownthing)
	SIGNAL_HANDLER

	UnregisterSignal(source, COMSIG_MOVABLE_IMPACT)
	if(isclosedturf(hit_atom))
		source.apply_damage(damage = 5)
		if(ishostile(source))
			var/mob/living/simple_animal/hostile/target = source
			target.ranged_cooldown += 5 SECONDS
		else if(iscarbon(source))
			var/mob/living/carbon/target = source
			target.set_confusion_if_lower(8 SECONDS)
	return NONE

/obj/item/cursed_katana/proc/slice(mob/living/target, mob/user)
	user.visible_message(span_warning("[user] does a wide slice!"),
		span_notice("You do a wide slice!"))
	playsound(src, 'sound/weapons/bladeslice.ogg', 50, TRUE)
	var/turf/user_turf = get_turf(user)
	var/dir_to_target = get_dir(user_turf, get_turf(target))
	var/static/list/cursed_katana_slice_angles = list(0, -45, 45, -90, 90) //so that the animation animates towards the target clicked and not towards a side target
	for(var/iteration in cursed_katana_slice_angles)
		var/turf/turf = get_step(user_turf, turn(dir_to_target, iteration))
		user.do_attack_animation(turf, ATTACK_EFFECT_SLASH)
		for(var/mob/living/additional_target in turf)
			if(user.Adjacent(additional_target) && additional_target.density)
				additional_target.apply_damage(damage = 15, sharpness = SHARP_EDGED, bare_wound_bonus = 10)
				to_chat(additional_target, span_userdanger("You've been sliced by [user]!"))
	target.apply_damage(damage = 5, sharpness = SHARP_EDGED, wound_bonus = 10)

/obj/item/cursed_katana/proc/cloak(mob/living/target, mob/user)
	user.alpha = 150
	user.SetInvisibility(INVISIBILITY_OBSERVER, id=type) // so hostile mobs cant see us or target us
	user.add_sight(SEE_SELF) // so we can see us
	user.visible_message(span_warning("[user] vanishes into thin air!"),
		span_notice("You enter the dark cloak."))
	new /obj/effect/temp_visual/mook_dust(get_turf(src))
	playsound(src, 'sound/magic/smoke.ogg', 50, TRUE)
	if(ishostile(target))
		var/mob/living/simple_animal/hostile/hostile_target = target
		if(hostile_target.target == user)
			hostile_target.LoseTarget()
	addtimer(CALLBACK(src, PROC_REF(uncloak), user), 5 SECONDS, TIMER_UNIQUE)

/obj/item/cursed_katana/proc/uncloak(mob/user)
	user.alpha = 255
	user.RemoveInvisibility(type)
	user.clear_sight(SEE_SELF)
	user.visible_message(span_warning("[user] appears from thin air!"),
		span_notice("You exit the dark cloak."))
	playsound(src, 'sound/magic/summonitems_generic.ogg', 50, TRUE)
	new /obj/effect/temp_visual/mook_dust(get_turf(src))

/obj/item/cursed_katana/proc/cut(mob/living/target, mob/user)
	user.visible_message(span_warning("[user] cuts [target]'s tendons!"),
		span_notice("You tendon cut [target]!"))
	to_chat(target, span_userdanger("Your tendons have been cut by [user]!"))
	target.apply_damage(damage = 15, sharpness = SHARP_EDGED, wound_bonus = 15)
	user.do_attack_animation(target, ATTACK_EFFECT_DISARM)
	playsound(src, 'sound/weapons/rapierhit.ogg', 50, TRUE)
	var/datum/status_effect/stacking/saw_bleed/bloodletting/status = target.has_status_effect(/datum/status_effect/stacking/saw_bleed/bloodletting)
	if(!status)
		target.apply_status_effect(/datum/status_effect/stacking/saw_bleed/bloodletting, 6)
	else
		status.add_stacks(6)

/obj/item/cursed_katana/proc/dash(mob/living/target, mob/user)
	user.visible_message(span_warning("[user] dashes through [target]!"),
		span_notice("You dash through [target]!"))
	to_chat(target, span_userdanger("[user] dashes through you!"))
	playsound(src, 'sound/magic/blink.ogg', 50, TRUE)
	target.apply_damage(damage = 17, sharpness = SHARP_POINTY, bare_wound_bonus = 10)
	var/turf/dash_target = get_turf(target)
	for(var/distance in 0 to 8)
		var/turf/current_dash_target = dash_target
		current_dash_target = get_step(current_dash_target, user.dir)
		if(!current_dash_target.is_blocked_turf(TRUE))
			dash_target = current_dash_target
		else
			break
	new /obj/effect/temp_visual/guardian/phase/out(get_turf(user))
	new /obj/effect/temp_visual/guardian/phase(dash_target)
	do_teleport(user, dash_target, channel = TELEPORT_CHANNEL_MAGIC)

/obj/item/cursed_katana/proc/shatter(mob/living/target, mob/user)
	user.visible_message(span_warning("[user] shatters [src] over [target]!"),
		span_notice("You shatter [src] over [target]!"))
	to_chat(target, span_userdanger("[user] shatters [src] over you!"))
	target.apply_damage(damage = ishostile(target) ? 75 : 35, wound_bonus = 20)
	user.do_attack_animation(target, ATTACK_EFFECT_SMASH)
	playsound(src, 'sound/effects/glassbr3.ogg', 100, TRUE)
	shattered = TRUE
	moveToNullspace()
	balloon_alert(user, "katana shattered")
	addtimer(CALLBACK(src, PROC_REF(coagulate), user), 45 SECONDS)

/obj/item/cursed_katana/proc/coagulate(mob/user)
	balloon_alert(user, "katana coagulated")
	shattered = FALSE
	playsound(src, 'sound/magic/demon_consume.ogg', 50, TRUE)

#undef ATTACK_STRIKE
#undef ATTACK_SLICE
#undef ATTACK_DASH
#undef ATTACK_CUT
#undef ATTACK_CLOAK
#undef ATTACK_SHATTER
