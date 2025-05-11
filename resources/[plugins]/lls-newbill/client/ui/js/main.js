let bossPossibleItemData = null;

$(document).ready(function() {
    closeUI();

    $("html").disableSelection();
    
    window.addEventListener('message', (event) => {
        let data = event.data;
        
        if (data.action === "open") {
            closeUI();

            if (data.type === 'catalogue') {
                openCatalogue(data.shopData, data.itemsData);
            } else if (data.type === 'seller') {
                openSeller(data.shopData, data.itemsData);
            } else if (data.type === 'customer') {
                openCustomer(data.shopData, data.itemsData);
            } else if (data.type === 'boss') {
                openBoss(data.shopData, data.itemsData, data.possibleItemsData, data.bossBankMoney);
                initDraggable();
            }
            
            $("html").show();
            initCardHeight();

            $('img').on("error", function() {
                $(this).unbind("error").attr('src', 'img/itemNone.png');
            });
        }else if (data.action === "close") {
            closeUI();
        }
    });
});

$(document).resize(function() {
    initCardHeight();
});

$('body').on('blur', 'textarea, input', function(event) {
    $.post(`https://${GetParentResourceName()}/inputBlur`, JSON.stringify({}));
});

$('body').on('focus', 'textarea, input', function(event) {
    $.post(`https://${GetParentResourceName()}/inputFocus`, JSON.stringify({}));
});

function initDraggable() {
    $('#mainCardItemsContainer').sortable({disabled: true});

    $(".itemBossActionDrag").mousedown(function() {
        $("#mainCardItemsContainer").sortable("enable");
    });
    
    $(".itemBossActionDrag").mouseup(function() {
        $("#mainCardItemsContainer").sortable("disable");
    });
}

function initCardHeight() {
    let heightElem = 0
    heightElem += $("#mainCardShopLogo").outerHeight();
    heightElem += $("#mainCardItemsHeadlines").outerHeight();
    heightElem += $("#mainCardFooter").outerHeight();

    $("#mainCardItemsContainer").outerHeight($(document).outerHeight() * 0.8 - heightElem - 16);
}

function resetUI() {
    bossPossibleItemData = null;

    if ($('#playerChooser').length > 0) {
        $('#playerChooser').each(function(index) {
            $(this).remove();
        });
    }

    $("#shopImg img").attr("src", "");
    $("#shopName").html("");

    $("#mainCardItemsHeadlines").html("");
    $("#mainCardItemsContainer").html("");
    $("#mainCardFooter").html("");
}

function closeUI() {
    $("html").hide();
    resetUI();
}

function setShopData(shopData) {
    $("#shopImg img").attr("src", "img/shops/" + shopData.name + ".png");
    $("#shopName").html(shopData.label);
}

// CATALOGUE
function openCatalogue(shopData, itemData) {
    setShopData(shopData);

    initCatalogue(itemData);
}

function initCatalogue(itemData) {
    $("#mainCardItemsHeadlines").html(templateCatalogueItemHeadLines);

    for (let i = 0; i < itemData.length; i++) {
        let item = itemData[i];

        let temp = templateCatalogueItemElem;
        temp = temp.replace("%itemName%", item.label);
        temp = temp.replace("%itemImg%", "img/items/" + item.name + ".png");
        temp = temp.replace("%itemPrice%", item.price);

        $("#mainCardItemsContainer").append(temp);
    }
}

// SELLER
function openSeller(shopData, itemData) {
    setShopData(shopData);
    initSeller(itemData);
}

