--[[ FX Information ]]--
fx_version   'cerulean'
use_experimental_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'

--[[ Resource Information ]]--
name         'bzzz_snackprops'
version      '2.1.0'
description  'Snack props'
author       'BzZz'

--[[ Manifest ]]--
shared_scripts {
}

client_scripts {
}

server_scripts {
}

escrow_ignore {
	'data/*.lua',
	'stream/*.ydr'
}

dependencies {

}



data_file 'DLC_ITYP_REQUEST' 'stream/*.ytyp'

files {
    'stream/*.ytyp',
}

dependency '/assetpacks'


dependency '/assetpacks'