const { useQuasar } = Quasar
const { ref } = Vue

const app = Vue.createApp({
    setup() {
        return {
            options: ref(false),
            help: ref(false),
            showblur: ref(true),
        }
    },
    methods: {
        select: function (event) {
            targetId = event.currentTarget.id;
            showBlur()
        }
    }
})

app.use(Quasar, { config: {} })
app.mount('#inventory-menus')

Date.getUtcEpochTimestamp = () => Math.round(new Date().getTime() / 1000)

function showBlur() {
    $.post('https://inventory/showBlur');
}
var InventoryOption = "100, 100, 117";
var myMoney = 0;
var otherMoney = 0;
var myJob = "";
var myGrade = "";
var itemdatas = {};
var vehColors = {};
var totalWeight = 0;
var totalWeightOther = 0;
var playerMaxWeight = 0;
var otherMaxWeight = 0;
var otherLabel = "";
var ClickedItemData = {};
var SelectedAttachment = null;
var AttachmentScreenActive = false;
var ControlPressed = false;
var disableRightMouse = false;
var selectedItem = null;
var IsDragging = false;
var id_card_info = null;
let right_click_delay = false;
let swap_delay = false;

let templateChoosePlayer = `
    <div class="choosePlayer" id="playerChooser">
        <div class="mainCardCloseButton" onclick="cancelChoosePlayer()"><i class="fas fa-times"></i></div>
        %playersImgs%
    </div>
`;

let templateChoosePlayerImg = `
    <div><img src="%playerHeadshotImgSrc%" onclick="givetoPlayer(%playerId%, %itemName%, %itemAmount%, %itemSlot%, %itemType%)"></div>
`;

$(document).on("keydown", function () {
    if (event.repeat) {
        return;
    }
    switch (event.keyCode) {
        case 27: // ESC
            $(".ply-iteminfo-container").css("opacity", "0.0");
            Inventory.Close();
            break;
        case 9: // TAB
            $(".ply-iteminfo-container").css("opacity", "0.0");
            Inventory.Close();
            break;
        case 17: // Control
            ControlPressed = true;
            break;
    }
});

$(document).on("dblclick", ".item-slot", function (e) {
    var ItemData = $(this).data("item");
    var ItemInventory = $(this).parent().attr("data-inventory");
    if (ItemData) {
        Inventory.Close();
        $.post("https://inventory/UseItem", JSON.stringify({
            inventory: ItemInventory,
            item: ItemData,
        }));
    }
});

$(document).on("keyup", function () {
    switch (event.keyCode) {
        case 17: // TAB
            ControlPressed = false;
            break;
    }
});

$(document).on("mouseenter", ".item-slot", function (e) {
    e.preventDefault();
    $(".ply-iteminfo-container").css("opacity", "0.0");
    if ($(this).data("item") != null) {
        $(".ply-iteminfo-container").css("opacity", "1.0");
        $(".ply-iteminfo-container").fadeIn(150);
        setTimeout(() => {
            if (!Inventory.isOpened()) {
                $(".ply-iteminfo-container").css("opacity", "0.0");
            }
        }, 200);
        FormatItemInfo($(this).data("item"), $(this));
    } else {
        $(".ply-iteminfo-container").fadeOut(100);
    }
});

$(document).on("mouseleave", ".item-slot", function (e) {
    $(".ply-iteminfo-container").css("opacity", "0.0");
});

function GetFirstFreeSlot($toInv, $fromSlot) {
    var retval = null;
    $.each($toInv.find(".item-slot"), function (i, slot) {
        if ($(slot).data("item") === undefined) {
            if (retval === null) {
                retval = i + 1;
            }
        }
    });
    return retval;
}

function CanQuickMove() {
    var otherinventory = otherLabel.toLowerCase();
    var retval = true;
    if (otherinventory.split("-")[0] == "player") {
        retval = false;
    }
    return retval;
}

$(document).on("mousedown", ".item-slot", function (event) {
    switch (event.which) {
        case 3:
            fromSlot = $(this).attr("data-slot");
            fromInventory = $(this).parent();
            if ($(fromInventory).attr("data-inventory") == "player") {
                toInventory = $(".other-inventory");
            } else {
                toInventory = $(".player-inventory");
            }
            toSlot = GetFirstFreeSlot(toInventory, $(this));
            if ($(this).data("item") === undefined) {
                return;
            }
            toAmount = $(this).data("item").amount;
            if (toAmount > 1) {
                toAmount = 1;
            }
            if (CanQuickMove()) {
                if (toSlot === null) {
                    InventoryError(fromInventory, fromSlot, "Action Impossible!");
                    return;
                }
                if (fromSlot == toSlot && fromInventory == toInventory) {
                    return;
                }
                if (toAmount >= 0) {
                    if (updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount, true)) {
                        swap(fromSlot, toSlot, fromInventory, toInventory, toAmount, true);
                    }
                }
            } else {
                InventoryError(fromInventory, fromSlot, "Action Impossible!");
            }
            break;
    }
});

$(document).on("click", ".item-slot", function (e) {
    e.preventDefault();
    var ItemData = $(this).data("item");
    if (ItemData !== null && ItemData !== undefined) {
        if (ItemData.name !== undefined) {
            if (ItemData.name.split("_")[0] == "weapon") {
                if (!$("#weapon-attachments").length) {
                    $(".inv-options-list").append('<div class="inv-option-item" id="weapon-attachments"><p>Attachments</p></div>');
                    $("#weapon-attachments").hide().fadeIn(250);
                    ClickedItemData = ItemData;
                } else if (ClickedItemData == ItemData) {
                    $("#weapon-attachments").fadeOut(250, function () {
                        $("#weapon-attachments").remove();
                    });
                    ClickedItemData = {};
                } else {
                    ClickedItemData = ItemData;
                }
            } else {
                ClickedItemData = {};
                if ($("#weapon-attachments").length) {
                    $("#weapon-attachments").fadeOut(250, function () {
                        $("#weapon-attachments").remove();
                    });
                }
            }
        } else {
            ClickedItemData = {};
            if ($("#weapon-attachments").length) {
                $("#weapon-attachments").fadeOut(250, function () {
                    $("#weapon-attachments").remove();
                });
            }
        }
    } else {
        ClickedItemData = {};
        if ($("#weapon-attachments").length) {
            $("#weapon-attachments").fadeOut(250, function () {
                $("#weapon-attachments").remove();
            });
        }
    }
});

$(document).on("click", "#inv-close", function (e) {
    e.preventDefault();
    $(".ply-iteminfo-container").css("opacity", "0.0");
    $(".notify").css("opacity", "0.0");
    Inventory.Close();
});

$(document).on("click", ".weapon-attachments-back", function (e) {
    e.preventDefault();
    $("#qbcore-inventory").css({ display: "flex" });
    $("#qbcore-inventory").animate({ left: 0 + "vw", }, 200);
    $(".weapon-attachments-container").animate({ left: -100 + "vw", }, 200, function () {
        $(".weapon-attachments-container").css({ display: "none" });
    });
    AttachmentScreenActive = false;
});

function FormatAttachmentInfo(data) {
    $.post("https://inventory/GetWeaponData", JSON.stringify({
        weapon: data.name,
        ItemData: ClickedItemData,
    }), function (data) {
        var AmmoLabel = "9mm";
        var Durability = 100;
        if (data.WeaponData.ammo_type == "AMMO_RIFLE") {
            AmmoLabel = "7.62";
        } else if (data.WeaponData.ammo_type == "AMMO_SHOTGUN") {
            AmmoLabel = "12 Gauge";
        }
        if (ClickedItemData.info.quality !== undefined) {
            Durability = ClickedItemData.info.quality;
        }
        $(".weapon-attachments-container-title").html(data.WeaponData.label + " | " + AmmoLabel);
        $(".weapon-attachments-container-description").html(data.WeaponData.description);
        $(".weapon-attachments-container-details").html('<span style="font-weight: bold; letter-spacing: .1vh;">Serial</span><br> ' + ClickedItemData.info.serie + '<br><br><span style="font-weight: bold; letter-spacing: .1vh;">Durability - ' + Durability.toFixed() + '% </span> <div class="weapon-attachments-container-detail-durability"><div class="weapon-attachments-container-detail-durability-total"></div></div>');
        $(".weapon-attachments-container-detail-durability-total").css({ width: Durability + "%" });
        $(".weapon-attachments-container-image").attr("src", "./attachment_images/" + data.WeaponData.name + ".png");
        $(".weapon-attachments").html("");
        if (data.AttachmentData !== null && data.AttachmentData !== undefined) {
            if (data.AttachmentData.length > 0) {
                $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">Attachments</span>');
                $.each(data.AttachmentData, function (i, attachment) {
                    var WeaponType = (data.WeaponData.ammo_type).split("_")[1].toLowerCase();
                    $(".weapon-attachments").append('<div class="weapon-attachment" id="weapon-attachment-' + i + '"> <div class="weapon-attachment-label"><p>' + attachment.label + '</p></div> <div class="weapon-attachment-img"><img src="./images/' + WeaponType + "_" + attachment.attachment + '.png"></div> </div>');
                    attachment.id = i;
                    $("#weapon-attachment-" + i).data("AttachmentData", attachment);
                });
            } else {
                $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">This gun doesn\'t contain attachments</span>');
            }
        } else {
            $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">This gun doesn\'t contain attachments</span>');
        }
        handleAttachmentDrag();
    });
}

var AttachmentDraggingData = {};

function handleAttachmentDrag() {
    $(".weapon-attachment").draggable({
        helper: "clone",
        appendTo: "body",
        scroll: true,
        revertDuration: 0,
        revert: "invalid",
        start: function (event, ui) {
            var ItemData = $(this).data("AttachmentData");
            $(this).addClass("weapon-dragging-class");
            AttachmentDraggingData = ItemData;
        },
        stop: function () {
            $(this).removeClass("weapon-dragging-class");
        },
    });
    $(".weapon-attachments-remove").droppable({
        accept: ".weapon-attachment",
        hoverClass: "weapon-attachments-remove-hover",
        drop: function (event, ui) {
            $.post("https://inventory/RemoveAttachment", JSON.stringify({
                AttachmentData: AttachmentDraggingData,
                WeaponData: ClickedItemData,
            }), function (data) {
                if (data.Attachments !== null && data.Attachments !== undefined) {
                    if (data.Attachments.length > 0) {
                        $("#weapon-attachment-" + AttachmentDraggingData.id).fadeOut(150, function () {
                            $("#weapon-attachment-" + AttachmentDraggingData.id).remove();
                            AttachmentDraggingData = null;
                        });
                    } else {
                        $("#weapon-attachment-" + AttachmentDraggingData.id).fadeOut(150, function () {
                            $("#weapon-attachment-" + AttachmentDraggingData.id).remove();
                            AttachmentDraggingData = null;
                            $(".weapon-attachments").html("");
                        });
                        $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">This gun doesn\'t contain attachments</span>');
                    }
                } else {
                    $("#weapon-attachment-" + AttachmentDraggingData.id).fadeOut(150, function () {
                        $("#weapon-attachment-" + AttachmentDraggingData.id).remove();
                        AttachmentDraggingData = null;
                        $(".weapon-attachments").html("");
                    });
                    $(".weapon-attachments-title").html('<span style="font-weight: bold; letter-spacing: .1vh;">This gun doesn\'t contain attachments</span>');
                }
            });
        },
    });
}

$(document).on("click", "#weapon-attachments", function (e) {
    e.preventDefault();
    if (!Inventory.IsWeaponBlocked(ClickedItemData.name)) {
        $(".weapon-attachments-container").css({ display: "block" });
        $("#qbcore-inventory").animate({ left: 100 + "vw" }, 200, function () {
            $("#qbcore-inventory").css({ display: "none" });
        });
        $(".weapon-attachments-container").animate({ left: 0 + "vw" }, 200);
        AttachmentScreenActive = true;
        FormatAttachmentInfo(ClickedItemData);
    } else {
        $.post("https://inventory/Notify", JSON.stringify({
            message: "Attachments are unavailable for this gun.",
            type: "error",
        }));
    }
});

function CalculateRemainingTime(quality, inv) {
    let maxQuality = 24;
    let tested = inv.parent().attr("data-inventory");
    if (tested.match("fridge")) {
        maxQuality = 48;
    }
    let percentage = (quality / 100);
    let remaining = parseInt(percentage * maxQuality);
    return remaining
}

