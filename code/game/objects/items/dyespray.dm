/obj/item/dyespray
	name = "краска для волос"
	desc = "Можно покрасить волосы во всякие цвета."
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/obj/cosmetic.dmi'
	icon_state = "dyespray"

/obj/item/dyespray/attack_self(mob/user)
	dye(user, user)

/obj/item/dyespray/pre_attack(atom/target, mob/living/user, params)
	dye(target, user)
	return ..()

/**
 * Applies a gradient and a gradient color to a mob.
 *
 * Arguments:
 * * target - The mob who we will apply the gradient and gradient color to.
 */

/obj/item/dyespray/proc/dye(mob/target, mob/user)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/human_target = target
	var/beard_or_hair = tgui_alert(user, "Что будем красить?", "Краска", list("Волосы", "Бороду"))
	if(!beard_or_hair || !user.can_perform_action(src, NEED_DEXTERITY))
		return

	var/list/choices = beard_or_hair == "Волосы" ? GLOB.hair_gradients_list : GLOB.facial_hair_gradients_list
	var/new_grad_style = tgui_input_list(user, "Выберем шаблон:", "Краска", choices)
	if(isnull(new_grad_style))
		return
	if(!user.can_perform_action(src, NEED_DEXTERITY))
		return

	var/new_grad_color = input(user, "Выберем цвет:", "Краска",human_target.grad_color) as color|null
	if(!new_grad_color || !user.can_perform_action(src, NEED_DEXTERITY) || !user.CanReach(target))
		return

	to_chat(user, span_notice("Начинаю красить [lowertext(beard_or_hair)]..."))
	if(!do_after(user, 3 SECONDS, target))
		return
	if(beard_or_hair == "Волосы")
		human_target.set_hair_gradient_style(new_grad_style, update = FALSE)
		human_target.set_hair_gradient_color(new_grad_color, update = TRUE)
	else
		human_target.set_facial_hair_gradient_style(new_grad_style, update = FALSE)
		human_target.set_facial_hair_gradient_color(new_grad_color, update = TRUE)
	playsound(src, 'sound/effects/spray.ogg', 10, vary = TRUE)
