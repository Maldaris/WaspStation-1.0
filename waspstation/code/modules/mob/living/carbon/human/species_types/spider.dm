GLOBAL_LIST_INIT(spider_first, world.file2list("strings/names/spider_first.txt"))
GLOBAL_LIST_INIT(spider_last, world.file2list("strings/names/spider_last.txt"))

/obj/item/organ/eyes/night_vision/spider
	name = "spider eyes"
	desc = "These eyes seem to have increased sensitivity to bright light, offset by basic night vision."
	flash_protect = FLASH_PROTECTION_SENSITIVE

/datum/species/spider
	name = "Spiderperson"
	id = "spider"
	say_mod = "chitters"
	default_color = "00FF00"
	species_traits = list(LIPS, NOEYESPRITES)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	mutant_bodyparts = list("spider_legs", "spider_spinneret")
	default_features = list("F" = "Plain", "spider_spinneret" = "Plain")
	attack_verb = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	meat = /obj/item/reagent_containers/food/snacks/meat/slab/human/mutant/spider
	liked_food = MEAT | RAW | GROSS
	disliked_food = FRUIT
	toxic_food = VEGETABLES | DAIRY | CLOTH
	mutanteyes = /obj/item/organ/eyes/night_vision/spider
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/spider
	loreblurb = ""

/datum/species/spider/regenerate_organs(mob/living/carbon/C,datum/species/old_species,replace_current=TRUE,list/excluded_zones)
	. = ..()
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		handle_mutant_bodyparts(H)

/proc/random_unique_spider_name(attempts_to_find_unique_name=10)
	for(var/i in 1 to attempts_to_find_unique_name)
		. = capitalize(pick(GLOB.spider_first)) + " " + capitalize(pick(GLOB.spider_last))

		if(!findname(.))
			break

/proc/spider_name()
	return "[pick(GLOB.spider_first)] [pick(GLOB.spider_last)]"

/datum/species/spider/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_spider_name()

	var/randname = spider_name()

	if(lastname)
		randname += " [lastname]"

	return randname

/datum/species/spider/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/H)
	. = ..()
	if(chem.type == /datum/reagent/toxin/pestkiller)
		H.adjustToxLoss(3)
		H.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM)

/datum/species/spider/check_species_weakness(obj/item/weapon, mob/living/attacker)
	if(istype(weapon, /obj/item/melee/flyswatter))
		return 9 //flyswatters deal 10x damage to spiders
	return 0

/datum/species/spider/on_species_gain(mob/living/carbon/human/H, datum/species/old_species)
	. = ..()
	var/datum/action/innate/change_color/S = new
	S.Grant(H)

/datum/species/spider/on_species_loss(mob/living/carbon/human/H)
	. = ..()
	var/datum/action/innate/spin_web/S = locate(/datum/action/innate/spin_web) in H.actions
	S?.Remove(H)

/datum/action/innate/spin_web
    name = "Spin Web"
    check_flags = AB_CHECK_CONSCIOUS
    icon_icon = 'icons/mob/actions.dmi'
    button_icon_state = "spider"

/datum/action/innate/spin_web/Activate()
    // TODO: implement this
    to_chat(usr, "<span class='danger'>Your spinneret is a bit dry at the moment.</span>")
