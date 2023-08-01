/datum/admin_changelog
	var/html = null

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ATTENTION: The changelog has moved into its own file: strings/admin_changelog.txt
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

/datum/admin_changelog/New()
	..()
	//Note: deliberately using double quotes so that it won't be included in the RSC -SpyGuy
	html = changelog_parse(rustg_file_read("strings/admin_changelog.txt"), "Admin Changelog")
