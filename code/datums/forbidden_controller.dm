#define CUM_LEVEL		100

#define ORAL_FEMALE		"oral=vagina"
#define ORAL_MALE		"oral=penis"

#define FUCK_ANUS		"fuck=anus"
#define FUCK_VAGINA		"fuck=vagina"
#define FUCK_MOUTH		"fuck=mouth"

/datum/forbidden_controller
	var/mob/living/carbon/human/owner
	var/pleasure = 0

	var/virgin = 1
	var/anal_virgin = 1

	var/penis_size = 0

	var/mob/living/carbon/human/fucked
	var/mob/living/carbon/human/fucking

	var/mob/living/carbon/human/fucking_list[]

	var/fucking_action = "none"
	var/fucked_action = "none"

	var/timevar
	var/click_time

	var/mob/living/carbon/human/source

/datum/forbidden_controller/New(mob/living/carbon/human/own)
	if(!istype(own))
		return
	owner = own
	if(owner.gender == MALE)
		penis_size = round(rand(5, 25))

/datum/forbidden_controller/proc/give_pleasure(base)
	pleasure += (base + rand(-1, 3))
	if(pleasure >= CUM_LEVEL)
		cum()

/datum/forbidden_controller/proc/fucked(mob/living/carbon/human/by, action)
	fucked_action = action
	fucked = by

	// Lose virginity
	if(virgin && action == FUCK_VAGINA && owner.gender == FEMALE)
		owner.emote("scream")
		new /obj/effect/decal/cleanable/blood(owner.loc)
		virgin = 0

	if(anal_virgin && action == FUCK_ANUS)
		anal_virgin = 0

	if(pleasure >= 70 && prob(15) && owner.gender == FEMALE)
		owner.visible_message("<span class='erp'><b>[owner]</b> twists in orgasm!</span>")

	if(pleasure >= 10 && prob(12))
		var/vr
		if(owner.gender == FEMALE)
			vr = pick("moans in pleasure", "moans")
		else
			vr = "moans"
		owner.visible_message("<span class='erp'><b>[owner]</b> [vr].</span>")

/datum/forbidden_controller/proc/fucking(mob/living/carbon/human/who, action)

	if(!istype(who) || !click_check() || !fucked_check(who, action))
		return 0

	who.erp_controller.time_check()

	who.erp_controller.timevar = world.time + 100
	click_time = world.time + 20 // 2 seconds delay between the actions

	fucking_action = action
	fucking = who

	who.erp_controller.fucked(owner, action)

	if(owner in who.erp_controller.fucking_list)
		fucking_text(action, who)
	else
		begins_text(action, who)
		who.erp_controller.fucking_list.Add(owner)
	return 1


/datum/forbidden_controller/proc/cum()
	var/pleasure_message = pick("... I'M FEELING SO GOOD! ...",  "... It's just INCREDIBLE! ...", "... MORE AND MORE AND MORE! ...")
	to_chat(owner, "<span class='cum'>[pleasure_message]</span>")
	cum_text()
	pleasure = 0

// Checks
/datum/forbidden_controller/proc/time_check()
	if(world.time > timevar)
		fucking_list = new /list()
		fucked = null
		fucked_action = "none"

/datum/forbidden_controller/proc/click_check()
	if(world.time >= click_time)
		return 1
	return 0

/datum/forbidden_controller/proc/fucked_check(mob/living/carbon/human/who, action)
	// 69
	if(!fucked || !fucked_action)
		return 1
	if((action == ORAL_MALE || action == ORAL_FEMALE) && (fucked_action == ORAL_MALE || fucked_action == ORAL_FEMALE))
		return 1
	if(findtext(fucked_action, "fuck="))
		return 0
	if(findtext(fucked_action, "oral=") && findtext(action, "fuck="))
		return 0
	return 1

/* Message Procs */

