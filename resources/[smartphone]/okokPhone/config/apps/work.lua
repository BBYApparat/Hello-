--[[ Work App ]]
return {

  UnemployedJobName = "unemployed",
  -- Hide jobs from the job center
  -- Prevent Job Applications
  hiddenJobs = {
    -- "police",
    -- "ambulance",
  },

  -- Job Locked Emails
  -- These emails are not related to job applications
  -- minimumGrade is the minimum grade required to read and send emails from this job
  jobEmails = {
    auto_create = true, -- Create missing emails on resource start
    list = {
      ["police"] = { address = "police@myserver.com", minimumGrade = 4 },
      ["ambulance"] = { address = "ambulance@myserver.com", minimumGrade = 1 },
    }
  },

  dutyToggling = true,    -- Enable or disable duty toggling
  abandonJob = true,      -- Enable or disable job abandoning
  jobApplications = true, -- Enable or disable job applications


  --- QBCore
  useOkokBanking = true, -- Enable this in case you have removed qb-management

  --- 👇 ESX ONLY 👇 ---

  --- This is used for setting a player off duty
  --- and requires you to have this job created
  --- Example: "off_police"
  --- Helper SQL Query to automatically create off_duty jobs
  --[[
            INSERT INTO jobs (name, label)
            SELECT CONCAT('off_', name) AS NAME, label
            FROM jobs
            WHERE name NOT LIKE 'off_%';

            INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female)
            SELECT
            CONCAT('off_', job_name) AS job_name,
            grade,
            name,
            label,
            salary,
            skin_male,
            skin_female
            FROM job_grades;
      ]]
  OffDutyJobPrefix = "off_",

  -- Society names usualy are prefixed with "society_" followed by the job name in lowercase (e.g. society_police)
  EsxSocietyPrefix = "society_",

  --[[ A list of grades that are considered as boss grades (Top rank of a job) ]]
  --[[ If the script detects this grade of a given job, it will award full permissions to the player ]]
  --[[ For withdrawing and viewing the company's bank balance ]]
  --[[ okokBossMenu will override this list when started, don't update this one if you're using okokBossMenu ]]
  bossGrades = {
    "boss"
  }
}