function initSeller(itemData) {
    $("#mainCardItemsHeadlines").html(templateSellerItemHeadLines);
    
    let tempDisable = "";
    for (let i = 0; i < itemData.length; i++) {
        let item = itemData[i];
    
        let temp = templateSellerItemElem;

        if (item.hasAmount > 0) {
            temp = temp.replace(/%itemAmountChooser%/g, templateSellerItemAmountChooser);
        }

        temp = temp.replace(/%itemName%/g, item.label);
        temp = temp.replace(/%itemDBName%/g, item.name);
        temp = temp.replace(/%itemImg%/g, "img/items/" + item.name + ".png");
        temp = temp.replace(/%itemIndex%/g, i);
        temp = temp.replace(/%itemPrice%/g, item.price);
        temp = temp.replace(/%itemMaxQuantity%/g, item.hasAmount);

        if (item.hasAmount > 0) {
            temp = temp.replace("%itemDisable%", "");

            $("#mainCardItemsContainer").append(temp);
        } else {
            temp = temp.replace("%itemDisable%", "itemDisable");
            temp = temp.replace("%itemAmountChooser%", "");

            tempDisable += temp;
        }
    }

    $("#mainCardItemsContainer").append(tempDisable);
    $("#mainCardFooter").html(templateSellerItemFooter);
}

function tipsInput() {
    let curValue = parseInt($("#tipsInput").val());
    
    // if (isNaN(tipsInput)) curValue = 0;
    
    if (curValue < 0) {
        curValue = 0;
    }
        
    $("#tipsInput").val(curValue);
}

function buttonQuantity(itemIndex, maxQuantity = Infinity, amount = 0) {
    if ($("#itemElem-" + itemIndex).hasClass("itemDisable")) {
        $("#itemElem-" + itemIndex + " .itemSellerQuantity").html("");
        return;
    }

    let curQuantity = parseInt($("#itemQuantity-" + itemIndex).val());
    if (isNaN(curQuantity)) curQuantity = 0;
    
    let newQuantity = curQuantity + amount;
    
    if (newQuantity < 0) {
        newQuantity = 0;
    }
    
    if (newQuantity > maxQuantity) {
        newQuantity = maxQuantity;
    }

    $("#itemQuantity-" + itemIndex).val(newQuantity);
    
    updateElementSumPrice();
}

function choosePlayerToBill() {
    if ($('#playerChooser').length > 0) {
        $('#playerChooser').each(function(index) {
            $(this).remove();
        });
    }
    
    $.post(`https://${GetParentResourceName()}/requestNearbyPlayers`, {}, function(data) {
        let nearbyPlayers = data;
        
        let tempChoosePlayer = templateChoosePlayer;
        let tempOptions = '<div class="playersImgsNobody">Nobody is nearby</div>';
        if (nearbyPlayers.length > 0) {
            tempOptions = '';

            for (i = 0; i < nearbyPlayers.length; i++) {
                let playerId = parseInt(nearbyPlayers[i].pId);
                
                if (!isNaN(playerId) && Number.isInteger(playerId) && playerId > 0) {
                    let tempOption = templateChoosePlayerImg;
                    tempOption = tempOption.replace(/%playerId%/g, playerId);

                    let tempUrl = 'https://nui-img/' + nearbyPlayers[i].pHeadshotTxd + '/' + nearbyPlayers[i].pHeadshotTxd + '?t=' + String(Math.round(new Date().getTime() / 1000));
                    if (nearbyPlayers[i].pHeadshotTxd == 'none') {
                        tempUrl = 'img/itemNone.png';   
                    }
                    tempOption = tempOption.replace(/%playerHeadshotImgSrc%/g, tempUrl);

                    tempOptions += tempOption;
                }
            }
        }

        tempChoosePlayer = tempChoosePlayer.replace(/%playersImgs%/g, tempOptions);    

        $('body').append(tempChoosePlayer);    
    });
}

function bill(playerId) {
    if (isNaN(playerId) || !Number.isInteger(playerId) || playerId <= 0) return;
    
    let itemsData = [];
    $(".itemElement").each(function(i) {
        if (!$("#itemElem-" + i).hasClass("itemDisable")) {
            let name = $("#itemElem-" + i + " .itemLogo .itemLogoText").attr("data-itemName");
            let quantity = parseInt($("#itemQuantity-" + i).val());
            
            if (name != "" && !isNaN(quantity) && Number.isInteger(quantity) && quantity > 0) {
                itemsData.push({name: name, quantity: quantity});
            }
        }
    });
    
    if (itemsData.length <= 0 || playerId <= 0) {
        return;
    }
    
    $.post(`https://${GetParentResourceName()}/getResult`, JSON.stringify({
        type: "bill",
        playerId: playerId,
        itemsData: itemsData
    }));

    closeUI();
}

