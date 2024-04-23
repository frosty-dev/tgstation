/obj/item/organ/internal/cyberimp/eyes
	name = "кибернетические импланты глаз"
	desc = "Импланты для ваших глаз."
	icon_state = "eye_implant"
	implant_overlay = "eye_implant_overlay"
	slot = ORGAN_SLOT_EYES
	zone = BODY_ZONE_PRECISE_EYES
	w_class = WEIGHT_CLASS_TINY

// HUD implants
/obj/item/organ/internal/cyberimp/eyes/hud
	name = "имплант интерфейса"
	desc = "Эти кибернетические глаза выведут интерфейс поверх всего что вы видите. Наверное."
	slot = ORGAN_SLOT_HUD
	var/HUD_type = 0
	var/HUD_trait = null

/obj/item/organ/internal/cyberimp/eyes/hud/Insert(mob/living/carbon/eye_owner, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(!.)
		return
	if(HUD_type)
		var/datum/atom_hud/hud = GLOB.huds[HUD_type]
		hud.show_to(eye_owner)
	if(HUD_trait)
		ADD_TRAIT(eye_owner, HUD_trait, ORGAN_TRAIT)

/obj/item/organ/internal/cyberimp/eyes/hud/Remove(mob/living/carbon/eye_owner, special = FALSE)
	. = ..()
	if(HUD_type)
		var/datum/atom_hud/hud = GLOB.huds[HUD_type]
		hud.hide_from(eye_owner)
	if(HUD_trait)
		REMOVE_TRAIT(eye_owner, HUD_trait, ORGAN_TRAIT)

/obj/item/organ/internal/cyberimp/eyes/hud/medical
	name = "имплант медицинского интерфейса"
	desc = "Эти кибернетические глаза выведут медицинский интерфейс поверх всего что вы видите."
	HUD_type = DATA_HUD_MEDICAL_ADVANCED
	HUD_trait = TRAIT_MEDICAL_HUD

/obj/item/organ/internal/cyberimp/eyes/hud/security
	name = "имплант интерфейса службы безопасности"
	desc = "Эти кибернетические глаза выведут интерфейс службы безопасности поверх всего что вы видите."
	HUD_type = DATA_HUD_SECURITY_ADVANCED
	HUD_trait = TRAIT_SECURITY_HUD

/obj/item/organ/internal/cyberimp/eyes/hud/diagnostic
	name = "имплант интерфейса диагностики"
	desc = "Эти кибернетические глаза выведут интерфейс диагностики поверх всего что вы видите."
	HUD_type = DATA_HUD_DIAGNOSTIC_ADVANCED

/obj/item/organ/internal/cyberimp/eyes/hud/security/syndicate
	name = "контрабандный имплант интерфейса службы безопасности"
	desc = "Интерфейс службы безопасности от КиберСан Индастриз. Эти нелегальные кибернетические глаза выведут интерфейс службы безопасности поверх всего что вы видите"
	organ_flags = ORGAN_ROBOTIC | ORGAN_HIDDEN