function FormatItemInfo(itemData, dom) {
    $(".colour-box").css({ display: "none"});
    let currentOpenedInv = dom.parent().attr("data-inventory");
    if (!currentOpenedInv.includes("crafting")) {
        if (itemData.name == "id_card") {
            var gender = "Man";
            if (id_card_info.sex == "f" || id_card_info.sex == "F") {
                gender = "Woman";
            }
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p><strong>First Name: </strong><span>" + id_card_info.firstname + "</span></p><p><strong>Last Name: </strong><span>" + id_card_info.lastname + "</span></p><p><strong>Birth Date: </strong><span>" + id_card_info.dob + "</span></p><p><strong>Gender: </strong><span>" + gender + "</span></p>");
        } else if (itemData.name == "driver_license") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p><strong>First Name: </strong><span>" + id_card_info.firstname + "</span></p><p><strong>Last Name: </strong><span>" + id_card_info.lastname + "</span></p><p><strong>Birth Date: </strong><span>" + id_card_info.dob + "</span></p>");
        } else {
            if (itemData != null && itemData.info != "") {
                if (itemData.name == "lighter" || itemData.name == "zippo") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p>" + itemData.info.uses + " uses left.</p>");
                } else if (itemData.name == "phone" && itemData.info.lbPhoneNumber) {
                    $(".item-info-title").html("<p>" + (itemData.info.lbPhoneName ?? itemData.label) + "</p>");
                    $(".item-info-description").html("<p><strong>Phone Number: </strong><span>" + (itemData.info.lbFormattedNumber ?? itemData.info.lbPhoneNumber) +"</span></p>");
                } else if (itemData.name == "screwdriverset" || itemData.name == "micro_forceps") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p>" + itemData.info.uses + " uses left.</p>");
                } else if (itemData.name == "weaponlicense") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p><strong>First Name: </strong><span>" + itemData.info.firstname + "</span></p><p><strong>Last Name: </strong><span>" + itemData.info.lastname + "</span></p><p><strong>Birth Date: </strong><span>" + itemData.info.birthdate + "</span></p>");
                } else if (itemData.name == "nitrous") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p><span>" + itemData.info.value / 10 + " shots left</span></p>");
                } else if (itemData.name == "scale") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p><span>" + itemData.info.uses + " uses left</span></p>");
                } else if (itemData.name == "lowdrybud" || itemData.name == "highdrybud") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p><span>" + itemData.info.quality + "% quality</span></p>");
                } else if (itemData.name == "highgradewetbud" || itemData.name == "lowgradewetbud") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p><span>" + itemData.info.quality + "% quality</span></p>");
                } else if (itemData.name == "forestfruitsliquid" || itemData.name == "energydrinkliquid" || itemData.name == "cheesecakeliquid" || itemData.name == "watermelonliquid" || itemData.name == "strawberryliquid" || itemData.name == "bubblegumliquid" || itemData.name == "blueberryliquid" || itemData.name == "caramelaliquid" || itemData.name == "cinnamonliquid" || itemData.name == "vanillaliquid" || itemData.name == "biscuitliquid" || itemData.name == "coffeeliquid" || itemData.name == "bananaliquid" || itemData.name == "lemonliquid" || itemData.name == "honeyliquid" || itemData.name == "mintliquid") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p><span>" + itemData.info.shots + " ml left</span></p>");
                } else if (itemData.name == "spraypaint") {
                    let cola = "Primary Color"
                    if (itemData.info.type === "color2") {
                        cola = "Secondary Color"
                    } else if (itemData.info.type === "pearlescentColor") {
                        cola = "Pearlescent Color"
                    }
                    let typed = ""
                    if (itemData.info.colortype != null) {
                        typed = itemData.info.colortype;
                    }
                    let colorvals = itemData.info.color
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p><span> Spray Type: </span>" + cola +" " + typed + " </p>");
                    if (typeof colorvals === "number") {
                        let temp_data = vehColors[itemData.info.color.toString()]
                        colorvals = [temp_data.r, temp_data.g, temp_data.b]
                    }
                    let rColor = colorvals[0].toString()
                    let bColor = colorvals[1].toString()
                    let gColor = colorvals[2].toString()
                    $(".colour-box").css({ display: "block", "background-color": "rgb("+rColor+","+bColor+","+gColor+")"});
                } else if (itemData.name == "cigarettepack" || itemData.name == "slimcigarettepack" || itemData.name == "cubancigarettepack") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    let text = "cigarette"
                    if (itemData.info.cigarettes > 1) {
                        text = "cigarettes"
                    }
                    $(".item-info-description").html("<p><span>" + itemData.info.cigarettes + " "+text+" left</span></p>");
                } else if (itemData.name == "lawyerpass") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p><strong>Pass-ID: </strong><span>" + itemData.info.id + "</span></p><p><strong>First Name: </strong><span>" + itemData.info.firstname + "</span></p><p><strong>Last Name: </strong><span>" + itemData.info.lastname + "</span></p><p><strong>CSN: </strong><span>" + itemData.info.citizenid + "</span></p>");
                } else if (itemData.itemtype == "clubbottle") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p>" + itemData.info.uses + " glasses left.</p>");
                } else if (itemData.itemtype == "expiring") {
                    let timer = CalculateRemainingTime(itemData.info.quality, dom);
                    var text = "Expired"
                    if (timer > 0) {
                        text = "Expires in " + timer + ' hours.'
                    }
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p>" + text + "</p>");
                } else if (itemData.name == "fakeplate") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p> Plate Details: " + itemData.info.plate +"</p>");
                } else if (itemData.name == "harness") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p>" + itemData.info.uses + " uses left.</p>");
                } else if (itemData.name == "weapon_petrolcan") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    let liters = 0;
                    if (itemData.info == undefined || itemData.info.liters == undefined) {
                        liters = 0;
                    } else {
                        liters = itemData.info.liters;
                    }
                    $(".item-info-description").html("<p>" + liters + " Liters left.</p>");
                } else if (itemData.type == "weapon" && !itemData.info.costs && !itemData.price) {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    if (itemData.info.ammo == undefined) {
                        itemData.info.ammo = 0;
                    } else {
                        itemData.info.ammo != null ? itemData.info.ammo : 0;
                    }
                    let ammo = itemData.info.ammo
                    if (ammo == undefined) {
                        ammo = 0;
                    }
                    let serie = itemData.info.serie
                    if (serie == undefined) {
                        serie = "Not registered"
                    }
                    let text = ""
                    if (serie != null && serie != undefined) {
                        text = text + "<p><strong>Serial: </strong><span>" + serie + "</span></p>"
                    }
                    if (ammo != null && ammo != undefined && ammo != 0) {
                        text = text + "<p><strong>Ammo: </strong><span>" + ammo + "</span></p>"
                    }
                    if (itemData.info.attachments != null && JSON.stringify(itemData.info.attachments) != '[]') {
                        var attachmentString = "";
                        $.each(itemData.info.attachments, function (i, attachment) {
                            if (i == itemData.info.attachments.length - 1) {
                                attachmentString += attachment.label;
                            } else {
                                attachmentString += attachment.label + ", ";
                            }
                        });
                        text = text + "<p><strong>Attachments: </strong><span>" + attachmentString + "</span></p>"
                    }
                    $(".item-info-description").html(text);
                } else if (itemData.name == "analyzed_evidencebag") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p><strong>Evidence material: </strong><span>" + "Ammo" + "</span></p><p><strong>Type number: </strong><span>" + itemData.info.bullet + "</span></p><p><strong>Serial: </strong><span>" + itemData.info.serie + "</span></p><p><strong>Crime scene: </strong><span>" + itemData.info.street + "</span></p>");
                } else if (itemData.info.type == "analyzed_bloodevidencebag") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p><strong>Evidence material: </strong><span>" + "Blood" + "</span></p><p><strong>Crime scene: </strong><span>" + itemData.info.street + "</span></p><p><strong>First Name: </strong><span>" + itemData.info.firstname + "</span></p><p><strong>Last Name: </strong><span>" + itemData.info.lastname + "</span></p> ");
                } else if (itemData.info.costs != undefined && itemData.info.costs != null) {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p>" + "Required: " + itemData.info.costs + "</p>");
                } else if (itemData.name == "stickynote") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p>" + itemData.info.label + "</p>");
                } else if (itemData.name == "moneybag") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p><strong>Amount of cash: </strong><span>$" + itemData.info.cash + "</span></p>");
                } else if (itemData.name == "markedbills") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p><strong>Worth: </strong><span>$" + itemData.info.worth + "</span></p>");
                } else if (itemData.name == "visa" || itemData.name == "mastercard") {
                    $(".item-info-title").html('<p>' + itemData.label + '</p>')
                    var str = "" + itemData.info.cardNumber + "";
                    var res = str.slice(12);
                    var cardNumber = "************" + res;
                    $(".item-info-description").html('<p><strong>Card Holder: </strong><span>' + itemData.info.name + '</span></p><p><strong>Citizen ID: </strong><span>' + itemData.info.citizenid + '</span></p><p><strong>Card Number: </strong><span>' + cardNumber + '</span></p>');
                } else if (itemData.name == "labkey") {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p>Key Tag:</p> <p>" + itemData.info.lab.hint + "</p>");
                } else {
                    $(".item-info-title").html("<p>" + itemData.label + "</p>");
                    $(".item-info-description").html("<p>" + itemData.description + "</p>");
                }
            } else {
                $(".item-info-title").html("<p>" + itemData.label + "</p>");
                $(".item-info-description").html("<p>" + itemData.description + "</p>");
            }
        }
    } else {
        if (itemData != null && itemData.info != "") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p>" + "Required: " + itemData.info.costs + "</p>");
        }
    }
}

function handleDragDrop() {
    $(".item-drag").draggable({
        helper: "clone",
        appendTo: "body",
        scroll: true,
        revertDuration: 0,
        revert: "invalid",
        cancel: ".item-nodrag",
        start: function (event, ui) {
            IsDragging = true;
            $(this).find("img").css("filter", "brightness(50%)");
            $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.1)");
            var itemData = $(this).data("item");
            var dragAmount = $("#item-amount").val();
            if (!itemData.usable) {
                $("#item-use").css("background", "rgba(35,35,35, 0.5");
            }
            if (dragAmount == 0) {
                if (itemData.price != null) {
                    $(this).find(".item-slot-amount p").html("0");
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html(" " + itemData.amount + " $" + itemData.price);
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                } else {
                    $(this).find(".item-slot-amount p").html("0");
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html(itemData.amount + " " + " ");
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                }
            } else if (dragAmount > itemData.amount) {
                if (itemData.price != null) {
                    $(this).find(".item-slot-amount p").html(" " + itemData.amount + " $" + itemData.price);
                } else {
                    $(this).find(".item-slot-amount p").html(itemData.amount + " " + " ");
                }
                InventoryError($(this).parent(), $(this).attr("data-slot"), "Action Impossible!");
            } else if (dragAmount > 0) {
                if (itemData.price != null) {
                    $(this).find(".item-slot-amount p").html(" " + itemData.amount + " $" + itemData.price);
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html(" " + itemData.amount + " $" + itemData.price);
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                } else {
                    $(this).find(".item-slot-amount p").html(itemData.amount - dragAmount + " " + ((itemData.weight * (itemData.amount - dragAmount)) / 1000).toFixed(1) + " ");
                    $(".ui-draggable-dragging").find(".item-slot-amount p").html(dragAmount + " " + " ");
                    $(".ui-draggable-dragging").find(".item-slot-key").remove();
                }
            } else {
                $(".ui-draggable-dragging").find(".item-slot-key").remove();
                $(this).find(".item-slot-amount p").html(itemData.amount + " " + " ");
                InventoryError($(this).parent(), $(this).attr("data-slot"), "Action Impossible!");
            }
        },
        stop: function () {
            setTimeout(function () {
                IsDragging = false;
            }, 150);
            $(this).css("background", "rgba(0, 0, 0, 0.3)");
            $(this).find("img").css("filter", "brightness(100%)");
            $("#item-use").css("background", "rgba(" + InventoryOption + ", 1.0)");
        },
    });

    $(".item-slot").droppable({
        hoverClass: "item-slot-hoverClass",
        drop: function (event, ui) {
            setTimeout(function () {
                IsDragging = false;
            }, 150);
            fromSlot = ui.draggable.attr("data-slot");
            fromInventory = ui.draggable.parent();
            toSlot = $(this).attr("data-slot");
            toInventory = $(this).parent();
            toAmount = $("#item-amount").val();
            if (fromSlot == toSlot && fromInventory == toInventory) {
                return;
            }
            if (toAmount >= 0 && swap_delay === false) {
                if (updateweights(fromSlot, toSlot, fromInventory, toInventory, toAmount)) {
                    swap(fromSlot, toSlot, fromInventory, toInventory, toAmount);
                }
            }
        },
    });

    $("#item-use").droppable({
        hoverClass: "button-hover",
        drop: function (event, ui) {
            setTimeout(function () {
                IsDragging = false;
            }, 150);
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");
            if (fromData.usable) {
                if (fromData.shouldClose) {
                    $(".ply-iteminfo-container").css("opacity", "0.0");
                    $(".notify").css("opacity", "0.0");
                    Inventory.Close();
                }
                $.post("https://inventory/UseItem", JSON.stringify({
                    inventory: fromInventory,
                    item: fromData,
                }));
            }
        },
    });

    $("#item-drop").droppable({
        hoverClass: "item-slot-hoverClass",
        drop: function (event, ui) {
            setTimeout(function () {
                IsDragging = false;
            }, 150);
            fromData = ui.draggable.data("item");
            fromInventory = ui.draggable.parent().attr("data-inventory");
            amount = $("#item-amount").val();
            if (amount == 0) {
                amount = fromData.amount;
            }
            $(this).css("background", "rgba(35,35,35, 0.7");
            $.post("https://inventory/DropItem", JSON.stringify({
                inventory: fromInventory,
                item: fromData,
                amount: parseInt(amount),
            }));
        },
    });
}

