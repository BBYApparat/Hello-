Ak47Clothing = {}
var selectedTab = ".characterTab"
var lastCategory = "character"
var selectedCam = null;
var canChange = true;
var changingCat = null;
var hairColors = null;
var makeupColors = null;
var clothingCategorys = [];

$(document).on('click', '.clothing-menu-header-btn', function(e) {
    var category = $(this).data('category');
    $(selectedTab).removeClass("selected");
    $(this).addClass("selected");
    $(".clothing-menu-" + lastCategory + "-container").css({
        "display": "none"
    });
    lastCategory = category;
    selectedTab = this;
    $(".clothing-menu-" + category + "-container").css({
        "display": "block"
    });
})
$(document).on('click', '.clothing-menu-option-item-right', function(e) {
    e.preventDefault();
    var clothingCategory = $(this).parent().data('type');
    var buttonType = $(this).data('type');
    var inputElem = $(this).parent().find('input');
    var inputVal = $(inputElem).val();
    var newValue = parseFloat(inputVal) + 1;
    var buttonMax = $(this).parent().find('[data-headertype="item-header"]').data('maxItem');
    if (newValue <= parseInt(buttonMax)) {
        $(inputElem).val(newValue);
        $.post('https://ak47_clothing/updateSkin', JSON.stringify({
            clothingType: clothingCategory,
            articleNumber: newValue,
            type: buttonType,
        }));
    }
});
$(document).on('click', '.clothing-menu-option-item-left', function(e) {
    e.preventDefault();
    var clothingCategory = $(this).parent().data('type');
    var buttonType = $(this).data('type');
    var inputElem = $(this).parent().find('input');
    var inputVal = $(inputElem).val();
    var newValue = parseFloat(inputVal) - 1;
    var buttonMin = $(this).parent().find('[data-headertype="item-header"]').data('minItem');
    if (newValue >= parseInt(buttonMin)) {
        $(inputElem).val(newValue);
        $.post('https://ak47_clothing/updateSkin', JSON.stringify({
            clothingType: clothingCategory,
            articleNumber: newValue,
            type: buttonType,
        }));
    }
});

function ChangeUp() {
    var clothingCategory = $(changingCat).parent().parent().data('type');
    var buttonType = $(changingCat).data('type');
    var inputVal = parseFloat($(changingCat).val());
    if (clothingCategory == "accessory" && inputVal + 1 == 13) {
        $(changingCat).val(14 - 1)
    }
}

function ChangeDown() {
    var clothingCategory = $(changingCat).parent().parent().data('type');
    var buttonType = $(changingCat).data('type');
    var inputVal = parseFloat($(changingCat).val());
    if (clothingCategory == "accessory" && inputVal - 1 == 13) {
        $(changingCat).val(12 + 1)
    }
}
$(document).on('change', '.item-number', function() {
    var clothingCategory = $(this).parent().data('type');
    var buttonType = $(this).data('type');
    var inputVal = $(this).val();
    changingCat = this;
    $.post('https://ak47_clothing/updateSkinOnInput', JSON.stringify({
        clothingType: clothingCategory,
        articleNumber: parseFloat(inputVal),
        type: buttonType,
    }));
});
$(document).on('click', '.clothing-menu-header-camera-btn', function(e) {
    e.preventDefault();
    var camValue = parseFloat($(this).data('value'));
    if (selectedCam == null) {
        $(this).addClass("selected-cam");
        $.post('https://ak47_clothing/setupCam', JSON.stringify({
            value: camValue
        }));
        selectedCam = this;
    } else {
        if (selectedCam == this) {
            $(selectedCam).removeClass("selected-cam");
            $.post('https://ak47_clothing/setupCam', JSON.stringify({
                value: 0
            }));
            selectedCam = null;
        } else {
            $(selectedCam).removeClass("selected-cam");
            $(this).addClass("selected-cam");
            $.post('https://ak47_clothing/setupCam', JSON.stringify({
                value: camValue
            }));
            selectedCam = this;
        }
    }
});

$(document).on('click', '.clothing-menu-header-remove-btn', function(e) {
    e.preventDefault();
    var part = $(this).data('value');
    if ($(this).hasClass('selected-remove')) {
        $(this).removeClass("selected-remove");
        $.post('https://ak47_clothing/setremove', JSON.stringify({
            part: part,
            remove: false,
        }));
    }else {
        $(this).addClass("selected-remove");
        $.post('https://ak47_clothing/setremove', JSON.stringify({
            part: part,
            remove: true,
        }));
    }
});

