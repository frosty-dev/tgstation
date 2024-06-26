/obj/item/organ/internal/heart/gland/trauma
	abductor_hint = "white matter randomiser. The abductee occasionally gains a random brain trauma, up to five times. The traumas can range from basic to deep-rooted."
	cooldown_low = 800
	cooldown_high = 1200
	uses = 5
	icon_state = "emp"
	mind_control_uses = 3
	mind_control_duration = 1800

/obj/item/organ/internal/heart/gland/trauma/activate()
	to_chat(owner, span_warning("Чувствую острую боль в голове."))
	if(prob(33))
		owner.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, rand(TRAUMA_RESILIENCE_BASIC, TRAUMA_RESILIENCE_LOBOTOMY))
	else
		if(prob(20))
			owner.gain_trauma_type(BRAIN_TRAUMA_SEVERE, rand(TRAUMA_RESILIENCE_BASIC, TRAUMA_RESILIENCE_LOBOTOMY))
		else
			owner.gain_trauma_type(BRAIN_TRAUMA_MILD, rand(TRAUMA_RESILIENCE_BASIC, TRAUMA_RESILIENCE_LOBOTOMY))
