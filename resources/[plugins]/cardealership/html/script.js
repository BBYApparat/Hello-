let vehicles = [];
let categories = {};
let currentPage = 1;
let vehiclesPerPage = 8;
let currentCategory = null;

window.addEventListener('message', function (event) {
    let data = event.data;
    if (data.show === true) {
        vehicles = data.vehicles;
        categories = data.categories;
        $("body").css("display", "block");
        $("#carshop").show();
        loadCategories();
        loadVehicles();
    } else if (data.show === false) {
        $("body").css("display", "none");
        $("#carshop").hide();
    } else if (data.update === true) {
        vehicles = data.vehicles;
        loadVehicles(currentCategory);
    }
});

function CloseShop() {
    $.post(`https://${GetParentResourceName()}/closeCarDealer`, JSON.stringify({}), function(data) {
        if (data) {
            $("body").css("display", "none");
            $("#carshop").hide();
        }
    });
}

$(document).keyup(function (e) {
    if (e.key === "Escape") {
        CloseShop();
    }
});

function showPage(pageNumber) {
    currentPage = pageNumber;
    loadVehicles(currentCategory);
}

function buyVehicle(vehicleId) {
    $.post(`https://${GetParentResourceName()}/BuyVehicle`, JSON.stringify({model: vehicleId}), function(response) {
        if (response === false) {
            // Handle purchase failure (e.g., show error message)
        } else {
            CloseShop();
        }
    });
}

function loadCategories() {
    const sidebar = $('#sidebar');
    sidebar.empty();
    
    const uniqueCategories = [...new Set(vehicles.map(v => v.category))];
    uniqueCategories.forEach(categoryName => {
        const button = $('<button>')
            .addClass('class-button')
            .text(categoryName)
            .click(() => {
                console.log("Category selected:", categoryName);
                loadVehicles(categoryName);
            });
        sidebar.append(button);
    });
}

function loadVehicles(category = null) {
    console.log("Loading vehicles for category:", category);
    console.log("All vehicles:", vehicles);

    currentCategory = category;
    let filteredVehicles = vehicles;
    if (category) {
        filteredVehicles = vehicles.filter(v => v.category.toLowerCase() === category.toLowerCase());
    }

    console.log("Filtered vehicles:", filteredVehicles);

    const startIndex = (currentPage - 1) * vehiclesPerPage;
    const endIndex = startIndex + vehiclesPerPage;
    const pageVehicles = filteredVehicles.slice(startIndex, endIndex);

    console.log("Page vehicles:", pageVehicles);

    const pagesContainer = $('#pages');
    pagesContainer.empty();

    const page = $('<div>').addClass('page active');
    const leftColumn = $('<div>').addClass('column left-column');
    const rightColumn = $('<div>').addClass('column right-column');

    if (pageVehicles.length === 0) {
        page.append('<p>No vehicles found in this category.</p>');
    } else {
        pageVehicles.forEach((vehicle, index) => {
            const vehicleElement = createVehicleElement(vehicle);
            if (index % 2 === 0) {
                leftColumn.append(vehicleElement);
            } else {
                rightColumn.append(vehicleElement);
            }
        });
    }

    page.append(leftColumn, rightColumn);
    pagesContainer.append(page);

    updateNavigationButtons(filteredVehicles.length);

    // Make sure the container is visible
    $("#carshop").show();
    $(".vehicle-main-content").show();

    console.log("Final pages container HTML:", pagesContainer.html());
}

function createVehicleElement(vehicle) {
    console.log("Creating vehicle element for:", vehicle);
    const vehicleElement = $('<div>').addClass('vehicle');
    const html = `
        <img src="${vehicle.image}" alt="${vehicle.label}">
        <p class="label">${vehicle.label}</p>
        <p class="price">Price: $${vehicle.price.toLocaleString()}</p>
        <p class="stock">Stock: ${vehicle.stock}</p>
        ${vehicle.stock > 0 ? `
            <div class="button-container">
                <button class="test-drive" onclick="testDriveVehicle('${vehicle.model}')">Test Drive</button>
                <button class="buy" onclick="buyVehicle('${vehicle.model}')">Buy</button>
            </div>
        ` : '<p class="out-of-stock">Out of Stock</p>'}
    `;
    vehicleElement.html(html);
    console.log("Created vehicle element:", vehicleElement[0].outerHTML);
    return vehicleElement;
}

function updateNavigationButtons(totalVehicles) {
    const totalPages = Math.ceil(totalVehicles / vehiclesPerPage);
    const navButtons = $('#navigationButtons');
    navButtons.show();
    
    const prevButton = $('#prevButton');
    const nextButton = $('#nextButton');
    
    prevButton.prop('disabled', currentPage === 1);
    nextButton.prop('disabled', currentPage === totalPages);
}

function previousPage() {
    if (currentPage > 1) {
        showPage(currentPage - 1);
    }
}

function nextPage() {
    const totalPages = Math.ceil(vehicles.length / vehiclesPerPage);
    if (currentPage < totalPages) {
        showPage(currentPage + 1);
    }
}

function testDriveVehicle(model) {
    // Implement test drive functionality
    console.log(`Test driving ${model}`);
    // You can add a server callback here if needed
}