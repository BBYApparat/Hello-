return {
  email_domain = 'mycity.com',
  reserved_aliases = {
    -- Can only be created via command or directly on the database
    'admin',
    'administrator',
    'mod',
    'moderator',
    'police',
    'hospital',
    'news',
  },
  qb_phone_compatibility = true,
  enable_qbcore_email_convert = false,     -- This command is only meant to be used once! /convertqbmail
  default_qb_mail_button_label = 'Accept',
}