function updateweights($fromSlot, $toSlot, $fromInv, $toInv, $toAmount, isQuickMove) {
    if ($toInv.attr("data-inventory") == undefined || $fromInv.attr("data-inventory") == undefined) {
       return false;
    }
    var otherinventory = otherLabel.toLowerCase();
    var shouldError = true;
    if (otherinventory.split("-")[0] == "dropped") {
        fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
    }
    if ($toInv.attr("data-inventory").split("-")[0] == "stash") {
        let stashLabel = $toInv.attr("data-inventory").split("-")[1]
        if (stashLabel.includes("fridge")) {
            fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
            if (!fromData.itemtype || fromData.itemtype != "expiring") {
                InventoryError($fromInv, $fromSlot, "This inventory can store only food & drinks!");
                return false;
            }
        } else if (stashLabel.includes("weaponarmory")) {
            fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
            if (!fromData.itemtype || fromData.itemtype != "weapon") {
                InventoryError($fromInv, $fromSlot, "This inventory can store only weapons!");
                return false;
            }
        }
    }
    if ($toInv.attr("data-inventory").split("-")[0] != "autoshop") {
        fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        if (toData != null && toData.unique && fromData.name === toData.name) {
            InventoryError($fromInv, $fromSlot, "Items cannot be stacked!");
            return false;
        }
    }
    if (($fromInv.attr("data-inventory") == "hotbar" && $toInv.attr("data-inventory") == "player") || ($fromInv.attr("data-inventory") == "player" && $toInv.attr("data-inventory") == "hotbar") || ($fromInv.attr("data-inventory") == "player" && $toInv.attr("data-inventory") == "player") || ($fromInv.attr("data-inventory") == "hotbar" && $toInv.attr("data-inventory") == "hotbar")) {
        return true;
    }
    if ($toInv.attr("data-inventory").split("-")[0] == "ministorage") {
        itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        if (itemData.name == $toInv.attr("data-inventory").split("-")[1]) {
            InventoryError($fromInv, $fromSlot, "You can't store your ministorage into your ministorage!")
            return false;
        }
    }
    if (($fromInv.attr("data-inventory").split("-")[0] == "itemshop" && $toInv.attr("data-inventory").split("-")[0] == "itemshop") || ($fromInv.attr("data-inventory").includes("crafting") && $toInv.attr("data-inventory").includes("crafting"))) {
        itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        var image = itemData.image;
        var imagelink = '"images/' + image + '"';
        if (image.startsWith("https")) {
            imagelink = image;
        }
        if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src='+imagelink+'" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>' + itemData.amount + '</div><div class="item-slot-name"><p>' + " $" + itemData.price + '</p></div><div class="item-slot-label"><p>' + itemData.label + "</p></div>");
        } else {
            $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src='+imagelink+'" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>' + itemData.amount + '</div><div class="item-slot-name"><p>' + " " + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + '</p></div><div class="item-slot-label"><p>' + itemData.label + "</p></div>");
        }
        InventoryError($fromInv, $fromSlot, "Action Impossible!");
        return false;
    }
    //     itemData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
    //     var image = itemData.image;
    //     var imagelink = '"images/' + image + '"';
    //     if (image.startsWith("https")) {
    //         imagelink = image;
    //     }
    //     if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
    //         $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src='+imagelink+'" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>' + itemData.amount + '</div><div class="item-slot-name"><p>' + " $" + itemData.price + '</p></div><div class="item-slot-label"><p>' + itemData.label + "</p></div>");
    //     } else {
    //         $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src='+imagelink+'" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>' + itemData.amount + '</div><div class="item-slot-name"><p>' + " " + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + '</p></div><div class="item-slot-label"><p>' + itemData.label + "</p></div>");
    //     }
    //     InventoryError($fromInv, $fromSlot);
    //     return false;
    // }
    if ($toInv.attr("data-inventory").split("-")[0] == "itemshop" || $toInv.attr("data-inventory").includes("crafting")) {
        itemData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        var image = itemData.image;
        var imagelink = '"images/' + image + '"';
        if (image.startsWith("https")) {
            imagelink = image;
        }
        if ($toInv.attr("data-inventory").split("-")[0] == "itemshop") {
            $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src='+imagelink+'" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>' + itemData.amount + '</div><div class="item-slot-name"><p>' + " $" + itemData.price + '</p></div><div class="item-slot-label"><p>' + itemData.label + "</p></div>");
        } else {
            $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src='+imagelink+'" alt="' + itemData.name + '" /></div><div class="item-slot-amount"><p>' + itemData.amount + '</div><div class="item-slot-name"><p>' + " " + ((itemData.weight * itemData.amount) / 1000).toFixed(1) + '</p></div><div class="item-slot-label"><p>' + itemData.label + "</p></div>");
        }
        InventoryError($fromInv, $fromSlot, "Action Impossible!");
        return false;
    }
    if ((!$toAmount || $toAmount == 0) && ($fromInv.attr("data-inventory").includes("itemshop") || $fromInv.attr("data-inventory").includes("crafting"))) {
        $toAmount = 1;
    }
    if ($fromInv.attr("data-inventory") != $toInv.attr("data-inventory")) {
        fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
        toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
        if ($toAmount == 0 && !$fromInv.attr("data-inventory").includes("itemshop")) {
            $toAmount = fromData.amount;
        }
        if (($fromInv.attr("data-inventory").includes("crafting") || $fromInv.attr("data-inventory").includes("itemshop")) && isQuickMove) {
            fromData.amount = 1;
        }
        if (toData == null || fromData.name == toData.name) {
            if ($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") {
                totalWeight = totalWeight - fromData.weight * $toAmount;
                totalWeightOther = totalWeightOther + fromData.weight * $toAmount;
                if ($toInv.attr("data-inventory") != "player" && $toInv.attr("data-inventory") != "hotbar") {
                    if ($toInv.attr("data-inventory") === "autoshop") {
                        shouldError = false
                    }
                }
            } else {
                totalWeight = totalWeight + fromData.weight * $toAmount;
                totalWeightOther = totalWeightOther - fromData.weight * $toAmount;
            }
        } else {
            if ($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") {
                totalWeight = totalWeight - fromData.weight * $toAmount;
                totalWeight = totalWeight + toData.weight * toData.amount;
                totalWeightOther = totalWeightOther + fromData.weight * $toAmount;
                totalWeightOther = totalWeightOther - toData.weight * toData.amount;
                if ($toInv.attr("data-inventory") != "player" && $toInv.attr("data-inventory") != "hotbar") {
                    if ($toInv.attr("data-inventory") === "autoshop") {
                        shouldError = false
                    }
                }
            } else {
                totalWeight = totalWeight + fromData.weight * $toAmount;
                totalWeight = totalWeight - toData.weight * toData.amount;
                totalWeightOther = totalWeightOther - fromData.weight * $toAmount;
                totalWeightOther = totalWeightOther + toData.weight * toData.amount;
            }
        }
    }
    if (totalWeight > playerMaxWeight || (totalWeightOther > otherMaxWeight && $fromInv.attr("data-inventory").split("-")[0] != "itemshop" && !$fromInv.attr("data-inventory").includes("crafting"))) {
        if (shouldError != false) {
            InventoryError($fromInv, $fromSlot, "You cannot carry those!");
            return false;
        }
    }
    var per = (totalWeight / 1000) / (playerMaxWeight / 100000)
    $(".pro").css("width", per + "%");
    $(".pro_black").css("width", (100 - per) + "%");
    $("#player-inv-weight").html('<i class="fas fa-dumbbell"></i> ' + (parseInt(totalWeight) / 1000).toFixed(2) + "/" + (playerMaxWeight / 1000).toFixed(2));
    if ($fromInv.attr("data-inventory").split("-")[0] != "itemshop" && $toInv.attr("data-inventory").split("-")[0] != "itemshop" && !$fromInv.attr("data-inventory").includes("crafting") && !$toInv.attr("data-inventory").includes("crafting")) {
        $("#other-inv-label").html(otherLabel);
        $("#other-inv-weight").html('<i class="fas fa-dumbbell"></i> ' + (parseInt(totalWeightOther) / 1000).toFixed(2) + "/" + (otherMaxWeight / 1000).toFixed(2));
        var per1 = (totalWeightOther / 1000) / (otherMaxWeight / 100000);
        $(".pro1").css("width", per1 + "%");
        $(".pro1_black").css("width", (100 - per1) + "%");
    }
    return true;
}

var combineslotData = null;

$(document).on("click", ".CombineItem", function (e) {
    e.preventDefault();
    if (combineslotData.toData.combinable.anim != null) {
        $.post("https://inventory/combineWithAnim", JSON.stringify({
            combineData: combineslotData.toData.combinable,
            usedItem: combineslotData.toData.name,
            requiredItem: combineslotData.fromData.name,
        }));
    } else {
        $.post("https://inventory/combineItem", JSON.stringify({
            reward: combineslotData.toData.combinable.reward,
            toItem: combineslotData.toData.name,
            fromItem: combineslotData.fromData.name,
        }));
    }
    $(".ply-iteminfo-container").css("opacity", "0.0");
    $(".notify").css("opacity", "0.0");
    Inventory.Close();
});

$(document).on("click", ".CompostItem", function (e) {
    e.preventDefault();
    $.post("https://inventory/compostItems", JSON.stringify({}));
    $(".ply-iteminfo-container").css("opacity", "0.0");
    $(".notify").css("opacity", "0.0");
    Inventory.Close();
});

function optionSwitch($fromSlot, $toSlot, $fromInv, $toInv, $toAmount, toData, fromData) {
    fromData.slot = parseInt($toSlot);
    $toInv.find("[data-slot=" + $toSlot + "]").data("item", fromData);
    $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
    $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");
    var image = fromData.image;
    var imagelink = '"images/' + image + '"';
    if (image.startsWith("https")) {
        imagelink = image;
    }
    if ($toSlot < 6) {
        $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src='+imagelink+'" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + '</div><div class="item-slot-name"><p>' + " " + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + '</p></div><div class="item-slot-label"><p>' + fromData.label + "</p></div>");
    } else {
        $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src='+imagelink+'" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + '</div><div class="item-slot-name"><p>' + " " + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + '</p></div><div class="item-slot-label"><p>' + fromData.label + "</p></div>");
    }
    toData.slot = parseInt($fromSlot);
    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
    $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", toData);
    var image = toData.image;
    var imagelink = '"images/' + image + '"';
    if (image.startsWith("https")) {
        imagelink = image;
    }
    if ($fromSlot < 6) {
        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"><img src='+imagelink+'" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + '</div><div class="item-slot-name"><p>' + " " + ((toData.weight * toData.amount) / 1000).toFixed(1) + '</p></div><div class="item-slot-label"><p>' + toData.label + "</p></div>");
    } else {
        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src='+imagelink+'" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + '</div><div class="item-slot-name"><p>' + " " + ((toData.weight * toData.amount) / 1000).toFixed(1) + '</p></div><div class="item-slot-label"><p>' + toData.label + "</p></div>");
    }
    var otherLal = document.getElementById("other-inv-label").textContent;
    $.post("https://inventory/SetInventoryData", JSON.stringify({
        fromInventory: $fromInv.attr("data-inventory"),
        toInventory: $toInv.attr("data-inventory"),
        fromSlot: $fromSlot,
        toSlot: $toSlot,
        fromAmount: $toAmount,
        otherLabel: otherLal,
        toAmount: toData.amount,
    }));
}