// CUSTOMER
function openCustomer(shopData, itemData) {
    setShopData(shopData);

    initCustomer(itemData);
}

function initCustomer(itemData) {
    $("#mainCardItemsHeadlines").html(templateCustomerItemHeadLines);
    
    for (let i = 0; i < itemData.length; i++) {
        let item = itemData[i];

        let temp = templateCustomerItemElem;
        temp = temp.replace("%itemName%", item.label);
        temp = temp.replace("%itemImg%", "img/items/" + item.name + ".png");
        temp = temp.replace("%itemQuantity%", item.quantity);
        temp = temp.replace(/%itemIndex%/g, i);
        temp = temp.replace("%itemPrice%", item.price);
        
        $("#mainCardItemsContainer").append(temp);
    }
    
    $("#mainCardFooter").html(templateCustomerItemFooter);

    updateElementSumPrice();
}

function pay() {
    let tips = parseInt($("#tipsInput").val());

    if (tips < 0) {
        tips = 0;
    }
    
    $.post(`https://${GetParentResourceName()}/getResult`, JSON.stringify({
        type: "pay",
        tips: tips
    }));

    closeUI();
}

// SELLER + CUSTOMER
function updateElementSumPrice() {
    $("#footerSumPrice").html("$" + calculateSumPrice());
}

function calculateSumPrice() {
    let sumPrie = 0;

    $(".itemElement").each(function(i){
        if (!$("#itemElem-" + i).hasClass("itemDisable")) {
            let tempPrice = $("#itemPrice-" + i).html();
            let tempQuantity = $("#itemQuantity-" + i).val();
            if (!tempQuantity || tempQuantity == "") tempQuantity = $("#itemQuantity-" + i).html();
            
            sumPrie += parseInt(tempPrice.substring(1, tempPrice.length)) * parseInt(tempQuantity);
        }
    });

    return sumPrie;
}

// BOSS
function openBoss(shopData, itemData, possibleItemData, bossBankMoney) {
    bossPossibleItemData = possibleItemData;
    
    setShopData(shopData);
    
    initBoss(itemData, bossBankMoney);
}

function initBoss(itemData, bossBankMoney) {
    $("#mainCardItemsHeadlines").html(templateBossItemHeadLines);
    
    for (let i = 0; i < itemData.length; i++) {
        let item = itemData[i];

        let temp = templateBossItemElem;
        temp = temp.replace("%itemName%", item.label);
        temp = temp.replace("%itemDBName%", item.name);
        temp = temp.replace("%itemImg%", "img/items/" + item.name + ".png");
        temp = temp.replace(/%itemIndex%/g, i);
        temp = temp.replace("%itemPrice%", item.price);
        temp = temp.replace("%itemPercent%", item.percent);
        
        $("#mainCardItemsContainer").append(temp);
    }
    
    let temp = templateBossItemFooter;
    temp = temp.replace("%bossBankMoney%", numberWithCommas(bossBankMoney))
    $("#mainCardFooter").html(temp);
}

function bossEmptyAddItem() {
    let itemLength = $(".itemElement").length;

    let temp = templateBossItemElem;
    temp = temp.replace("%itemName%", "None");
    temp = temp.replace("%itemDBName%", "none");
    temp = temp.replace("%itemImg%", "img/itemNone.png");
    temp = temp.replace(/%itemIndex%/g, itemLength);
    temp = temp.replace("%itemPrice%", 100);
    temp = temp.replace("%itemPercent%", 10);
    
    $("#mainCardItemsContainer").append(temp);

    initDraggable();
    
    $('#mainCardItemsContainer').scrollTop($('#mainCardItemsContainer').height());
}

function bossRemoveItem(itemIndex) {
    $("#itemElem-" + itemIndex).remove();
}

