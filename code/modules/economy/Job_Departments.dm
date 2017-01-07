var/list/station_departments = list("Command", "Medical", "Engineering", "Science", "Security", "Cargo", "Support", "Civilian")

// The department the job belongs to.
/datum/job/var/department = null

// Whether this is a head position
/datum/job/var/head_position = 0

/datum/job/captain/department = "Command"
/datum/job/captain/head_position = 1

/datum/job/civilian/department = "Civilian"

// Support
/datum/job/hop/department = "Support"
/datum/job/hop/head_position = 1

/datum/job/bartender/department = "Support"
/datum/job/chef/department = "Support"
/datum/job/hydro/department = "Support"
/datum/job/mining/department = "Support"
/datum/job/janitor/department = "Support"
/datum/job/librarian/department = "Support"
/datum/job/chaplain/department = "Support"

// Supply
/datum/job/cargo_tech/department = "Cargo"
/datum/job/mining/department = "Cargo"

// Engineering
/datum/job/chief_engineer/department = "Engineering"
/datum/job/chief_engineer/head_position = 1

/datum/job/engineer/department = "Engineering"

// Medical
/datum/job/cmo/department = "Medical"
/datum/job/cmo/head_position = 1

/datum/job/doctor/department = "Medical"

// Science
/datum/job/rd/department = "Science"
/datum/job/rd/head_position = 1

/datum/job/scientist/department = "Science"

// Security
/datum/job/hos/department = "Security"
/datum/job/hos/head_position = 1

/datum/job/warden/department = "Security"
/datum/job/detective/department = "Security"
/datum/job/officer/department = "Security"
/datum/job/lawyer/department = "Security"
/datum/job/iaa/department = "Security"