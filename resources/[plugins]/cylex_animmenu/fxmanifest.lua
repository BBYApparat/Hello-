fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_scripts {
    "config.lua",
    "animations/merge/*.lua",
    "client/*.lua"
}

server_scripts {
    "config.lua",
    "server/main.lua"
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/css/*.css",
    "html/img/*.png",
    "html/js/*.js",
    "html/fonts/*.otf",
    "html/fonts/*.ttf",
}


escrow_ignore {
    "config.lua",
    "animations/merge/*.lua",
}

data_file 'DLC_ITYP_REQUEST' 'bzzz_foodpack.ytyp'
data_file 'DLC_ITYP_REQUEST' 'bzzz_prop_torch_fire001.ytyp'
data_file 'DLC_ITYP_REQUEST' 'natty_props_lollipops.ytyp'
data_file 'DLC_ITYP_REQUEST' 'scully_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'badges.ytyp'
data_file 'DLC_ITYP_REQUEST' 'lilflags_ytyp.ytyp'
data_file 'DLC_ITYP_REQUEST' 'prideprops_ytyp.ytyp'
data_file 'DLC_ITYP_REQUEST' 'bzzz_food_icecream_pack.ytyp'
data_file 'DLC_ITYP_REQUEST' 'bzzz_effect_cigarpack.ytyp'
data_file 'DLC_ITYP_REQUEST' 'bzzz_murderpack.ytyp'
data_file 'DLC_ITYP_REQUEST' 'bzzz_animal_fish002.ytyp'
data_file 'DLC_ITYP_REQUEST' 'bzzz_food_dessert_a.ytyp'
data_file 'DLC_ITYP_REQUEST' 'bzzz_prop_give_gift.ytyp'
data_file 'DLC_ITYP_REQUEST' 'bzzz_package_pizzahut.ytyp'
data_file 'DLC_ITYP_REQUEST' 'ultra_ringcase.ytyp'
data_file 'DLC_ITYP_REQUEST' 'bzzz_food_xmas22.ytyp'
data_file "DLC_ITYP_REQUEST" "badge1.ytyp"
data_file "DLC_ITYP_REQUEST" "copbadge.ytyp"
dependency '/assetpacks'