// Yama begins to suck Robertinhos's cock.
/datum/forbidden_controller/proc/begins_text(action, mob/living/carbon/human/who)
	// Oral messages
	if(action == ORAL_MALE)
		if(who.gender == MALE)
			owner.visible_message("<span class='erp'><b>[owner]</b> begins to suck [who]'s cock.</span>")
	else if(action == ORAL_FEMALE)
		if(who.gender == FEMALE)
			owner.visible_message("<span class='erp'><b>[owner]</b> begins to lick <b>[who]</b>.</span>")

	// Fuck messages
	else if(action == FUCK_ANUS)
		if(owner.gender == MALE)
			owner.visible_message("<span class='erp'><b>[owner]</b> begins to fuck [who]'s anus.</span>")
	else if(action == FUCK_VAGINA)
		if(owner.gender == MALE && who.gender == FEMALE)
			owner.visible_message("<span class='erp'><b>[owner]</b> begins to [pick("fuck","penetrate")] <b>[who]</b>.</span>")
	else if(action == FUCK_MOUTH)
		if(owner.gender == MALE)
			owner.visible_message("<span class='erp'><b>[owner]</b> begins to fuck [who]'s mouth.</span>")

// Yama fucks Robertinho's anus...
/datum/forbidden_controller/proc/fucking_text(action, mob/living/carbon/human/who)
	// Oral actions
	if(action == ORAL_MALE)
		if(who.gender == MALE)
			owner.visible_message("<span class='erp'><b>[owner]</b> sucks [who]'s cock.</span>")
	else if(action == ORAL_FEMALE)
		if(who.gender == FEMALE)
			owner.visible_message("<span class='erp'><b>[owner]</b> licks <b>[who]</b>.</span>")

	// Fuck actions
	else if(action == FUCK_ANUS)
		if(owner.gender == MALE)
			if(who.erp_controller.anal_virgin)
				owner.visible_message("<span class='erp'><b>[owner]</b> tears [who]'s anus to pieces.</span>")
			else
				owner.visible_message("<span class='erp'><b>[owner]</b> fucks [who]'s anus.</span>")
	else if(action == FUCK_VAGINA)
		if(owner.gender == MALE && who.gender == FEMALE)
			if(who.erp_controller.virgin)
				owner.visible_message("<span class='erp'><b>[owner]</b> mercilessly tears [who]'s hymen!</span>")
			else
				owner.visible_message("<span class='erp'><b>[owner]</b> [pick("fucks","penetrates")] <b>[who]</b>.</span>")
	else if(action == FUCK_MOUTH)
		if(owner.gender == MALE)
			owner.visible_message("<span class='erp'><b>[owner]</b> fucks [who]'s mouth.</span>")

// Yama cums into Robertinho!
/datum/forbidden_controller/proc/cum_text()
	if(owner.gender == MALE)
		if(fucking_action == FUCK_ANUS)
			owner.visible_message("<span class='cum'>[owner] cums into [fucking]'s ass!</span>")
		else if(fucking_action == FUCK_VAGINA)
			owner.visible_message("<span class='cum'>[owner] cums into <b>[fucking]</b>!</span>")
		else if(fucking_action == FUCK_MOUTH)
			owner.visible_message("<span class='cum'>[owner] cums into [fucking]'s mouth!</span>")
		else if(fucked_action == ORAL_MALE)
			owner.visible_message("<span class='cum'>[owner] cums into [fucked]'s mouth!</span>")
		else
			owner.visible_message("<span class='cum'>[owner] cums on the floor!</span>")
			var/obj/effect/decal/cleanable/sex/cum = new /obj/effect/decal/cleanable/sex/semen(owner.loc)
			cum.add_blood_list(owner)

	else if(owner.gender == FEMALE)
		owner.visible_message("<span class='cum'>[owner] cums!</span>")
		var/obj/effect/decal/cleanable/sex/cum = new /obj/effect/decal/cleanable/sex/femjuice(owner.loc)
		cum.add_blood_list(owner)

#undef CUM_LEVEL

#undef ORAL_FEMALE
#undef ORAL_MALE

#undef FUCK_ANUS
#undef FUCK_VAGINA
#undef FUCK_MOUTH