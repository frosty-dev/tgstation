// возвращает вариативную приставку или ничего
/proc/gvorno(capitalize = FALSE, chance = 100)
	if(!prob(chance))
		return
	var/to_ret = pick("невероятно", "удивительно", "немыслимо", "красиво", "наверняка", "скорее всего", "превосходно", "иронично", "прикольно")

	if(capitalize)
		return capitalize(to_ret)
	else
		return to_ret
