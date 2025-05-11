// CATALOGUE
let templateCatalogueItemHeadLines = `
    <div>Items</div>
    <div></div>
    <div>Price</div>
`;

let templateCatalogueItemElem = `
    <div class="itemElement">
        <div class="itemLogo">
            <div class="itemLogoImg"><img src="%itemImg%"></div>
            <div class="itemLogoText">%itemName%</div>
        </div>

        <div></div>

        <div class="itemCustomerPrice">$%itemPrice%</div>
    </div>
`;

// SELLER
let templateSellerItemHeadLines = `
    <div>Items</div>
    <div>Quantity</div>
    <div>Price</div>
`;

let templateSellerItemElem = `
    <div class="itemElement %itemDisable%" id="itemElem-%itemIndex%">
        <div class="itemLogo">
            <div class="itemLogoImg"><img src="%itemImg%"></div>
            <div class="itemLogoText" data-itemName="%itemDBName%">%itemName%</div>
        </div>

        <div class="itemSellerQuantity">
            %itemAmountChooser%
        </div>

        <div class="itemSellerPrice" id="itemPrice-%itemIndex%">$%itemPrice%</div>
    </div>
`;

let templateSellerItemAmountChooser = `
    <div class="itemSellerQButton itemSellerQButtonL"><div onclick="buttonQuantity(%itemIndex%, %itemMaxQuantity%, -1)"><i class="fas fa-minus"></i></div></div>
    <div><input type="number" min="0" max="%itemMaxQuantity%" step="1" value="0" id="itemQuantity-%itemIndex%" onkeyup="buttonQuantity(%itemIndex%, %itemMaxQuantity%)"></div>
    <div class="itemSellerQButton itemSellerQButtonR"><div onclick="buttonQuantity(%itemIndex%, %itemMaxQuantity%, 1)"><i class="fas fa-plus"></i></div></div>
`;

let templateSellerItemFooter = `
    <div class="footerActions">
        <div class="actionButton" onclick="choosePlayerToBill()">
            <div>Bill</div>
        </div>

        <div></div>
    </div>
    
    <div></div>
    
    <div class="footerSumPrice" id="footerSumPrice">$0</div>
`;

let templateChoosePlayer = `
    <div class="choosePlayer" id="playerChooser">
        <div class="mainCardCloseButton" onclick="cancelChoosePlayer()"><i class="fas fa-times"></i></div>
        %playersImgs%
    </div>
`;

let templateChoosePlayerImg = `
    <div><img src="%playerHeadshotImgSrc%" onclick="bill(%playerId%)"></div>
`;

// CUSTOMER
let templateCustomerItemHeadLines = `
    <div>Items</div>
    <div>Quantity</div>
    <div>Price</div>
`;

let templateCustomerItemElem = `
    <div class="itemElement">
        <div class="itemLogo">
            <div class="itemLogoImg"><img src="%itemImg%"></div>
            <div class="itemLogoText">%itemName%</div>
        </div>

        <div class="itemCustomerQuantity" id="itemQuantity-%itemIndex%">%itemQuantity%</div>

        <div class="itemCustomerPrice" id="itemPrice-%itemIndex%">$%itemPrice%</div>
    </div>
`;

let templateCustomerItemFooter = `
    <div class="footerActions">
        <div class="actionButton" onclick="pay()">
            <div>Pay</div>
        </div>
        <div></div>
    </div>
    
    <div class="footerTips">
        <div>Tips: <span style="color:green; font-weight:bold;">$</span><input type="number" min="0" step="1" value="0" id="tipsInput" onkeyup="tipsInput()" onfocus="tipsInput()"></div>
    </div>

    <div class="footerSumPrice" id="footerSumPrice">$0</div>
`;

// BOSS
let templateBossItemHeadLines = `
    <div>Items</div>
    <div>Price</div>
    <div>Boss Percent</div>
    <div>Actions</div>
`;

let templateBossItemElem = `
    <div class="itemElement" id="itemElem-%itemIndex%">
        <div class="itemLogo">
            <div class="itemLogoImg"><img src="%itemImg%" id="itemLogoImg-%itemIndex%"></div>
            <div class="itemLogoText"><input type="text" value="%itemName%" id="itemNameInput-%itemIndex%" onkeyup="bossItemNameInput(%itemIndex%)" onfocus="bossItemNameInput(%itemIndex%)" data-itemName="%itemDBName%"></div>
            
            <div class="itemSearch" id="itemSearch-%itemIndex%">
            </div>
        </div>

        <div class="itemBossPrice" style="color: green;">
            <div style="text-align: right;">$</div>
            <div><input type="number" min="0" step="1" value="%itemPrice%" id="itemPrinceInput-%itemIndex%"></div>
        </div>

        <div class="itemBossPersent">
            <div><input type="number" min="0" max="100" step="1" value="%itemPercent%" id="itemPercentInput-%itemIndex%" onkeyup="bossInputPercent(%itemIndex%)"></div>
            <div style="text-align: left;">%</div>
        </div>

        <div class="itemBossActions">
            <div class="itemBossActionDrag"><i class="fas fa-bars"></i></div>
            <div style="color: rgb(200, 0, 0);"><i class="fas fa-trash" onclick="bossRemoveItem(%itemIndex%)"></i></div>
        </div>
    </div>
`;

let templateBossItemElemSearch = `
    <div class="itemSearchElem" id="itemSearchElem-%itemIndex%-%possibleItemIndex%" onclick="choosePossibleItem(%itemIndex%,%possibleItemIndex%)">
        <div class="itemLogoImg"><img src="%itemImg%"></div>
        <div class="itemLogoText">%itemName%</div>
    </div>
`;

let templateBossItemFooter = `
    <div class="footerActions">
        <div class="actionButton" onclick="save()">
            <div>Save</div>
        </div>
        <div class="actionButton" onclick="bossEmptyAddItem()">
            <div>Add Item</div>
        </div>
    </div>
    
    <div></div>

    <div class="footerActions">
        <div class="footerSumPrice">$%bossBankMoney%</div>
        <div class="actionButton" onclick="withdraw()">
            <div>Withdraw</div>
        </div>
    </div>
`;
