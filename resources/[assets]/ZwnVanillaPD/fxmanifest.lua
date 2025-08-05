fx_version 'cerulean'
game 'gta5'

developer "ZP-CARS"
author "ZP-CARS"

games { 'rdr3', 'gta5' }

files {
    'data/**/*.meta',
  }

data_file 'VEHICLE_LAYOUTS_FILE' 'data/**/vehiclelayouts.meta'
data_file 'HANDLING_FILE' 'data/**/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'data/**/vehicles.meta'
data_file 'CARCOLS_FILE' 'data/**/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'data/**/carvariations.meta'
dependency '/assetpacks'
dependency '/assetpacks-redm'