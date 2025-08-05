return {
	whitelisted_jobs = { 'reporter' }, -- Jobs allowed to create articles
	ace_permission = 'okokphone.news', -- Ace permission to delete articles
	max_characters = 5000,          -- Maximum characters for an article
	alerts_jobs = {                 -- What jobs can create alerts
		{ name = 'police',    minimum_grade = 1 },
		{ name = 'ambulance', minimum_grade = 1 },
		{ name = 'reporter',  minimum_grade = 0 },
	},
}