function swap($fromSlot, $toSlot, $fromInv, $toInv, $toAmount, isQuickMove) {
    if(right_click_delay && Inventory.isOpened()) {
        return;
    }
    if (swap_delay && Inventory.isOpened()) {
        return;
    }
    swap_delay = true;
    right_click_delay = true;
    setTimeout(() => {
        right_click_delay = false;
        swap_delay = false
    }, 180);

    fromData = $fromInv.find("[data-slot=" + $fromSlot + "]").data("item");
    toData = $toInv.find("[data-slot=" + $toSlot + "]").data("item");
    var otherinventory = otherLabel.toLowerCase();
    if (otherinventory.split("-")[0] == "dropped") {
        if (toData && toData.unique) {
            InventoryError($fromInv, $fromSlot, "Action Impossible!");
            return;
        }
    }
    if (otherinventory.includes("crafting") && $fromInv.attr("data-inventory").includes("crafting") && $toInv.attr("data-inventory") == "player") {
        if ($toAmount > fromData.amount) {
            fromData.amount = $toAmount;
        }
        if (isQuickMove) {
            fromData.amount = 1;
        }
    }
    if ($fromInv.attr("data-inventory").includes("itemshop") && !$toAmount) {
        $toAmount = 1;
    }
    if (fromData !== undefined && fromData.amount >= $toAmount) {
        if (fromData.unique && $toAmount > 1 && $toInv.attr("data-inventory").split("-")[0] != "autoshop" && !$fromInv.attr("data-inventory").includes("crafting")) {
            InventoryError($fromInv, $fromSlot, "Action Impossible!");
            return;
        }
        if ($fromInv.attr("data-inventory") == "player"  && $toInv.attr("data-inventory").split("-")[0] == "autoshop") {
            var curInv = otherinventory.replace(" ", "_")
            if (myJob == curInv && (myGrade === "boss" || myGrade === "boss2" || myGrade === "boss3" || myGrade === "boss4")) {
                if (toData == undefined || toData == null) {
                    Inventory.Dialog(fromData, $toSlot);
                    return;
                } else {
                    if (fromData.name != toData.name) {
                        InventoryError($fromInv, $fromSlot, "Action Impossible!");
                        return;
                    }
                }
            } else {
                InventoryError($fromInv, $fromSlot, "Action Impossible!");
                return;
            }
        }
        if (($fromInv.attr("data-inventory") == "player" || $fromInv.attr("data-inventory") == "hotbar") && $toInv.attr("data-inventory").split("-")[0] == "itemshop" && $toInv.attr("data-inventory").includes("crafting")) {
            InventoryError($fromInv, $fromSlot, "Action Impossible!");
            return;
        }
        if ($toAmount == 0 && $fromInv.attr("data-inventory").split("-")[0] == "itemshop" && $fromInv.attr("data-inventory").includes("crafting")) {
            InventoryError($fromInv, $fromSlot, "Action Impossible!");
            return;
        } else if ($toAmount == 0) {
            $toAmount = fromData.amount;
        }
        if ((toData != undefined || toData != null) && toData.name == fromData.name && !fromData.unique) {
            var newData = [];
            newData.name = toData.name;
            newData.label = toData.label;
            newData.amount = parseInt($toAmount) + parseInt(toData.amount);
            newData.type = toData.type;
            newData.description = toData.description;
            newData.image = toData.image;
            newData.weight = toData.weight;
            newData.info = toData.info;
            newData.usable = toData.usable;
            newData.unique = toData.unique;
            newData.slot = parseInt($toSlot);
            var otherLal = document.getElementById("other-inv-label").textContent;
            if (fromData.amount == $toAmount) {
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newData);
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");
                var ItemLabel = '<div class="item-slot-label"><p>' + newData.label + "</p></div>";
                if (newData.name.split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newData.label + "</p></div>";
                    }
                } else if (itemdatas[newData.name] || itemdatas[newData.itemtype]) {
                    ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newData.label + "</p></div>";
                }
                var image = newData.image;
                var imagelink = '"images/' + image + '"';
                if (image.startsWith("https")) {
                    imagelink = image;
                }
                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src='+ imagelink + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + '</div><div class="item-slot-name"><p>' + " " + ((newData.weight * newData.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                } else if ($toSlot == 41 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src='+ imagelink + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + '</div><div class="item-slot-name"><p>' + " " + ((newData.weight * newData.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src='+ imagelink + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + '</div><div class="item-slot-name"><p>' + " " + ((newData.weight * newData.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                }
                if (newData.name.split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        if (newData.info.quality == undefined) {
                            newData.info.quality = 100.0;
                        }
                        var QualityColor = "rgb(15, 255, 213)";
                        if (newData.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (newData.info.quality > 25 && newData.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (newData.info.quality >= 50) {
                            QualityColor = "rgb(15, 255, 213)";
                        }
                        if (newData.info.quality !== undefined) {
                            qualityLabel = newData.info.quality.toFixed();
                        } else {
                            qualityLabel = newData.info.quality;
                        }
                        if (newData.info.quality == 0) {
                            qualityLabel = "BROKEN";
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                } else if (newData.itemtype == "expiring") {
                    if (newData.info.quality == undefined) {
                        newData.info.quality = 100.0;
                    }
                    var QualityColor = "rgb(15, 255, 213)";
                    if (newData.info.quality < 25) {
                        QualityColor = "rgb(192, 57, 43)";
                    } else if (newData.info.quality > 25 && newData.info.quality < 50) {
                        QualityColor = "rgb(230, 126, 34)";
                    } else if (newData.info.quality >= 50) {
                        QualityColor = "rgb(15, 255, 213)";
                    }
                    if (newData.info.quality !== undefined) {
                        qualityLabel = newData.info.quality.toFixed();
                    } else {
                        qualityLabel = newData.info.quality;
                    }
                    if (newData.info.quality == 0) {
                        qualityLabel = "ROTTEN";
                    }
                    $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                        width: qualityLabel + "%",
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                } else if (itemdatas[newData.name]) {
                    let itemInfo = itemdatas[newData.name];
                    let type = itemInfo.type;
                    let current = newData.info[type];
                    let max = itemInfo.max;
                    let min = 100/max;
                    let percentage = current * min;
                    if (percentage == undefined) {
                        percentage = 100.0;
                    }
                    var QualityColor = "rgb(15, 255, 213)";
                    if (percentage < 25) {
                        QualityColor = "rgb(192, 57, 43)";
                    } else if (percentage > 25 && percentage < 50) {
                        QualityColor = "rgb(230, 126, 34)";
                    } else if (percentage >= 50) {
                        QualityColor = "rgb(15, 255, 213)";
                    }
                    if (percentage !== undefined) {
                        qualityLabel = percentage.toFixed() + "%";
                    } else {
                        qualityLabel = percentage + "%";
                    }
                    if (percentage == 0) {
                        qualityLabel = "BROKEN";
                    }
                    $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                        width: qualityLabel,
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                }
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-nodrag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeData("item");
                $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
            } else if (fromData.amount > $toAmount) {
                var newDataFrom = [];
                newDataFrom.name = fromData.name;
                newDataFrom.label = fromData.label;
                newDataFrom.amount = parseInt(fromData.amount - $toAmount);
                newDataFrom.type = fromData.type;
                newDataFrom.description = fromData.description;
                newDataFrom.image = fromData.image;
                newDataFrom.weight = fromData.weight;
                newDataFrom.price = fromData.price;
                newDataFrom.info = fromData.info;
                newDataFrom.usable = fromData.usable;
                newDataFrom.unique = fromData.unique;
                newDataFrom.slot = parseInt($fromSlot);
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newData);
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");
                var ItemLabel = '<div class="item-slot-label"><p>' + newData.label + "</p></div>";
                if (newData.name.split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newData.label + "</p></div>";
                    }
                } else if (itemdatas[newData.name] || itemdatas[newData.itemtype]) {
                    ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newData.label + "</p></div>";
                }
                var image = newData.image;
                var imagelink = '"images/' + image + '"';
                if (image.startsWith("https")) {
                    imagelink = image;
                }
                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + '</div><div class="item-slot-name"><p>' + " " + ((newData.weight * newData.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                } else if ($toSlot == 41 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + '</div><div class="item-slot-name"><p>' + " " + ((newData.weight * newData.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + newData.name + '" /></div><div class="item-slot-amount"><p>' + newData.amount + '</div><div class="item-slot-name"><p>' + " " + ((newData.weight * newData.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                }

                if (newData.name.split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newData.name)) {
                        if (newData.info.quality == undefined) {
                            newData.info.quality = 100.0;
                        }
                        var QualityColor = "rgb(15, 255, 213)";
                        if (newData.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (newData.info.quality > 25 && newData.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (newData.info.quality >= 50) {
                            QualityColor = "rgb(15, 255, 213)";
                        }
                        if (newData.info.quality !== undefined) {
                            qualityLabel = newData.info.quality.toFixed();
                        } else {
                            qualityLabel = newData.info.quality;
                        }
                        if (newData.info.quality == 0) {
                            qualityLabel = "BROKEN";
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                } else if (newData.itemtype == "expiring") {
                    if (newData.info.quality == undefined) {
                        newData.info.quality = 100.0;
                    }
                    var QualityColor = "rgb(15, 255, 213)";
                    if (newData.info.quality < 25) {
                        QualityColor = "rgb(192, 57, 43)";
                    } else if (newData.info.quality > 25 && newData.info.quality < 50) {
                        QualityColor = "rgb(230, 126, 34)";
                    } else if (newData.info.quality >= 50) {
                        QualityColor = "rgb(15, 255, 213)";
                    }
                    if (newData.info.quality !== undefined) {
                        qualityLabel = newData.info.quality.toFixed();
                    } else {
                        qualityLabel = newData.info.quality;
                    }
                    if (newData.info.quality == 0) {
                        qualityLabel = "ROTTEN";
                    }
                    $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                        width: qualityLabel + "%",
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                } else if (itemdatas[newData.name]) {
                    let itemInfo = itemdatas[newData.name];
                    let type = itemInfo.type;
                    let current = newData.info[type];
                    let max = itemInfo.max;
                    let min = 100/max;
                    let percentage = current * min;
                    if (percentage == undefined) {
                        percentage = 100.0;
                    }
                    var QualityColor = "rgb(15, 255, 213)";
                    if (percentage < 25) {
                        QualityColor = "rgb(192, 57, 43)";
                    } else if (percentage > 25 && percentage < 50) {
                        QualityColor = "rgb(230, 126, 34)";
                    } else if (percentage >= 50) {
                        QualityColor = "rgb(15, 255, 213)";
                    }
                    if (percentage !== undefined) {
                        qualityLabel = percentage.toFixed() + "%";
                    } else {
                        qualityLabel = percentage + "%";
                    }
                    if (percentage == 0) {
                        qualityLabel = "BROKEN";
                    }
                    $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                        width: qualityLabel,
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                }
                $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", newDataFrom);
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
                var image = newDataFrom.image;
                var imagelink = '"images/' + image + '"';
                if (image.startsWith("https")) {
                    imagelink = image;
                }
                if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + '</div><div class="item-slot-name"><p>' + " $" + newDataFrom.price + '</p></div><div class="item-slot-label"><p>' + newDataFrom.label + "</p></div>");
                } else {
                    var ItemLabel = '<div class="item-slot-label"><p>' + newDataFrom.label + "</p></div>";
                    if (newDataFrom.name.split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newDataFrom.label + "</p></div>";
                        }
                    } else if (itemdatas[newDataFrom.name] || itemdatas[newDataFrom.itemtype]) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newDataFrom.label + "</p></div>";
                    }
                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + '</div><div class="item-slot-name"><p>' + " " + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                    } else if ($fromSlot == 41 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + '</div><div class="item-slot-name"><p>' + " " + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + '</div><div class="item-slot-name"><p>' + " " + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                    }
                    if (newDataFrom.name.split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            if (newDataFrom.info.quality == undefined) {
                                newDataFrom.info.quality = 100.0;
                            }
                            var QualityColor = "rgb(15, 255, 213)";
                            if (newDataFrom.info.quality < 25) {
                                QualityColor = "rgb(192, 57, 43)";
                            } else if (newDataFrom.info.quality > 25 && newDataFrom.info.quality < 50) {
                                QualityColor = "rgb(230, 126, 34)";
                            } else if (newDataFrom.info.quality >= 50) {
                                QualityColor = "rgb(15, 255, 213)";
                            }
                            if (newDataFrom.info.quality !== undefined) {
                                qualityLabel = newDataFrom.info.quality.toFixed();
                            } else {
                                qualityLabel = newDataFrom.info.quality;
                            }
                            if (newDataFrom.info.quality == 0) {
                                qualityLabel = "BROKEN";
                            }
                            $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                                width: qualityLabel + "%",
                                "background-color": QualityColor,
                            }).find("p").html(qualityLabel);
                        }
                    } else if (newDataFrom.itemtype == "expiring") {
                        if (newDataFrom.info.quality == undefined) {
                            newDataFrom.info.quality = 100.0;
                        }
                        var QualityColor = "rgb(15, 255, 213)";
                        if (newDataFrom.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (newDataFrom.info.quality > 25 && newDataFrom.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (newDataFrom.info.quality >= 50) {
                            QualityColor = "rgb(15, 255, 213)";
                        }
                        if (newDataFrom.info.quality !== undefined) {
                            qualityLabel = newDataFrom.info.quality.toFixed();
                        } else {
                            qualityLabel = newDataFrom.info.quality;
                        }
                        if (newDataFrom.info.quality == 0) {
                            qualityLabel = "ROTTEN";
                        }
                        $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    } else if (itemdatas[newDataFrom.name]) {
                        let itemInfo = itemdatas[newDataFrom.name];
                        let type = itemInfo.type;
                        let current = newDataFrom.info[type];
                        let max = itemInfo.max;
                        let min = 100/max;
                        let percentage = current * min;
                        if (percentage == undefined) {
                            percentage = 100.0;
                        }
                        var QualityColor = "rgb(15, 255, 213)";
                        if (percentage < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (percentage > 25 && percentage < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (percentage >= 50) {
                            QualityColor = "rgb(15, 255, 213)";
                        }
                        if (percentage !== undefined) {
                            qualityLabel = percentage.toFixed() + "%";
                        } else {
                            qualityLabel = percentage + "%";
                        }
                        if (percentage == 0) {
                            qualityLabel = "BROKEN";
                        }
                        $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel,
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                }
            }
            $.post("https://inventory/PlayDropSound", JSON.stringify({}));
            $.post("https://inventory/SetInventoryData", JSON.stringify({
                fromInventory: $fromInv.attr("data-inventory"),
                toInventory: $toInv.attr("data-inventory"),
                fromSlot: $fromSlot,
                toSlot: $toSlot,
                otherLabel: otherLal,
                fromAmount: $toAmount,
            }));
        } else {
            var otherLal = document.getElementById("other-inv-label").textContent;
            if (fromData.amount == $toAmount && $toInv.attr("data-inventory").split("-")[0] != "autoshop") {
                if (toData != undefined && toData.combinable != null && isItemAllowed(fromData.name, toData.combinable.accept) && $fromInv.attr("data-inventory") == "player" && $toInv.attr("data-inventory") == "player") {
                    $.post("https://inventory/getCombineItem", JSON.stringify({
                        item: toData.combinable.reward
                    }), function (item) {
                        $(".combine-option-text").html("<p>If you combine these items you get: <b>" + item.label + "</b></p>");
                    });
                    $(".combine-option-container").fadeIn(100);
                    combineslotData = [];
                    combineslotData.fromData = fromData;
                    combineslotData.toData = toData;
                    combineslotData.fromSlot = $fromSlot;
                    combineslotData.toSlot = $toSlot;
                    combineslotData.fromInv = $fromInv;
                    combineslotData.toInv = $toInv;
                    combineslotData.toAmount = $toAmount;
                    return;
                }
                fromData.slot = parseInt($toSlot);
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", fromData);
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");

                var ItemLabel = '<div class="item-slot-label"><p>' + fromData.label + "</p></div>";
                if (fromData.name.split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(fromData.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + fromData.label + "</p></div>";
                    }
                } else if (itemdatas[fromData.name] || itemdatas[fromData.itemtype]) {
                    ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + fromData.label + "</p></div>";
                }
                var image = fromData.image;
                var imagelink = '"images/' + image + '"';
                if (image.startsWith("https")) {
                    imagelink = image;
                }
                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + '</div><div class="item-slot-name"><p>' + " " + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                } else if ($toSlot == 41 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + '</div><div class="item-slot-name"><p>' + " " + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + fromData.name + '" /></div><div class="item-slot-amount"><p>' + fromData.amount + '</div><div class="item-slot-name"><p>' + " " + ((fromData.weight * fromData.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                }
                if (fromData.name.split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(fromData.name)) {
                        if (fromData.info.quality == undefined) {
                            fromData.info.quality = 100.0;
                        }
                        var QualityColor = "rgb(15, 255, 213)";
                        if (fromData.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (
                            fromData.info.quality > 25 &&
                            fromData.info.quality < 50
                        ) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (fromData.info.quality >= 50) {
                            QualityColor = "rgb(15, 255, 213)";
                        }
                        if (fromData.info.quality !== undefined) {
                            qualityLabel = fromData.info.quality.toFixed();
                        } else {
                            qualityLabel = fromData.info.quality;
                        }
                        if (fromData.info.quality == 0) {
                            qualityLabel = 100;
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                } else if (fromData.itemtype == "expiring") {
                    if (fromData.info.quality == undefined) {
                        fromData.info.quality = 100.0;
                    }
                    var QualityColor = "rgb(15, 255, 213)";
                    if (fromData.info.quality < 25) {
                        QualityColor = "rgb(192, 57, 43)";
                    } else if (fromData.info.quality > 25 && fromData.info.quality < 50) {
                        QualityColor = "rgb(230, 126, 34)";
                    } else if (fromData.info.quality >= 50) {
                        QualityColor = "rgb(15, 255, 213)";
                    }
                    if (fromData.info.quality !== undefined) {
                        qualityLabel = fromData.info.quality.toFixed();
                    } else {
                        qualityLabel = fromData.info.quality;
                    }
                    if (fromData.info.quality == 0) {
                        qualityLabel = 100;
                    }
                    $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                        width: qualityLabel + "%",
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                } else if (itemdatas[fromData.name]) {
                    let itemInfo = itemdatas[fromData.name];
                    let type = itemInfo.type;
                    let current = fromData.info[type];
                    let max = itemInfo.max;
                    let min = 100/max;
                    let percentage = current * min;
                    if (percentage == undefined) {
                        percentage = 100.0;
                    }
                    var QualityColor = "rgb(15, 255, 213)";
                    if (percentage < 25) {
                        QualityColor = "rgb(192, 57, 43)";
                    } else if (percentage > 25 && percentage < 50) {
                        QualityColor = "rgb(230, 126, 34)";
                    } else if (percentage >= 50) {
                        QualityColor = "rgb(15, 255, 213)";
                    }
                    if (percentage !== undefined) {
                        qualityLabel = percentage.toFixed() + "%";
                    } else {
                        qualityLabel = percentage + "%";
                    }
                    if (percentage == 0) {
                        qualityLabel = 100;
                    }
                    $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                        width: qualityLabel,
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                }
                if (toData != undefined) {
                    toData.slot = parseInt($fromSlot);
                    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", toData);
                    var ItemLabel = '<div class="item-slot-label"><p>' + toData.label + "</p></div>";
                    var image = toData.image;
                    var imagelink = '"images/' + image + '"';
                    if (image.startsWith("https")) {
                        imagelink = image;
                    }
                    if (toData.name.split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(toData.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + toData.label + "</p></div>";
                        }
                    } else if (itemdatas[toData.name] || itemdatas[toData.itemtype]) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + toData.label + "</p></div>";
                    } 
                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + '</div><div class="item-slot-name"><p>' + " " + ((toData.weight * toData.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                    } else if (
                        $fromSlot == 41 &&
                        $fromInv.attr("data-inventory") == "player"
                    ) {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + '</div><div class="item-slot-name"><p>' + " " + ((toData.weight * toData.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + toData.name + '" /></div><div class="item-slot-amount"><p>' + toData.amount + '</div><div class="item-slot-name"><p>' + " " + ((toData.weight * toData.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                    }

                    if (toData.name.split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(toData.name)) {
                            if (toData.info.quality == undefined) {
                                toData.info.quality = 100.0;
                            }
                            var QualityColor = "rgb(15, 255, 213)";
                            if (toData.info.quality < 25) {
                                QualityColor = "rgb(192, 57, 43)";
                            } else if (toData.info.quality > 25 && toData.info.quality < 50) {
                                QualityColor = "rgb(230, 126, 34)";
                            } else if (toData.info.quality >= 50) {
                                QualityColor = "rgb(15, 255, 213)";
                            }
                            if (toData.info.quality !== undefined) {
                                qualityLabel = toData.info.quality.toFixed();
                            } else {
                                qualityLabel = toData.info.quality;
                            }
                            if (toData.info.quality == 0) {
                                qualityLabel = 100;
                            }
                            $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                                width: qualityLabel + "%",
                                "background-color": QualityColor,
                            }).find("p").html(qualityLabel);
                        }
                    } else if (toData.itemtype == "expiring") {
                        if (toData.info.quality == undefined) {
                            toData.info.quality = 100.0;
                        }
                        var QualityColor = "rgb(15, 255, 213)";
                        if (toData.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (toData.info.quality > 25 && toData.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (toData.info.quality >= 50) {
                            QualityColor = "rgb(15, 255, 213)";
                        }
                        if (toData.info.quality !== undefined) {
                            qualityLabel = toData.info.quality.toFixed();
                        } else {
                            qualityLabel = toData.info.quality;
                        }
                        if (toData.info.quality == 0) {
                            qualityLabel = 100;
                        }
                        $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    } else if (itemdatas[toData.name]) {
                        let itemInfo = itemdatas[toData.name];
                        let type = itemInfo.type;
                        let current = toData.info[type];
                        let max = itemInfo.max;
                        let min = 100/max;
                        let percentage = current * min;
                        if (percentage == undefined) {
                            percentage = 100.0;
                        }
                        var QualityColor = "rgb(15, 255, 213)";
                        if (percentage < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (percentage > 25 && percentage < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (percentage >= 50) {
                            QualityColor = "rgb(15, 255, 213)";
                        }
                        if (percentage !== undefined) {
                            qualityLabel = percentage.toFixed() + "%";
                        } else {
                            qualityLabel = percentage + "%";
                        }
                        if (percentage == 0) {
                            qualityLabel = 100;
                        }
                        $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel,
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                    $.post("https://inventory/SetInventoryData", JSON.stringify({
                        fromInventory: $fromInv.attr("data-inventory"),
                        toInventory: $toInv.attr("data-inventory"),
                        fromSlot: $fromSlot,
                        toSlot: $toSlot,
                        fromAmount: $toAmount,
                        otherLabel: otherLal,
                        toAmount: toData.amount,
                    }));
                } else {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-drag");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-nodrag");
                    $fromInv.find("[data-slot=" + $fromSlot + "]").removeData("item");
                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                    } else if ($fromSlot == 41 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                    }
                    $.post("https://inventory/SetInventoryData", JSON.stringify({
                        fromInventory: $fromInv.attr("data-inventory"),
                        toInventory: $toInv.attr("data-inventory"),
                        fromSlot: $fromSlot,
                        toSlot: $toSlot,
                        otherLabel: otherLal,
                        fromAmount: $toAmount,
                    }));
                }
                $.post("https://inventory/PlayDropSound", JSON.stringify({}));
            } else if (fromData.amount > $toAmount && (toData == undefined || toData == null) && $toInv.attr("data-inventory").split("-")[0] != "autoshop") {
                var newDataTo = [];
                newDataTo.name = fromData.name;
                newDataTo.label = fromData.label;
                newDataTo.amount = parseInt($toAmount);
                newDataTo.type = fromData.type;
                newDataTo.description = fromData.description;
                newDataTo.image = fromData.image;
                newDataTo.weight = fromData.weight;
                newDataTo.info = fromData.info;
                newDataTo.usable = fromData.usable;
                newDataTo.unique = fromData.unique;
                newDataTo.slot = parseInt($toSlot);
                $toInv.find("[data-slot=" + $toSlot + "]").data("item", newDataTo);
                $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");
                var ItemLabel = '<div class="item-slot-label"><p>' + newDataTo.label + "</p></div>";
                if (newDataTo.name.split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newDataTo.name)) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newDataTo.label + "</p></div>";
                    }
                } else if (itemdatas[newDataTo.name] || itemdatas[newDataTo.itemtype]) {
                    ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newDataTo.label + "</p></div>";
                }
                var image = newDataTo.image;
                var imagelink = '"images/' + image + '"';
                if (image.startsWith("https")) {
                    imagelink = image;
                }
                if ($toSlot < 6 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>' + $toSlot + '</p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + newDataTo.name + '" /></div><div class="item-slot-amount"><p>' + newDataTo.amount + '</div><div class="item-slot-name"><p>' + " " + ((newDataTo.weight * newDataTo.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                } else if ($toSlot == 41 && $toInv.attr("data-inventory") == "player") {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + newDataTo.name + '" /></div><div class="item-slot-amount"><p>' + newDataTo.amount + '</div><div class="item-slot-name"><p>' + " " + ((newDataTo.weight * newDataTo.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                } else {
                    $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + newDataTo.name + '" /></div><div class="item-slot-amount"><p>' + newDataTo.amount + '</div><div class="item-slot-name"><p>' + " " + ((newDataTo.weight * newDataTo.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                }
                if (newDataTo.name.split("_")[0] == "weapon") {
                    if (!Inventory.IsWeaponBlocked(newDataTo.name)) {
                        if (newDataTo.info.quality == undefined) {
                            newDataTo.info.quality = 100.0;
                        }
                        var QualityColor = "rgb(15, 255, 213)";
                        if (newDataTo.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (newDataTo.info.quality > 25 && newDataTo.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (newDataTo.info.quality >= 50) {
                            QualityColor = "rgb(15, 255, 213)";
                        }
                        if (newDataTo.info.quality !== undefined) {
                            qualityLabel = newDataTo.info.quality.toFixed();
                        } else {
                            qualityLabel = newDataTo.info.quality;
                        }
                        if (newDataTo.info.quality == 0) {
                            qualityLabel = 100;
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                } else if (newDataTo.itemtype == "expiring") {
                    if (newDataTo.info.quality == undefined) {
                        newDataTo.info.quality = 100.0;
                    }
                    var QualityColor = "rgb(15, 255, 213)";
                    if (newDataTo.info.quality < 25) {
                        QualityColor = "rgb(192, 57, 43)";
                    } else if (newDataTo.info.quality > 25 && newDataTo.info.quality < 50) {
                        QualityColor = "rgb(230, 126, 34)";
                    } else if (newDataTo.info.quality >= 50) {
                        QualityColor = "rgb(15, 255, 213)";
                    }
                    if (newDataTo.info.quality !== undefined) {
                        qualityLabel = newDataTo.info.quality.toFixed();
                    } else {
                        qualityLabel = newDataTo.info.quality;
                    }
                    if (newDataTo.info.quality == 0) {
                        qualityLabel = 100;
                    }
                    $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                        width: qualityLabel + "%",
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                } else if (itemdatas[newDataTo.name]) {
                    let itemInfo = itemdatas[newDataTo.name];
                    let type = itemInfo.type;
                    let current = newDataTo.info[type];
                    let max = itemInfo.max;
                    let min = 100/max;
                    let percentage = current * min;
                    if (percentage == undefined) {
                        percentage = 100.0;
                    }
                    var QualityColor = "rgb(15, 255, 213)";
                    if (percentage < 25) {
                        QualityColor = "rgb(192, 57, 43)";
                    } else if (percentage > 25 && percentage < 50) {
                        QualityColor = "rgb(230, 126, 34)";
                    } else if (percentage >= 50) {
                        QualityColor = "rgb(15, 255, 213)";
                    }
                    if (percentage !== undefined) {
                        qualityLabel = percentage.toFixed() + "%";
                    } else {
                        qualityLabel = percentage + "%";
                    }
                    if (percentage == 0) {
                        qualityLabel = 100;
                    }
                    $toInv.find("[data-slot=" + $toSlot + "]").find(".item-slot-quality-bar").css({
                        width: qualityLabel,
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                }
                var newDataFrom = [];
                newDataFrom.name = fromData.name;
                newDataFrom.label = fromData.label;
                newDataFrom.amount = parseInt(fromData.amount - $toAmount);
                newDataFrom.type = fromData.type;
                newDataFrom.description = fromData.description;
                newDataFrom.image = fromData.image;
                newDataFrom.weight = fromData.weight;
                newDataFrom.price = fromData.price;
                newDataFrom.info = fromData.info;
                newDataFrom.usable = fromData.usable;
                newDataFrom.unique = fromData.unique;
                newDataFrom.slot = parseInt($fromSlot);
                $fromInv.find("[data-slot=" + $fromSlot + "]").data("item", newDataFrom);
                $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-drag");
                $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-nodrag");
                var image = newDataFrom.image;
                var imagelink = '"images/' + image + '"';
                if (image.startsWith("https")) {
                    imagelink = image;
                }
                if ($fromInv.attr("data-inventory").split("-")[0] == "itemshop") {
                    $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + '</div><div class="item-slot-name"><p>' + " $" + newDataFrom.price + '</p></div><div class="item-slot-label"><p>' + newDataFrom.label + "</p></div>");
                } else {
                    var ItemLabel = '<div class="item-slot-label"><p>' + newDataFrom.label + "</p></div>";
                    if (newDataFrom.name.split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newDataFrom.label + "</p></div>";
                        }
                    } else if (itemdatas[newDataFrom.name] || itemdatas[newDataFrom.itemtype]) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + newDataFrom.label + "</p></div>";
                    }
                    if ($fromSlot < 6 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>' + $fromSlot + '</p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + '</div><div class="item-slot-name"><p>' + " " + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                    } else if ($fromSlot == 41 && $fromInv.attr("data-inventory") == "player") {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + '</div><div class="item-slot-name"><p>' + " " + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                    } else {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + newDataFrom.name + '" /></div><div class="item-slot-amount"><p>' + newDataFrom.amount + '</div><div class="item-slot-name"><p>' + " " + ((newDataFrom.weight * newDataFrom.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                    }
                    if (newDataFrom.name.split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(newDataFrom.name)) {
                            if (newDataFrom.info.quality == undefined) {
                                newDataFrom.info.quality = 100.0;
                            }
                            var QualityColor = "rgb(15, 255, 213)";
                            if (newDataFrom.info.quality < 25) {
                                QualityColor = "rgb(192, 57, 43)";
                            } else if (newDataFrom.info.quality > 25 && newDataFrom.info.quality < 50) {
                                QualityColor = "rgb(230, 126, 34)";
                            } else if (newDataFrom.info.quality >= 50) {
                                QualityColor = "rgb(15, 255, 213)";
                            }
                            if (newDataFrom.info.quality !== undefined) {
                                qualityLabel = newDataFrom.info.quality.toFixed();
                            } else {
                                qualityLabel = newDataFrom.info.quality;
                            }
                            if (newDataFrom.info.quality == 0) {
                                qualityLabel = 100;
                            }
                            $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                                width: qualityLabel + "%",
                                "background-color": QualityColor,
                            }).find("p").html(qualityLabel);
                        }
                    } else if (newDataFrom.itemtype == "expiring") {
                        if (newDataFrom.info.quality == undefined) {
                            newDataFrom.info.quality = 100.0;
                        }
                        var QualityColor = "rgb(15, 255, 213)";
                        if (newDataFrom.info.quality < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (newDataFrom.info.quality > 25 && newDataFrom.info.quality < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (newDataFrom.info.quality >= 50) {
                            QualityColor = "rgb(15, 255, 213)";
                        }
                        if (newDataFrom.info.quality !== undefined) {
                            qualityLabel = newDataFrom.info.quality.toFixed();
                        } else {
                            qualityLabel = newDataFrom.info.quality;
                        }
                        if (newDataFrom.info.quality == 0) {
                            qualityLabel = 100;
                        }
                        $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    } else if (itemdatas[newDataFrom.name]) {
                        let itemInfo = itemdatas[newDataFrom.name];
                        let type = itemInfo.type;
                        let current = newDataFrom.info[type];
                        let max = itemInfo.max;
                        let min = 100/max;
                        let percentage = current * min;
                        if (percentage == undefined) {
                            percentage = 100.0;
                        }
                        var QualityColor = "rgb(15, 255, 213)";
                        if (percentage < 25) {
                            QualityColor = "rgb(192, 57, 43)";
                        } else if (percentage > 25 && percentage < 50) {
                            QualityColor = "rgb(230, 126, 34)";
                        } else if (percentage >= 50) {
                            QualityColor = "rgb(15, 255, 213)";
                        }
                        if (percentage !== undefined) {
                            qualityLabel = percentage.toFixed() + "%";
                        } else {
                            qualityLabel = percentage + "%";
                        }
                        if (percentage == 0) {
                            qualityLabel = 100;
                        }
                        $fromInv.find("[data-slot=" + $fromSlot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel,
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                }
                $.post("https://inventory/PlayDropSound", JSON.stringify({}));
                $.post("https://inventory/SetInventoryData", JSON.stringify({
                    fromInventory: $fromInv.attr("data-inventory"),
                    toInventory: $toInv.attr("data-inventory"),
                    fromSlot: $fromSlot,
                    toSlot: $toSlot,
                    otherLabel: otherLal,
                    fromAmount: $toAmount,
                }));
            } else {
                if ($toInv.attr("data-inventory").split("-")[0] == "autoshop") {
                    if (fromData.name == toData.name) {
                        $fromInv.find("[data-slot=" + $fromSlot + "]").removeClass("item-drag");
                        $fromInv.find("[data-slot=" + $fromSlot + "]").addClass("item-nodrag");
                        $fromInv.find("[data-slot=" + $fromSlot + "]").removeData("item");
                        $fromInv.find("[data-slot=" + $fromSlot + "]").html('<div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div>');
                        var newDataTo = [];
                        var new_amount = toData.amount + fromData.amount;
                        newDataTo.name = fromData.name;
                        newDataTo.label = fromData.label;
                        newDataTo.amount = parseInt(new_amount);
                        newDataTo.type = fromData.type;
                        newDataTo.description = fromData.description;
                        newDataTo.image = fromData.image;
                        newDataTo.weight = fromData.weight;
                        newDataTo.info = fromData.info;
                        newDataTo.usable = fromData.usable;
                        newDataTo.unique = fromData.unique;
                        newDataTo.slot = parseInt($toSlot);
                        $toInv.find("[data-slot=" + $toSlot + "]").data("item", newDataTo);
                        $toInv.find("[data-slot=" + $toSlot + "]").addClass("item-drag");
                        $toInv.find("[data-slot=" + $toSlot + "]").removeClass("item-nodrag");
                        var image = newDataTo.image;
                        var imagelink = '"images/' + image + '"';
                        if (image.startsWith("https")) {
                            imagelink = image;
                        }
                        $toInv.find("[data-slot=" + $toSlot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + newDataTo.name + '" /></div><div class="item-slot-amount"><p>' + newDataTo.amount + '</div><div class="item-slot-name"><p>' + " " + ((newDataTo.weight * newDataTo.amount) / 1000).toFixed(1) + "</p></div><div class='item-slot-label'><p>" + newDataTo.label + "</p></div>");
                        $.post("https://inventory/PlayDropSound", JSON.stringify({}));
                        $.post("https://inventory/SetInventoryData", JSON.stringify({
                            fromInventory: $fromInv.attr("data-inventory"),
                            toInventory: $toInv.attr("data-inventory"),
                            fromSlot: $fromSlot,
                            toSlot: $toSlot,
                            otherLabel: otherLal,
                            fromAmount: $toAmount,
                        }));
                    } else {
                        InventoryError($fromInv, $fromSlot, "Item already exists!");
                        return;
                    }
                } else {
                    InventoryError($fromInv, $fromSlot, "Items cannot get stacked!");
                    return;
                }
            }
        }
    }
    handleDragDrop();
}

function isItemAllowed(item, allowedItems) {
    var retval = false;
    $.each(allowedItems, function (index, i) {
        if (i == item) {
            retval = true;
        }
    });
    return retval;
}

function InventoryError($elinv, $elslot, notify) {
    $elinv.find("[data-slot=" + $elslot + "]").css("background", "rgba(156, 20, 20, 0.5)").css("transition", "background 500ms");
    setTimeout(function () {
        $elinv.find("[data-slot=" + $elslot + "]").css("background", "rgba(255, 255, 255, 0.3)");
    }, 500);
    $.post("https://inventory/PlayDropFail", JSON.stringify({}));
    DoNotify(notify)
}

function DoNotify(text) {
    $(".notify").css("opacity", "1.0");
    $(".notify").fadeIn(150);
    $(".notify-title").html("<p><strong> Notification </strong></p>");
    $(".notify-description").html("<p><strong>"+text+"</strong></p>");
    setTimeout(function() {
        $(".notify").fadeOut(350);
        setTimeout(function() {
            $(".notify").css("opacity", "0.0");
            $(".notify-title").html("");
            $(".notify-description").html("");
        }, 600);
    }, 4000);
}

var requiredItemOpen = false;

(() => {
    Inventory = {};
    Inventory.slots = 40;
    Inventory.dropslots = 30;
    Inventory.droplabel = "Drop";
    Inventory.dropmaxweight = 100000;
    Inventory.opened = false;

    Inventory.Error = function () {
        $.post("https://inventory/PlayDropFail", JSON.stringify({}));
    };

    Inventory.IsWeaponBlocked = function (WeaponName) {
        var DurabilityBlockedWeapons = [
            "weapon_unarmed",
            "weapon_stickybomb",
        ];
        var retval = false;
        $.each(DurabilityBlockedWeapons, function (i, name) {
            if (name == WeaponName) {
                retval = true;
            }
        });
        return retval;
    };

    Inventory.QualityCheck = function (item, IsHotbar, IsOtherInventory) {
        if (item.name.split("_")[0] == "weapon") {
            if (!Inventory.IsWeaponBlocked(item.name)) {
                if (item.info.quality == undefined) {
                    item.info.quality = 100;
                }
                var QualityColor = "rgb(15, 255, 213)";
                if (item.info.quality < 25) {
                    QualityColor = "rgb(192, 57, 43)";
                } else if (item.info.quality > 25 && item.info.quality < 50) {
                    QualityColor = "rgb(230, 126, 34)";
                } else if (item.info.quality >= 50) {
                    QualityColor = "rgb(15, 255, 213)";
                }
                if (item.info.quality !== undefined) {
                    qualityLabel = item.info.quality.toFixed();
                } else {
                    qualityLabel = item.info.quality;
                }
                if (item.info.quality == 0) {
                    qualityLabel = "BROKEN";
                    if (!IsOtherInventory) {
                        if (!IsHotbar) {
                            $(".player-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                                width: "100%",
                                "background-color": QualityColor,
                            }).find("p").html(qualityLabel);
                        } else {
                            $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                                width: "100%",
                                "background-color": QualityColor,
                            }).find("p").html(qualityLabel);
                        }
                    } else {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: "100%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                } else {
                    if (!IsOtherInventory) {
                        if (!IsHotbar) {
                            $(".player-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                                width: qualityLabel + "%",
                                "background-color": QualityColor,
                            }).find("p").html(qualityLabel);
                        } else {
                            $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                                width: qualityLabel + "%",
                                "background-color": QualityColor,
                            }).find("p").html(qualityLabel);
                        }
                    } else {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                }
            }
        } else if (item.itemtype == "expiring") {
            if (item.info.quality == undefined) {
                item.info.quality = 100;
            }
            var QualityColor = "rgb(15, 255, 213)";
            if (item.info.quality < 25) {
                QualityColor = "rgb(192, 57, 43)";
            } else if (item.info.quality > 25 && item.info.quality < 50) {
                QualityColor = "rgb(230, 126, 34)";
            } else if (item.info.quality >= 50) {
                QualityColor = "rgb(15, 255, 213)";
            }
            if (item.info.quality !== undefined) {
                qualityLabel = item.info.quality.toFixed();
            } else {
                qualityLabel = item.info.quality;
            }
            if (item.info.quality == 0) {
                qualityLabel = "ROTTEN";
                if (!IsOtherInventory) {
                    if (!IsHotbar) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: "100%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    } else {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: "100%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                } else {
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                        width: "100%",
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                }
            } else {
                if (!IsOtherInventory) {
                    if (!IsHotbar) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    } else {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                } else {
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                        width: qualityLabel + "%",
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                }
            }
        } else if (itemdatas[item.name]) {
            let itemInfo = itemdatas[item.name];
            let type = itemInfo.type;
            let current = item.info[type];
            let max = itemInfo.max;
            let min = 100/max;
            let percentage = current * min;
            if (percentage == undefined) {
                percentage = 100;
            }
            var QualityColor = "rgb(15, 255, 213)";
            if (percentage < 25) {
                QualityColor = "rgb(192, 57, 43)";
            } else if (percentage > 25 && percentage < 50) {
                QualityColor = "rgb(230, 126, 34)";
            } else if (percentage >= 50) {
                QualityColor = "rgb(15, 255, 213)";
            }
            if (percentage !== undefined) {
                qualityLabel = percentage.toFixed();
            } else {
                qualityLabel = percentage;
            }
            if (percentage == 0) {
                qualityLabel = "BROKEN";
                if (!IsOtherInventory) {
                    if (!IsHotbar) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: "100%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    } else {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: "100%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                } else {
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                        width: "100%",
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                }
            } else {
                if (!IsOtherInventory) {
                    if (!IsHotbar) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    } else {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                } else {
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                        width: qualityLabel + "%",
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                }
            }
        } else if (itemdatas[item.itemtype]) {
            let itemInfo = itemdatas[item.itemtype];
            let type = itemInfo.type;
            let current = item.info[type];
            let max = itemInfo.max;
            let min = 100/max;
            let percentage = current * min;
            if (percentage == undefined) {
                percentage = 100;
            }
            var QualityColor = "rgb(15, 255, 213)";
            if (percentage < 25) {
                QualityColor = "rgb(192, 57, 43)";
            } else if (percentage > 25 && percentage < 50) {
                QualityColor = "rgb(230, 126, 34)";
            } else if (percentage >= 50) {
                QualityColor = "rgb(15, 255, 213)";
            }
            if (percentage !== undefined) {
                qualityLabel = percentage.toFixed();
            } else {
                qualityLabel = percentage;
            }
            if (percentage == 0) {
                qualityLabel = "BROKEN";
                if (!IsOtherInventory) {
                    if (!IsHotbar) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: "100%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    } else {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: "100%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                } else {
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                        width: "100%",
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                }
            } else {
                if (!IsOtherInventory) {
                    if (!IsHotbar) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    } else {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                            width: qualityLabel + "%",
                            "background-color": QualityColor,
                        }).find("p").html(qualityLabel);
                    }
                } else {
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").find(".item-slot-quality-bar").css({
                        width: qualityLabel + "%",
                        "background-color": QualityColor,
                    }).find("p").html(qualityLabel);
                }
            }
        }
    };

    Inventory.UpdateMoney = function (data) {
        $("#player-inv-money").html('<i class="fas fa-wallet"></i> ' + data.money);
    };

    Inventory.Open = function (data) {
        totalWeight = 0;
        totalWeightOther = 0;
        myMoney = data.money;
        $(".player-inventory").find(".item-slot").remove();
        $(".other-inventory").find(".item-slot").remove();
        $(".ply-hotbar-inventory").find(".item-slot").remove();
        $(".ply-iteminfo-container").css("opacity", "0.0");
        $(".notify").css("opacity", "0.0");
        if (requiredItemOpen) {
            $(".requiredItem-container").hide();
            requiredItemOpen = false;
        }
        $("#qbcore-inventory").fadeIn(300);
        if (data.other != null && data.other != "") {
            $(".other-inventory").attr("data-inventory", data.other.name);
            otherMoney = data.other.money;
        } else {
            $(".other-inventory").attr("data-inventory", 0);
        }
        for (i = 1; i < 6; i++) {
            $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-key"><p>' + i + '</p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
        }
        for (i = 6; i < data.slots + 1; i++) {
            if (i == 41) {
                $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            } else {
                $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }
        }
        $("#player-inv-money").html('<i class="fas fa-wallet"></i> ' + myMoney);
        $("#other-inv-money").html('');
        if (data.other != null && data.other != "") {
            for (i = 1; i < data.other.slots + 1; i++) {
                $(".other-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }
        } else {
            for (i = 1; i < Inventory.dropslots + 1; i++) {
                $(".other-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }
            $(".other-inventory .item-slot").css({ "background-color": "rgba(0, 0, 0, 0.3)" });
        }
        if (data.inventory !== null) {
            $.each(data.inventory, function (i, item) {
                if (item != null) {
                    totalWeight += item.weight * item.amount;
                    var ItemLabel = '<div class="item-slot-label"><p>' + item.label + "</p></div>";
                    if (item.name.split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + "</p></div>";
                        }
                    } else if (itemdatas[item.itemtype] || itemdatas[item.name]) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + "</p></div>";
                    }
                    var image = item.image;
                    var imagelink = '"images/' + image + '"';
                    if (image.startsWith("https")) {
                        imagelink = image;
                    }
                    if (item.slot < 6) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>' + item.slot + '</p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + '</div><div class="item-slot-name"><p>' + " " + ((item.weight * item.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    } else if (item.slot == 41) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + '</div><div class="item-slot-name"><p>' + " " + ((item.weight * item.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    } else {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + '</div><div class="item-slot-name"><p>' + " " + ((item.weight * item.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    }
                    Inventory.QualityCheck(item, false, false);
                }
            });
        }
        if (data.other != null && data.other != "" && data.other.inventory != null) {
            $.each(data.other.inventory, function (i, item) {
                if (item != null) {
                    totalWeightOther += item.weight * item.amount;
                    var ItemLabel = '<div class="item-slot-label"><p>' + item.label + "</p></div>";
                    if (item.name.split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + "</p></div>";
                        }
                    } else if (itemdatas[item.itemtype] || itemdatas[item.name]) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + "</p></div>";
                    }
                    var image = item.image;
                    var imagelink = '"images/' + image + '"';
                    if (image.startsWith("https")) {
                        imagelink = image;
                    }
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                    if (item.price != null) {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + '</div><div class="item-slot-name"><p>' + " $" + item.price + "</p></div>" + ItemLabel);
                    } else {
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + '</div><div class="item-slot-name"><p>' + " " + ((item.weight * item.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                    }
                    $(".other-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    Inventory.QualityCheck(item, false, true);
                }
            });
        }
        var per = (totalWeight / 1000) / (data.maxweight / 100000)
        $(".pro").css("width", per + "%");
        $(".pro_black").css("width", (100 - per) + "%");
        $("#player-inv-weight").html('<i class="fas fa-dumbbell"></i> ' + (totalWeight / 1000).toFixed(2) + "/" + (data.maxweight / 1000).toFixed(2));
        playerMaxWeight = data.maxweight;
        if (data.other != null) {
            var name = data.other.name.toString();
            if (name.split("-")[0] == "otherplayer") {
                $("#other-inv-money").html('<i class="fas fa-wallet"> </i>' + data.otherMoney);
            }
            if (name != null && (name.split("-")[0] == "itemshop" || name == "crafting" || name == "itemshop" || name.split("-")[0] == "autoshop")) {
                $("#other-inv-label").html(data.other.label);
            } else {
                $("#other-inv-label").html(data.other.label);
                $("#other-inv-weight").html('<i class="fas fa-dumbbell"></i> ' + (totalWeightOther / 1000).toFixed(2) + "/" + (data.other.maxweight / 1000).toFixed(2));
            }
            otherMaxWeight = data.other.maxweight;
            otherLabel = data.other.label;
            var per1 = (totalWeightOther / 1000) / (otherMaxWeight / 100000)
            $(".pro1").css("width", per1 + "%");
            $(".pro1_black").css("width", (100 - per1) + "%");
        } else {
            $("#other-inv-label").html(Inventory.droplabel);
            $("#other-inv-weight").html('<i class="fas fa-dumbbell"></i> ' + (totalWeightOther / 1000).toFixed(2) + "/" + (Inventory.dropmaxweight / 1000).toFixed(2));
            otherMaxWeight = Inventory.dropmaxweight;
            otherLabel = Inventory.droplabel;
            var per1 = (totalWeightOther / 1000) / (otherMaxWeight / 100000)
            $(".pro1").css("width", per1 + "%");
            $(".pro1_black").css("width", (100 - per1) + "%");
        }
        $.each(data.maxammo, function (index, ammo_type) {
            $("#" + index + "_ammo").find(".ammo-box-amount").css({ height: "0%" });
        });
        if (data.Ammo !== null) {
            $.each(data.Ammo, function (i, amount) {
                var Handler = i.split("_");
                var Type = Handler[1].toLowerCase();
                if (amount > data.maxammo[Type]) {
                    amount = data.maxammo[Type];
                }
                var Percentage = (amount / data.maxammo[Type]) * 100;
                $("#" + Type + "_ammo").find(".ammo-box-amount").css({ height: Percentage + "%" });
                $("#" + Type + "_ammo").find("span").html(amount + "x");
            });
        }
        handleDragDrop();
        Inventory.opened = true;
    };

    Inventory.Close = function () {
        cancelChoosePlayer()
        $(".item-slot").css("border", "1px solid rgba(255, 255, 255, 0.1)");
        $(".ply-hotbar-inventory").css("display", "block");
        $("#player-inv-money").html('');
        $("#other-inv-money").html('');
        $(".ply-iteminfo-container").fadeOut(100);
        $(".notify").fadeOut(100);
        $("#qbcore-inventory").fadeOut(300);
        $(".combine-option-container").hide();
        $(".compost-option-container").hide();
        $(".item-slot").remove();
        // $(".player-inventory").find(".item-slot").remove();
        // $(".other-inventory").find(".item-slot").remove();
        $.post("https://inventory/CloseInventory", JSON.stringify({}));
        if (AttachmentScreenActive) {
            $("#qbcore-inventory").css({ left: "0vw" });
            $(".weapon-attachments-container").css({ left: "-100vw" });
            AttachmentScreenActive = false;
        }
        if (ClickedItemData !== null) {
            $("#weapon-attachments").fadeOut(250, function () {
                $("#weapon-attachments").remove();
                ClickedItemData = {};
            });
        }
        Inventory.opened = false;
    };

    Inventory.Update = function (data, other) {
        if (!other || other != "other") {
            totalWeight = 0;
            totalWeightOther = 0;
            $(".player-inventory").find(".item-slot").remove();
            $(".ply-hotbar-inventory").find(".item-slot").remove();
            $(".ply-iteminfo-container").css("opacity", "0.0");
            $(".notify").css("opacity", "0.0");
            if (data.error) {
                Inventory.Error();
            }
            for (i = 1; i < data.slots + 1; i++) {
                if (i == 41) {
                    $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
                } else {
                    $(".player-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
                }
            }
            $.each(data.inventory, function (i, item) {
                if (item != null) {
                    totalWeight += item.weight * item.amount;
                    var ItemLabel = '<div class="item-slot-label"><p>' + item.label + "</p></div>";
                    if (item.name.split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + "</p></div>";
                        }
                    } else if (itemdatas[item.itemtype] || itemdatas[item.name]) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + "</p></div>";
                    }
                    var image = item.image;
                    var imagelink = '"images/' + image + '"';
                    if (image.startsWith("https")) {
                        imagelink = image;
                    }
                    if (item.slot < 6) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>' + item.slot + '</p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + '</div><div class="item-slot-name"><p>' + " " + ((item.weight * item.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    } else if (item.slot == 41) {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-key"><p>6 <i class="fas fa-lock"></i></p></div><div class="item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + '</div><div class="item-slot-name"><p>' + " " + ((item.weight * item.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    } else {
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + '</div><div class="item-slot-name"><p>' + " " + ((item.weight * item.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                        $(".player-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                    }
                    Inventory.QualityCheck(item, false, false);
                }
            });
            var per = (totalWeight / 1000) / (data.maxweight / 100000)
            $(".pro").css("width", per + "%");
            $(".pro_black").css("width", (100 - per) + "%");
            $("#player-inv-weight").html('<i class="fas fa-dumbbell"></i> ' + (totalWeight / 1000).toFixed(2) + "/" + (data.maxweight / 1000).toFixed(2));
            if (data.updatemoney == "main") {
                $("#player-inv-money").html('<i class="fas fa-wallet"></>' + data.money);
            } else if (data.updatemoney == "other") {
                $("#other-inv-money").html('<i class="fas fa-wallet"></>' + data.money);
            } else if (data.updatemoney == "shop") {
                $("#player-inv-money").html('');
                $("#other-inv-money").html('<i class="fas fa-wallet"></>' + data.money);
            }

            handleDragDrop();
        } else {
            data = data.data;
            totalWeightOther = 0;
            $(".other-inventory").find(".item-slot").remove();
            $(".ply-iteminfo-container").css("opacity", "0.0");
            $(".notify").css("opacity", "0.0");
            for (i = 1; i < data.slots + 1; i++) {
                $(".other-inventory").append('<div class="item-slot" data-slot="' + i + '"><div class="item-slot-img"></div><div class="item-slot-label"><p>&nbsp;</p></div></div>');
            }
            if (data != null && data != "" && data.items != null) {
                let otherInv = data.items;
                $.each(otherInv, function (i, item) {
                    if (item != null) {
                        totalWeightOther += item.weight * item.amount;
                        var ItemLabel = '<div class="item-slot-label"><p>' + item.label + "</p></div>";
                        if (item.name.split("_")[0] == "weapon") {
                            if (!Inventory.IsWeaponBlocked(item.name)) {
                                ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + "</p></div>";
                            }
                        } else if (itemdatas[item.itemtype] || itemdatas[item.name]) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + "</p></div>";
                        }
                        var image = item.image;
                        var imagelink = '"images/' + image + '"';
                        if (image.startsWith("https")) {
                            imagelink = image;
                        }
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").addClass("item-drag");
                        if (item.price != null) {
                            $(".other-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + '</div><div class="item-slot-name"><p>' + " $" + item.price + "</p></div>" + ItemLabel);
                        } else {
                            $(".other-inventory").find("[data-slot=" + item.slot + "]").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div><div class="item-slot-amount"><p>' + item.amount + '</div><div class="item-slot-name"><p>' + " " + ((item.weight * item.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                        }
                        $(".other-inventory").find("[data-slot=" + item.slot + "]").data("item", item);
                        Inventory.QualityCheck(item, false, true);
                    }
                });
            }
            $("#other-inv-label").html(data.label);
            $("#other-inv-weight").html('<i class="fas fa-dumbbell"></i> ' + (totalWeightOther / 1000).toFixed(2) + "/" + (data.maxweight / 1000).toFixed(2));
            var per1 = (totalWeightOther / 1000) / (data.maxweight / 100000)
            $(".pro1").css("width", per1 + "%");
            $(".pro1_black").css("width", (100 - per1) + "%");
            setTimeout(function () {
                handleDragDrop();
            }, 50);
        }
    };

    Inventory.ShowLicense = function (data) {
        $("#nearPlayers").html("");
        $("#id-card").fadeIn(300);
        $('#id-card').css('background', 'url(idcard/'+data.type+'.png)');
        $('#firstname').text(data.firstname);
        $('#lastname').text(data.lastname);
        $('#dob').text(data.birthdate);
        let gender = "ΑΡΡΕΝ"
        if (data.sex == "f" || data.sex == "F") {
            gender = "ΘΥΛΗ"
        }
        $('#sex').text(gender);
        $('#outline').html("");
        html_footer = "<ul>";
        for (let i=0; i<data.licenses.length; i++) {
            html_footer += "<li>" + data.licenses[i] + "</li>";
        }
        html_footer += "</ul>";
        $("#outline").append(html_footer);
        $("#nearPlayers").append('<button class="nearbyPlayerButton" data-player="' + data.id + '"><img src="https://nui-img/' + data.mugshot +'/' + data.mugshot +'?t=' + Date.getUtcEpochTimestamp() + '" width="90px" height="90px"/></button>');
    };

    Inventory.HideLicense = function() {
        $("#id-card").fadeOut(300);
        $("#id-card").css({display:"none"});
        $("#nearPlayers").html("");
        $('#outline').html("");
    };

    Inventory.ShowID = function (data) {
        $("#nearPlayers").html("");
        $("#id-card").fadeIn(300);
        $('#id-card').css('background', 'url(idcard/id_card.png)');
        $('#firstname').text(data.firstname);
        $('#lastname').text(data.lastname);
        $('#dob').text(data.birthdate);
        let gender = "ΑΡΡΕΝ"
        if (data.sex == "f" || data.sex == "F") {
            gender = "ΘΥΛΗ"
        }
        $('#sex').text(gender);
        $("#nearPlayers").append('<button class="nearbyPlayerButton" data-player="' + data.id + '"><img src="https://nui-img/' + data.mugshot +'/' + data.mugshot +'?t=' + Date.getUtcEpochTimestamp() + '" width="90px" height="90px"/></button>');
    };

    Inventory.HideID = function() {
        $("#id-card").fadeOut(300);
        $("#id-card").css({ display: "none" });
        $("#nearPlayers").html("");
    };

    Inventory.ToggleHotbar = function (data) {
        if (data.open) {
            $(".z-hotbar-inventory").html("");
            for (i = 1; i < 6; i++) {
                var elem = '<div class="z-hotbar-item-slot" data-zhotbarslot="' + i + '"> <div class="z-hotbar-item-slot-key"><p>' + i + '</p></div><div class="z-hotbar-item-slot-img"></div><div class="z-hotbar-item-slot-label"><p>&nbsp;</p></div></div>';
                $(".z-hotbar-inventory").append(elem);
            }
            var elem = '<div class="z-hotbar-item-slot" data-zhotbarslot="41"> <div class="z-hotbar-item-slot-key"><p>6 <i style="top: -62px; left: 58px;" class="fas fa-lock"></i></p></div><div class="z-hotbar-item-slot-img"></div><div class="z-hotbar-item-slot-label"><p>&nbsp;</p></div></div>';
            $(".z-hotbar-inventory").append(elem);
            $.each(data.items, function (i, item) {
                if (item != null) {
                    var ItemLabel = '<div class="item-slot-label"><p>' + item.label + "</p></div>";
                    if (item.name.split("_")[0] == "weapon") {
                        if (!Inventory.IsWeaponBlocked(item.name)) {
                            ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + "</p></div>";
                        }
                    } else if (itemdatas[item.itemtype] || itemdatas[item.name]) {
                        ItemLabel = '<div class="item-slot-quality"><div class="item-slot-quality-bar"><p>100</p></div></div><div class="item-slot-label"><p>' + item.label + "</p></div>";
                    }
                    var image = item.image;
                    var imagelink = '"images/' + image + '"';
                    if (image.startsWith("https")) {
                        imagelink = image;
                    }
                    if (item.slot == 41) {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").html('<div class="z-hotbar-item-slot-key"><p>6 <i style="top: -62px; left: 58px;" class="fas fa-lock"></i></p></div><div class="z-hotbar-item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div><div class="z-hotbar-item-slot-amount"><p>' + item.amount + '</div><div class="z-hotbar-item-slot-amount-name"><p>' + " " + ((item.weight * item.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                    } else {
                        $(".z-hotbar-inventory").find("[data-zhotbarslot=" + item.slot + "]").html('<div class="z-hotbar-item-slot-key"><p>' + item.slot + '</p></div><div class="z-hotbar-item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div><div class="z-hotbar-item-slot-amount"><p>' + item.amount + '</div><div class="z-hotbar-item-slot-amount-name"><p>' + " " + ((item.weight * item.amount) / 1000).toFixed(1) + "</p></div>" + ItemLabel);
                    }
                    Inventory.QualityCheck(item, true, false);
                }
            });
            $(".z-hotbar-inventory").fadeIn(150);
        } else {
            $(".z-hotbar-inventory").fadeOut(150, function () {
                $(".z-hotbar-inventory").html("");
            });
        }
    };

    Inventory.UseItem = function (data) {
        $(".itembox-container").hide();
        $(".itembox-container").fadeIn(250);
        $("#itembox-action").html("<p>Used 1x</p>");
        $("#itembox-label").html("<p>" + data.item.label + "</p>");
        var image = data.item.image;
        var imagelink = '"images/' + image + '"';
        if (image.startsWith("https")) {
            imagelink = image;
        }
        $("#itembox-image").html('<div class="item-slot-img"><img src=' + imagelink + '" alt="' + data.item.name + '" /></div>');
        setTimeout(function () {
            $(".itembox-container").fadeOut(250);
        }, 2000);
    };
    var itemBoxtimer = null;
    var requiredTimeout = null;
    Inventory.itemBox = function (data) {
        if (itemBoxtimer !== null) {
            clearTimeout(itemBoxtimer);
        }
        var type = "Used " + data.itemAmount + "x";
        if (data.type == "add") {
            type = "Received " + data.itemAmount + "x";
        } else if (data.type == "remove") {
            type = "Removed " + data.itemAmount + "x";
        }
        var $itembox = $(".itembox-container.template").clone();
        $itembox.removeClass("template");
        var image = data.item.image;
        var imagelink = '"images/' + image + '"';
        if (image.startsWith("https")) {
            imagelink = image;
        }
        $itembox.html('<div id="itembox-action"><p>' + type + '</p></div><div id="itembox-label"><p>' + data.item.label + '</p></div><div class="item-slot-img-itembox"><img src=' + imagelink + '" alt="' + data.item.name + '" /></div>');
        $(".itemboxes-container").prepend($itembox);
        $itembox.fadeIn(250);
        var time = 3000;
        if (data.type === "use") {
            time = 1250;
        }
        setTimeout(function () {
            $.when($itembox.fadeOut(300)).done(function () {
                $itembox.remove();
            });
        }, time);
    };

    Inventory.ShowButton = function (label) {
        $(".compost-option-container").fadeIn(100);
    };

    Inventory.RequiredItem = function (data) {
        if (requiredTimeout !== null) {
            clearTimeout(requiredTimeout);
        }
        if (data.toggle) {
            if (!requiredItemOpen) {
                $(".requiredItem-container").html("");
                $.each(data.items, function (index, item) {
                    var image = item.image;
                    var imagelink = '"images/' + image + '"';
                    if (image.startsWith("https")) {
                        imagelink = image;
                    }
                    var element = '<div class="requiredItem-box"><div id="requiredItem-action">Required</div><div id="requiredItem-label"><p>' + item.label + ' x ' + item.amount + ' ' + '</p></div><div id="requiredItem-image"><div class="item-slot-img"><img src=' + imagelink + '" alt="' + item.name + '" /></div></div></div>';
                    $(".requiredItem-container").hide();
                    $(".requiredItem-container").append(element);
                    $(".requiredItem-container").fadeIn(100);
                });
                requiredItemOpen = true;
            }
        } else {
            $(".requiredItem-container").fadeOut(100);
            requiredTimeout = setTimeout(function () {
                $(".requiredItem-container").html("");
                requiredItemOpen = false;
            }, 100);
        }
    };

    Inventory.isOpened = () => {
        return Inventory.opened;
    };
    Inventory.SaveIDCardData = (data) => {
        let id_card_data = data.value;
        id_card_info = {
            firstname : id_card_data.firstname,
            lastname : id_card_data.lastname,
            sex : id_card_data.sex,
            dob : id_card_data.dob,
            height : id_card_data.height
        }
    };
    Inventory.Mugshots = (itemData, type) => {
        $.post(`https://inventory/requestNearbyPlayers`, {}, function(data) {
            let nearbyPlayers = data;
            let tempChoosePlayer = templateChoosePlayer;
            let tempOptions = '<div class="playersImgsNobody">Nobody is nearby</div>';
            if (nearbyPlayers.length > 0) {
                tempOptions = '';
                cancelChoosePlayer()
                for (i = 0; i < nearbyPlayers.length; i++) {
                    let playerId = parseInt(nearbyPlayers[i].pId);
                    if (!isNaN(playerId) && Number.isInteger(playerId) && playerId > 0) {
                        let tempOption = templateChoosePlayerImg;
                        tempOption = tempOption.replace(/%playerId%/g, playerId);
                        let tempUrl = 'https://nui-img/' + nearbyPlayers[i].pHeadshotTxd + '/' + nearbyPlayers[i].pHeadshotTxd + '?t=' + String(Math.round(new Date().getTime() / 1000));
                        if (nearbyPlayers[i].pHeadshotTxd == 'none') {
                            tempUrl = 'img/itemNone.png';
                        }
                        if (type === "item") {
                            let itemName = "'"+itemData.item.name+"'";
                            let itemAmount = "'"+itemData.amount+"'";
                            let itemSlot = "'"+itemData.item.slot+"'";
                            tempOption = tempOption.replace(/%itemName%/g, itemName);
                            tempOption = tempOption.replace(/%itemAmount%/g, itemAmount);
                            tempOption = tempOption.replace(/%itemSlot%/g, itemSlot);
                        } else if (type === "money") {
                            tempOption = tempOption.replace(/%itemName%/g, "'"+"money"+"'");
                            tempOption = tempOption.replace(/%itemAmount%/g, "'"+itemData.money+"'");
                            tempOption = tempOption.replace(/%itemSlot%/g, "0");
                        }
                        tempOption = tempOption.replace(/%itemType%/g, "'"+type+"'");
                        tempOption = tempOption.replace(/%playerHeadshotImgSrc%/g, tempUrl);
                        tempOptions += tempOption;
                    }
                }
            }
            tempChoosePlayer = tempChoosePlayer.replace(/%playersImgs%/g, tempOptions);
            $('body').append(tempChoosePlayer);
        });
    };

    window.onload = function (e) {
        window.addEventListener("message", function (event) {
            switch (event.data.action) {
                case "open":
                    Inventory.Open(event.data);
                    break;
                case "close":
                    $(".ply-iteminfo-container").css("opacity", "0.0");
                    $(".notify").css("opacity", "0.0");
                    Inventory.Close();
                    break;
                case "update":
                    Inventory.Update(event.data);
                    break;
                case "id_card_data":
                    Inventory.SaveIDCardData(event.data);
                    break;
                case "itemBox":
                    Inventory.itemBox(event.data);
                    break;
                case "requiredItem":
                    Inventory.RequiredItem(event.data);
                    break;
                case "toggleHotbar":
                    Inventory.ToggleHotbar(event.data);
                    break;
                case "updateMoney":
                    myMoney = event.data.money;
                    Inventory.UpdateMoney(event.data);
                    break;
                case "updateSecondInventoryMoney":
                    otherMoney = event.data.money;
                    break;
                case "updateSecondInventory":
                    Inventory.Update(event.data, "other");
                    break;
                case "composter":
                    Inventory.ShowButton(event.data, "Composter");
                    break;
                case "show_id":
                    Inventory.ShowID(event.data.values);
                    break;
                case "hide_id":
                    Inventory.HideID();
                    break;
                case "show_license":
                    Inventory.ShowLicense(event.data.values);
                    break;
                case "hide_license":
                    Inventory.HideLicense();
                    break;
                case "updateJob":
                    myJob = event.data.job;
                    myGrade = event.data.grade;
                    break;
                case "setConfigs":
                    itemdatas = event.data.data;
                    break;
                case "setColours":
                    vehColors = event.data.data;
                    break;
            }
        });
    };
})();

$(document).on("click", "#rob-money", (e) => {
    e.preventDefault();
    let amount = $("#item-amount").val();
    if (amount <= 0) {
        amount = 0;
    };
    amount = parseInt(amount);
    const TargetId = $(this).data("TargetId");
    var otherinventory = otherLabel.toLowerCase();
    $.post("https://inventory/RobMoney", JSON.stringify({
        target: TargetId,
        money: amount,
        inventory: otherinventory.split("-")[0]
    }));
});

$(document).on("click", "#give-money", (e) => {
    e.preventDefault();
    let amount = $("#item-amount").val();
    if (!amount || amount <= 0) {
        amount = 1;
    };
    amount = parseInt(amount);
    let itemData = {
        money: amount
    }
    Inventory.Mugshots(itemData, "money");
});

$("#item-give").droppable({
    hoverClass: "button-hover",
    drop: function (event, ui) {
        setTimeout(function () {
            IsDragging = false;
        }, 150);
        fromData = ui.draggable.data("item");
        fromInventory = ui.draggable.parent().attr("data-inventory");
        amount = $("#item-amount").val();
        if (amount == 0) {
            amount = fromData.amount;
        }
        var itemData = {}
        itemData.inventory = fromInventory
        itemData.item = fromData
        itemData.amount = parseInt(amount)
        Inventory.Mugshots(itemData, "item");
    },
});

function givetoPlayer(player, item, amount, slot, type) {
    if (type === "item") {
        let itemData = {
            name: item,
            amount: parseInt(amount),
            slot: parseInt(slot)
        }
        $.post("https://inventory/GiveItem", JSON.stringify({
            target: player,
            data: itemData,
        }));
    } else if (type === "money") {
        let itemData = {
            target: player,
            amount: parseInt(amount)
        }
        $.post("https://inventory/GiveMoney", JSON.stringify({
            target: itemData.target,
            money: itemData.amount
        }));
    }
    cancelChoosePlayer();
}

function cancelChoosePlayer() {
    if ($('#playerChooser').length > 0) {
        $('#playerChooser').each(function(index) {
            $(this).remove();
        });
    }
}

$(document).on("click", ".btn-cancel", (e) => {
    e.preventDefault();
    $(".inv-dialog-body").fadeOut(1000);
    $(".inv-dialog-body").hide();
});

var CurrentInventoryData = {};
var CurrentinvSlot = 0;

Inventory.Dialog = function(fromInv, toSlot) {
    CurrentInventoryData = fromInv
    $(".inv-dialog-body").fadeIn(500);
    $(".inv-dialog-body").css("display", "");
    CurrentinvSlot = toSlot
}

$(document).on("click", ".btn-confirm", (e) => {
    e.preventDefault();
    $(".inv-dialog-body").fadeOut(1000);
    $(".inv-dialog-body").hide();
    $.post("https://inventory/AutoSellSet", JSON.stringify({
        itemData: CurrentInventoryData,
        toSlot: CurrentinvSlot,
        amount: parseInt($("#item-amount").val()),
        money: parseInt($("#inv-dialog-amount").val()),
    }));
    CurrentInventoryData = {};
    CurrentinvSlot = 0;
});