$(document).on('keydown', function() {
    switch (event.keyCode) {
        case 68: // D
            $.post('https://ak47_clothing/rotateRight');
            break;
        case 65: // A
            $.post('https://ak47_clothing/rotateLeft');
            break;
        case 38: // UP
            ChangeUp();
            break;
        case 40: // DOWN
            ChangeDown();
            break;
    }
});
Ak47Clothing.ToggleChange = function(bool) {
    canChange = bool;
}
$(document).ready(function() {
    window.addEventListener('message', function(event) {
        switch (event.data.action) {
            case "open":
                Ak47Clothing.Open(event.data);
                break;
            case "close":
                Ak47Clothing.Close();
                break;
            case "updateCurrent":
                Ak47Clothing.SetCurrentValue(event.data.type, event.data.value);
                break;
            case "updateMax":
                Ak47Clothing.SetMaxValues(event.data.maxValues, event.data.reset);
                break;
            case "reloadMyOutfits":
                Ak47Clothing.ReloadOutfits(event.data.outfits);
                break;
            case "toggleChange":
                Ak47Clothing.ToggleChange(event.data.allow);
                break;
        }
    })
});
$(document).on('click', "#save-menu", function(e) {
    e.preventDefault();
    $.post('https://ak47_clothing/saveClothing');
    Ak47Clothing.Close();
});
$(document).on('click', "#cancel-menu", function(e) {
    e.preventDefault();
    Ak47Clothing.Close();
    $.post('https://ak47_clothing/resetOutfit');
});
Ak47Clothing.SetCurrentValue = function(type, val) {
    let item = {
        name: type,
        value: val,
    }
    var itemCats = $(".clothing-menu-character-container").find('[data-type="' + item.name + '"]');
    var input = $(itemCats).find('input[data-type="item"]');
    $(input).val(item.value);
    var slider = $(itemCats).find('[data-slidertype="item-slider"]');
    $(slider).data('label', item.label);
    $(slider).html("<p>" + item.label + ": " + item.value + "</p>");
    var itemCats = $(".clothing-menu-clothing-container").find('[data-type="' + item.name + '"]');
    var input = $(itemCats).find('input[data-type="item"]');
    $(input).val(item.value);
    var slider = $(itemCats).find('[data-slidertype="item-slider"]');
    $(slider).data('label', item.label);
    $(slider).html("<p>" + item.label + ": " + item.value + "</p>");
    var itemCats = $(".clothing-menu-accessoires-container").find('[data-type="' + item.name + '"]');
    var input = $(itemCats).find('input[data-type="item"]');
    $(input).val(item.value);
    var slider = $(itemCats).find('[data-slidertype="item-slider"]');
    $(slider).data('label', item.label);
    $(slider).html("<p>" + item.label + ": " + item.value + "</p>");
    var itemCats = $(".clothing-menu-barber-container").find('[data-type="' + item.name + '"]');
    var input = $(itemCats).find('input[data-type="item"]');
    $(input).val(item.value);
    var slider = $(itemCats).find('[data-slidertype="item-slider"]');
    $(slider).data('label', item.label);
    $(slider).html("<p>" + item.label + ": " + item.value + "</p>");
    $(slider).html("<p>" + item.label + ": " + item.value + "</p>");
    var itemCats = $(".clothing-menu-tattoos-container").find('[data-type="' + item.name + '"]');
    var input = $(itemCats).find('input[data-type="item"]');
    $(input).val(item.value);
    var slider = $(itemCats).find('[data-slidertype="item-slider"]');
    $(slider).data('label', item.label);
    $(slider).html("<p>" + item.label + ": " + item.value + "</p>");
}
Ak47Clothing.SetMaxValues = function(maxValues, reset) {
    $.each(maxValues, function(i, cat) {
        var containers = $(".clothing-menu-character-container").find('[data-type="' + i + '"]');
        var itemMax = $(containers).find('[data-headertype="item-header"]');
        $(itemMax).data('maxItem', cat.max)
        $(itemMax).data('minItem', cat.min)
        $(itemMax).html("<p>" + cat.label + ": " + cat.max + "</p>")
        if(reset && i == reset){
            var input = $(containers).find('input[data-type="item"]');
            $(input).val(cat.min);
        }

        var containers = $(".clothing-menu-clothing-container").find('[data-type="' + i + '"]');
        var itemMax = $(containers).find('[data-headertype="item-header"]');
        $(itemMax).data('maxItem', cat.max)
        $(itemMax).data('minItem', cat.min)
        $(itemMax).html("<p>" + cat.label + ": " + cat.max + "</p>")
        if(reset && i == reset){
            var input = $(containers).find('input[data-type="item"]');
            $(input).val(cat.min);
        }

        var containers = $(".clothing-menu-accessoires-container").find('[data-type="' + i + '"]');
        var itemMax = $(containers).find('[data-headertype="item-header"]');
        $(itemMax).data('maxItem', cat.max)
        $(itemMax).data('minItem', cat.min)
        $(itemMax).html("<p>" + cat.label + ": " + cat.max + "</p>")
        if(reset && i == reset){
            var input = $(containers).find('input[data-type="item"]');
            $(input).val(cat.min);
        }

        var containers = $(".clothing-menu-barber-container").find('[data-type="' + i + '"]');
        var itemMax = $(containers).find('[data-headertype="item-header"]');
        $(itemMax).data('maxItem', cat.max)
        $(itemMax).data('minItem', cat.min)
        $(itemMax).html("<p>" + cat.label + ": " + cat.max + "</p>")
        if(reset && i == reset){
            var input = $(containers).find('input[data-type="item"]');
            $(input).val(cat.min);
        }

        var containers = $(".clothing-menu-tattoos-container").find('[data-type="' + i + '"]');
        var itemMax = $(containers).find('[data-headertype="item-header"]');
        $(itemMax).data('maxItem', cat.max)
        $(itemMax).data('minItem', cat.min)
        $(itemMax).html("<p>" + cat.label + ": " + cat.max + "</p>")
        if(reset && i == reset){
            var input = $(containers).find('input[data-type="item"]');
            $(input).val(cat.min);
        }
    })
}
Ak47Clothing.SetCurrentValues = function(clothingValues) {
    $.each(clothingValues, function(i, item) {
        var itemCats = $(".clothing-menu-character-container").find('[data-type="' + item.name + '"]');
        var input = $(itemCats).find('input[data-type="item"]');
        $(input).val(item.value);
        var slider = $(itemCats).find('[data-slidertype="item-slider"]');
        $(slider).data('label', item.label);
        $(slider).html("<p>" + item.label + ": " + item.value + "</p>");
        var itemCats = $(".clothing-menu-clothing-container").find('[data-type="' + item.name + '"]');
        var input = $(itemCats).find('input[data-type="item"]');
        $(input).val(item.value);
        var slider = $(itemCats).find('[data-slidertype="item-slider"]');
        $(slider).data('label', item.label);
        $(slider).html("<p>" + item.label + ": " + item.value + "</p>");
        var itemCats = $(".clothing-menu-accessoires-container").find('[data-type="' + item.name + '"]');
        var input = $(itemCats).find('input[data-type="item"]');
        $(input).val(item.value);
        var slider = $(itemCats).find('[data-slidertype="item-slider"]');
        $(slider).data('label', item.label);
        $(slider).html("<p>" + item.label + ": " + item.value + "</p>");
        var itemCats = $(".clothing-menu-barber-container").find('[data-type="' + item.name + '"]');
        var input = $(itemCats).find('input[data-type="item"]');
        $(input).val(item.value);
        var slider = $(itemCats).find('[data-slidertype="item-slider"]');
        $(slider).data('label', item.label);
        $(slider).html("<p>" + item.label + ": " + item.value + "</p>");
        $(slider).html("<p>" + item.label + ": " + item.value + "</p>");
        var itemCats = $(".clothing-menu-tattoos-container").find('[data-type="' + item.name + '"]');
        var input = $(itemCats).find('input[data-type="item"]');
        $(input).val(item.value);
        var slider = $(itemCats).find('[data-slidertype="item-slider"]');
        $(slider).data('label', item.label);
        $(slider).html("<p>" + item.label + ": " + item.value + "</p>");
    });
}
Ak47Clothing.Open = function(data) {
    clothingCategorys = data.currentClothing;
    $(".change-camera-buttons").fadeIn(150);
    $(".clothing-menu-myOutfits-container").css("display", "none");
    $(".clothing-menu-character-container").css("display", "none");
    $(".clothing-menu-barber-container").css("display", "none");
    $(".clothing-menu-clothing-container").css("display", "none");
    $(".clothing-menu-accessoires-container").css("display", "none");
    $(".clothing-menu-tattoos-container").css("display", "none");
    $(".clothing-menu-container").css({
        "display": "block"
    }).animate({
        right: 0
    }, 200);

    hairColors = createPalette(event.data.hairColors);
    makeupColors = createPalette(event.data.makeupColors);
    AddPalettes();

    Ak47Clothing.SetMaxValues(data.maxValues);
    $(".clothing-menu-header").html("");
    Ak47Clothing.SetCurrentValues(data.currentClothing);
    $(".clothing-menu-myOutfits-container").html("");
    $.each(data.menus, function(i, menu) {
        if (menu.selected) {
            $(".clothing-menu-header").append('<div class="clothing-menu-header-btn ' + menu.menu + 'Tab selected" data-category="' + menu.menu + '"><p>' + menu.label + '</p></div>')
            $(".clothing-menu-" + menu.menu + "-container").css({
                "display": "block"
            });
            if (menu.label == "Clothing") {
                $("#faceoption").css("display", "none");
            } else {
                $("#faceoption").css("display", "block");
            }
            selectedTab = "." + menu.menu + "Tab";
            lastCategory = menu.menu;
        } else {
            $(".clothing-menu-header").append('<div class="clothing-menu-header-btn ' + menu.menu + 'Tab" data-category="' + menu.menu + '"><p>' + menu.label + '</p></div>')
        }
        if (menu.menu == "myOutfits") {
            $.each(menu.outfits, function(index, outfit) {
                var elem = '<div class="clothing-menu-option" data-myOutfit="' + (index + 1) + '"> <div class="clothing-menu-option-header"><p>' + outfit.outfitname + '</p></div><div class="clothing-menu-myOutfit-option-button"><p>Select</p></div><div class="clothing-menu-myOutfit-option-button-remove"><p>Delete</p></div></div>'
                $(".clothing-menu-myOutfits-container").append(elem)
                $("[data-myOutfit='" + (index + 1) + "']").data('myOutfitData', outfit)
            });
        }
    });
    var menuWidth = (100 / data.menus.length)
    $(".clothing-menu-header-btn").css("width", menuWidth - 0.49 + "%");
}
Ak47Clothing.ReloadOutfits = function(outfits) {
    $(".clothing-menu-myOutfits-container").html("");
    $.each(outfits, function(index, outfit) {
        var elem = '<div class="clothing-menu-option" data-myOutfit="' + (index + 1) + '"> <div class="clothing-menu-option-header"><p>' + outfit.outfitname + '</p></div><div class="clothing-menu-myOutfit-option-button"><p>Select</p></div><div class="clothing-menu-myOutfit-option-button-remove"><p>Delete</p></div></div>'
        $(".clothing-menu-myOutfits-container").append(elem)
        $("[data-myOutfit='" + (index + 1) + "']").data('myOutfitData', outfit)
    });
}
$(document).on('click', '.clothing-menu-outfit-option-button', function(e) {
    e.preventDefault();
    var oData = $(this).parent().data('outfitData');
    $.post('https://ak47_clothing/selectOutfit', JSON.stringify({
        outfitData: oData.outfitData,
        outfitName: oData.outfitLabel
    }))
});
$(document).on('click', '.clothing-menu-myOutfit-option-button', function(e) {
    e.preventDefault();
    var outfitData = $(this).parent().data('myOutfitData');
    $.post('https://ak47_clothing/selectOutfit', JSON.stringify({
        outfitData: outfitData.skin,
        outfitName: outfitData.outfitname,
        outfitId: outfitData.outfitId,
    }))
});
$(document).on('click', '.clothing-menu-myOutfit-option-button-remove', function(e) {
    e.preventDefault();
    var outfitData = $(this).parent().data('myOutfitData');
    $.post('https://ak47_clothing/removeOutfit', JSON.stringify({
        outfitData: outfitData.skin,
        outfitName: outfitData.outfitname,
        outfitId: outfitData.outfitId,
    }));
});
Ak47Clothing.Close = function() {
    $.post('https://ak47_clothing/close');
    $(".change-camera-buttons").fadeOut(150);
    $(".clothing-menu-myOutfits-container").css("display", "none");
    $(".clothing-menu-character-container").css("display", "none");
    $(".clothing-menu-clothing-container").css("display", "none");
    $(".clothing-menu-accessoires-container").css("display", "none");
    $(".clothing-menu-barber-container").css("display", "none");
    $(".clothing-menu-tattoos-container").css("display", "none");
    $(".clothing-menu-header").html("");
    $(selectedCam).removeClass('selected-cam');
    $(selectedTab).removeClass("selected");
    selectedCam = null;
    selectedTab = null;
    lastCategory = null;
    $(".clothing-menu-container").css({
        "display": "block"
    }).animate({
        right: "-25vw"
    }, 200, function() {
        $(".clothing-menu-container").css({
            "display": "none"
        });
    });
    $('.clothing-menu-header-remove-btn').each(function() {
        if ($(this).hasClass('selected-remove')) {
            $(this).removeClass('selected-remove')
        }
    });
}
$(document).on('click', '#save-outfit', function(e) {
    e.preventDefault();
    $(".clothing-menu-container").css({
        "display": "block"
    }).animate({
        right: "-25vw"
    }, 200, function() {
        $(".clothing-menu-container").css({
            "display": "none"
        });
    });
    $(".clothing-menu-save-outfit-name").fadeIn(150);
});
$(document).on('click', '#save-outfit-save', function(e) {
    e.preventDefault();
    $(".clothing-menu-container").css({
        "display": "block"
    }).animate({
        right: 0
    }, 200);
    $(".clothing-menu-save-outfit-name").fadeOut(150);
    $.post('https://ak47_clothing/saveOutfit', JSON.stringify({
        outfitName: $("#outfit-name").val()
    }));
});
$(document).on('click', '#cancel-outfit-save', function(e) {
    e.preventDefault();
    $(".clothing-menu-container").css({
        "display": "block"
    }).animate({
        right: 0
    }, 200);
    $(".clothing-menu-save-outfit-name").fadeOut(150);
});