function bossItemNameInput(itemIndex) {
    $(".itemElement").each(function(i) {
        let itemId = parseInt($(this).attr('id').replace("itemElem-", ""));

        if (itemId != itemIndex) {
            $("#itemSearch-" + itemId).html("");
            $("#itemSearch-" + itemId).hide(100);
        }
    });

    $("#itemSearch-" + itemIndex).html("");

    let inputString = $("#itemNameInput-" + itemIndex).val();
    inputString = inputString.toLowerCase();
    
    for (i = 0; i < bossPossibleItemData.length; i++) {
        let possibleItem = bossPossibleItemData[i];

        if (possibleItem.label.toLowerCase().includes(inputString) || possibleItem.name.toLowerCase().includes(inputString) || inputString == "none") {
            let tempString = templateBossItemElemSearch;
            tempString = tempString.replace(/%itemIndex%/g, itemIndex);
            tempString = tempString.replace(/%possibleItemIndex%/g, i);
            tempString = tempString.replace("%itemImg%", "img/items/" + possibleItem.name + ".png");
            tempString = tempString.replace("%itemName%", possibleItem.label);

            $("#itemSearch-" + itemIndex).css('top', ($("#itemElem-" + itemIndex).outerHeight() - 10) + "px");
           
            $("#itemSearch-" + itemIndex).append(tempString);
        }
    }

    $("#itemSearch-" + itemIndex).show(100);

    $('img').on("error", function() {
        $(this).unbind("error").attr('src', 'img/itemNone.png');
    });
}

function choosePossibleItem(itemIndex, possibleItemIndex) {
    $("#itemLogoImg-" + itemIndex).attr("src", "img/items/" + bossPossibleItemData[possibleItemIndex].name + ".png");
    $("#itemNameInput-" + itemIndex).val(bossPossibleItemData[possibleItemIndex].label);
    $("#itemNameInput-" + itemIndex).attr("data-itemName", bossPossibleItemData[possibleItemIndex].name);

    bossItemNameInputClose(itemIndex);
}

function bossItemNameInputClose(itemIndex) {
    $("#itemSearch-" + itemIndex).hide();
}

function bossInputPercent(itemIndex) {
    let inputVal = parseInt($("#itemPercentInput-" + itemIndex).val());
    
    if (isNaN(inputVal)) inputVal = 0;
    
    if (inputVal < 0) {
        inputVal = 0;
    }

    if (inputVal > 100) {
        inputVal = 100;
    }

    $("#itemPercentInput-" + itemIndex).val(inputVal);
}

function save() {    
    let itemsData = [];
    let itemsDataComfirm = [];
    $(".itemElement").each(function(i) {
        let itemId = parseInt($(this).attr('id').replace("itemElem-", ""));

        let name = $("#itemNameInput-" + itemId).attr("data-itemName");
        let price = parseInt($("#itemPrinceInput-" + itemId).val());
        let percent = parseInt($("#itemPercentInput-" + itemId).val());
        
        if (itemsDataComfirm[name] == 1) return;
        itemsDataComfirm[name] = 0;

        if (name == "") return;
        if (isNaN(price) || !Number.isInteger(price) || price <= 0) return;
        if (isNaN(percent) || !Number.isInteger(percent) || percent < 0 || percent > 100) return; 
        
        itemsData.push({name: name, price: price, percent: percent});
        itemsDataComfirm[name] = 1;
    });

    $.post(`https://${GetParentResourceName()}/getResult`, JSON.stringify({
        type: "save",
        itemsData: itemsData
    }));

    closeUI();
}

function withdraw() {
    $.post(`https://${GetParentResourceName()}/getResult`, JSON.stringify({
        type: "withdraw"
    }));

    closeUI();
}

//
function cancel() {
    $.post(`https://${GetParentResourceName()}/getResult`, JSON.stringify({
        type: "cancel"
    }));

    closeUI();
}

function cancelChoosePlayer() {
    if ($('#playerChooser').length > 0) {
        $('#playerChooser').each(function(index) {
            $(this).remove();
        });
    }
}

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
