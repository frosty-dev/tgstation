/obj/item/organ/internal/ears
	name = "уши"
	icon_state = "ears"
	desc = "Ухо состоит из трех частей. Внутренний, средний и внешний. Обычно должна быть видна только одна из этих частей."
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EARS
	visual = FALSE
	gender = PLURAL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = span_info("Слышу лёгкий звон в ушах.")
	now_failing = span_warning("Ничего не слышу!")
	now_fixed = span_info("Шум снова медленно начинает наполнять мои уши.")
	low_threshold_cleared = span_info("Звон в ушах утих.")

	// `deaf` measures "ticks" of deafness. While > 0, the person is unable
	// to hear anything.
	var/deaf = 0

	// `damage` in this case measures long term damage to the ears, if too high,
	// the person will not have either `deaf` or `ear_damage` decrease
	// without external aid (earmuffs, drugs)

	//Resistance against loud noises
	var/bang_protect = 0
	// Multiplier for both long term and short term ear damage
	var/damage_multiplier = 1

/obj/item/organ/internal/ears/on_life(seconds_per_tick, times_fired)
	// only inform when things got worse, needs to happen before we heal
	if((damage > low_threshold && prev_damage < low_threshold) || (damage > high_threshold && prev_damage < high_threshold))
		to_chat(owner, span_warning("Звон в ушах становится громче, на мгновение заглушая любые внешние шумы."))

	. = ..()
	// if we have non-damage related deafness like mutations, quirks or clothing (earmuffs), don't bother processing here. Ear healing from earmuffs or chems happen elsewhere
	if(HAS_TRAIT_NOT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE))
		return

	if((organ_flags & ORGAN_FAILING))
		deaf = max(deaf, 1) // if we're failing we always have at least 1 deaf stack (and thus deafness)
	else // only clear deaf stacks if we're not failing
		deaf = max(deaf - (0.5 * seconds_per_tick), 0)
		if((damage > low_threshold) && SPT_PROB(damage / 60, seconds_per_tick))
			adjustEarDamage(0, 4)
			SEND_SOUND(owner, sound('sound/weapons/flash_ring.ogg'))

	if(deaf)
		ADD_TRAIT(owner, TRAIT_DEAF, EAR_DAMAGE)
	else
		REMOVE_TRAIT(owner, TRAIT_DEAF, EAR_DAMAGE)

/obj/item/organ/internal/ears/proc/adjustEarDamage(ddmg, ddeaf)
	if(owner.status_flags & GODMODE)
		return
	set_organ_damage(clamp(damage + (ddmg * damage_multiplier), 0, maxHealth))
	deaf = max(deaf + (ddeaf * damage_multiplier), 0)

/obj/item/organ/internal/ears/invincible
	damage_multiplier = 0

/obj/item/organ/internal/ears/cat
	name = "котоушки"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "kitty"
	visual = TRUE
	damage_multiplier = 2

/obj/item/organ/internal/ears/cat/on_insert(mob/living/carbon/human/ear_owner)
	. = ..()
	if(istype(ear_owner) && ear_owner.dna)
		color = ear_owner.hair_color
		ear_owner.dna.features["ears"] = ear_owner.dna.species.mutant_bodyparts["ears"] = "Cat"
		ear_owner.dna.update_uf_block(DNA_EARS_BLOCK)
		ear_owner.update_body()

/obj/item/organ/internal/ears/cat/on_remove(mob/living/carbon/human/ear_owner)
	. = ..()
	if(istype(ear_owner) && ear_owner.dna)
		color = ear_owner.hair_color
		ear_owner.dna.species.mutant_bodyparts -= "ears"
		ear_owner.update_body()

/obj/item/organ/internal/ears/penguin
	name = "уши пингвина"
	desc = "Источник счастливых ног пингвина."

/obj/item/organ/internal/ears/penguin/on_insert(mob/living/carbon/human/ear_owner)
	. = ..()
	if(istype(ear_owner))
		to_chat(ear_owner, span_notice("Похоже я теряю умение балансировать на ногах!"))
		ear_owner.AddElement(/datum/element/waddling)

/obj/item/organ/internal/ears/penguin/on_remove(mob/living/carbon/human/ear_owner)
	. = ..()
	if(istype(ear_owner))
		to_chat(ear_owner, span_notice("Кажется меня больше не шатает."))
		ear_owner.RemoveElement(/datum/element/waddling)

/obj/item/organ/internal/ears/cybernetic
	name = "кибернетические уши"
	icon_state = "ears-c"
	desc = "Основной кибернетический орган, имитирующий работу ушей."
	damage_multiplier = 0.9
	organ_flags = ORGAN_ROBOTIC
	failing_desc = "seems to be broken."

/obj/item/organ/internal/ears/cybernetic/upgraded
	name = "продвинутые кибернетические уши"
	icon_state = "ears-c-u"
	desc = "Усовершенствованное кибернетическое ухо, превосходящее по характеристикам обычные уши."
	damage_multiplier = 0.5


/obj/item/organ/internal/ears/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	apply_organ_damage(20 / severity)