$(document).on('input', '.clothing-menu-option-item-slider', function(e) {
    var clothingCategory = $(this).parent().data('type');
    var buttonType = $(this).data('type');
    var inputElem = $(this).parent().find('input');
    var inputVal = $(inputElem).val();
    var newValue = parseFloat(inputVal);
    var slider = $(this).parent().find('[data-slidertype="item-slider"]')
    var label = $(this).parent().find('[data-slidertype="item-slider"]').data('label');
    $(slider).html("<p>" + slider.data('label') + ": " + newValue + "</p>");
    $.post('https://ak47_clothing/updateSkin', JSON.stringify({
        clothingType: clothingCategory,
        articleNumber: newValue,
        type: buttonType,
    }));
});

function AddPalettes() {
    $('.swatches').each(function() {
        $(this).empty()
        if ($(this).hasClass('haircol')) {
            $(this).append($(hairColors))
        }
        if ($(this).hasClass('makeupcol')) {
            $(this).append($(makeupColors))
        }
    });
    $('.swatch').on('click', function() {
        var palettes = $(this).parents('.clothing-menu-option-item').find('.default-swatches')
        var clothingCategory = $(this).parents('.clothing-menu-option-item').data('type');
        $(this).parent().find('.swatch').removeClass('active')
        $(this).addClass('active')
        if ($(this).parents('.clothing-menu-option-item').find('.default-swatches').hasClass('haircol') || $(this).parents('.clothing-menu-option-item').find('.default-swatches').hasClass('makeupcol')) {
            var newValue = palettes.eq(0).find('.active').attr('value');
            $.post('https://ak47_clothing/updateSkin', JSON.stringify({
                clothingType: clothingCategory,
                articleNumber: parseInt(newValue),
            }));
        }
    })
}

function createPalette(array) {
    var ele_string = ""
    for (var i = 0; i < Object.keys(array).length; i++) {
        var color = array[i][0] + "," + array[i][1] + "," + array[i][2]
        ele_string += '<div class="swatch" style="background-color: rgb(' + color + ')" value="' + i + '"></div>'
    }
    return ele_string
}