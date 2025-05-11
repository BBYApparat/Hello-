currentIndex = 0
datica = null
vozila = null
const resourceName = 'ts-vehicleshop'
let currentClass = "SVE";
let currentCategory = null;

window.addEventListener('message', function(event) {
  let data = event.data
  datica = data
  if(data.action == "otvoriSalon") {
    $(".autosalon").show()
    $("body").css("display","flex") 
    ucitaj_kategorije()
    $("#K_ALL").click()
  } else if (data.action == "sendVozila") {
        ubaci_auta(datica.kars,datica.kategorija, datica.type)
  }
});

function ucitaj_kategorije(){
    $("#kategorije").html("");
    for (let i = 0; i < carCategoryes.length; i++) {
        $("#kategorije").append(`
        <div class="item" id="K_${carCategoryes[i].name}" onclick="izaberi_kategoriju('${carCategoryes[i].name}',this)">
            <p>${carCategoryes[i].name} </p>
        </div>
        `)
    }

    $("#kategorije").append(`
        <div class="item search-input-container">
            <input type="text" id="searchInput" placeholder="Search by label..." onkeyup="searchVehicles()">
        </div>
    `);
}

function kupi_auto(photo, price, modelVozila, label, stanje, tip){
    if (stanje < 1) {return}
    console.log(modelVozila)
    $.post(`https://${GetParentResourceName()}/kupiVozilo323232`, JSON.stringify({
        photo : photo, price : price, model : modelVozila, label : label, tip : tip
    }));
    zatvori()
}

function provozaj_auto(model, stanje){
    if (stanje < 1) {return}
    $.post(`https://${GetParentResourceName()}/testvehicle`, JSON.stringify({
        model : model
    }));
    zatvori()
}

function izaberi_kategoriju(kategorija,self){
    $("#lista_auta").html("")
    try{
        $(".aktivan").removeClass("aktivan")
    }
    catch{}
    self.classList += " aktivan"
    try{
        $(".aktivan_sort").removeClass("aktivan_sort")
    }
    catch{}
    ubaci_auta(kategorija)
}

function uzmi_test_bazu(kategorija) {
    fetch(`https://${GetParentResourceName()}/getVozila`, {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json; charset=UTF-8',
    },
    body: JSON.stringify({
    })
    }).then(resp => resp.json()).then(function(resp){
        return resp
    })
}

function ubaci_auta(kategorija, type, self){
    currentClass = kategorija;
    currentCategory = null;

    fetch(`https://${GetParentResourceName()}/getVozila`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(function(resp){
        if (type == "poredajMin") {
            resp.sort(function (x, y) {
                return parseFloat(x.price) - parseFloat(y.price);
            });
            $("#lista_auta").html("")
            try{
                $(".aktivan_sort").removeClass("aktivan_sort")
            }
            catch{}
        } else if (type == "poredajMax") {
            resp.sort(function(x, y) {
                return parseFloat(y.price) - parseFloat(x.price);
            });
            $("#lista_auta").html("")
            try{
                $(".aktivan_sort").removeClass("aktivan_sort")
            }
            catch{}
        }
        else if (type == "poredajGepek") {
            resp.sort(function(x, y) {
                return parseFloat(y.trunk) - parseFloat(x.trunk);
            });
            $("#lista_auta").html("")
            try{
                $(".aktivan_sort").removeClass("aktivan_sort")
            }
            catch{}
        }
        else if (type == "poredajGepek") {
            resp.sort(function(x, y) {
                return parseFloat(y.trunk) - parseFloat(x.trunk);
            });
            $("#lista_auta").html("")
            try{
                $(".aktivan_sort").removeClass("aktivan_sort")
            }
            catch{}
        }

        resp.forEach(function(item){
            let shouldDisplay = kategorija === "ALL" || item.type === kategorija;
            if (shouldDisplay) {
                appendVehicleToList(item);
            }
        })
    })
}

function filter_category(category, self) {
    currentCategory = category;
    $(".aktivan_sort").removeClass("aktivan_sort");
    $(self).addClass("aktivan_sort");

    $("#lista_auta").html("");

    fetch(`https://${GetParentResourceName()}/getVozila`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({})
    }).then(resp => resp.json()).then(function(resp) {
        resp.forEach(function(item) {
            let shouldDisplay = (currentClass === "ALL" || item.type === currentClass) && item.vehicleType === category;
            
            if (shouldDisplay) {
                appendVehicleToList(item);
            }
        });
    });
}

function NoImage(model) {
    console.log(model);
}

function appendVehicleToList(item) {
    let btn_lock = item.stanje > 0 ? "" : "lock";
    let id = item.stanje > 0 ? item.id : -1;
    
    // <img src="images/${item.model}.jpg" onerror="this.src='${item.photo}'">
    // <img src="images/${item.model}.jpg" onerror="NoImage('${item.model}')">
    $("#lista_auta").append(`
        <div class="item ${btn_lock}">
            <div class="naslov"><h1>${item.brand} - ${item.label.toUpperCase()}</h1></div>
            <div class="slika">
                <img src="images/${item.model}.jpg" onerror="this.src='${item.photo}'">
            </div>
            <div class="informacije">
                <div class="box">
                    <label>
                        <p class="naslov">Price:</p>
                        <p><span>$</span>${item.price}</p>
                    </label>
                    <label>
                        <p class="naslov">Speed:</p>
                        <p>${item.speed} KM/H</p>
                    </label>
                </div>
                <div class="box new">
                    <label>
                        <p class="naslov">Trunk:</p>
                        <p>${item.trunk} S/KG</p>
                    </label>
                    <label>
                        <p class="naslov">Stock:</p>
                        <p>${item.stanje}</p>
                    </label>
                </div> 
                <div class="btn">
                    <button class='${btn_lock}' onclick="kupi_auto('${item.photo}','${item.price}','${item.model}','${item.label}','${item.stanje}', '${item.type}')"><i class="fa fa-shopping-cart"></i> Buy</button>
                    <button class='${btn_lock}' onclick="provozaj_auto('${item.model}','${item.stanje}')"><i class="fa fa-car"></i> Test Drive</button>
                </div>
            </div>
        </div>`);
}

document.onkeyup = function (data) {
    if (data.which == 27) {
        zatvori()
    }
};

function zatvori() {
    $(".autosalon").hide("")
    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
}

function poredaj_min(kategorija,self){
    ubaci_auta(kategorija, "poredajMin", self)
}

function poredaj_max(kategorija,self){
    ubaci_auta(kategorija, "poredajMax", self)
}

function poredaj_gepek(kategorija,self){
    ubaci_auta(kategorija, "poredajGepek", self)
}

function searchVehicles() {
    let input = document.getElementById('searchInput').value.toLowerCase();
    let vehicleItems = document.querySelectorAll('#lista_auta .item');

    vehicleItems.forEach(function(item) {
        let label = item.querySelector('.naslov h1').textContent.toLowerCase();
        if (label.includes(input)) {
            item.style.display = ""; // Show the vehicle if it matches the search query
        } else {
            item.style.display = "none"; // Hide the vehicle if it doesn't match
        }
    });
}