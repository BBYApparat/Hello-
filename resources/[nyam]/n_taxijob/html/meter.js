let meterStarted = false;

const updateMeter = (meterData) => {
    $("#total-price").html("$ " + meterData.currentFare.toFixed(2));
    $("#total-distance").html(
        (meterData.distanceTraveled).toFixed(2) + " mi"
    );
    if (meterData.npc == true) {
        updateTimer(meterData.countdownTime);
    }
};

const resetMeter = () => {
    $("#total-price").html("$ 0.00");
    $("#total-distance").html("0.00 mi");
    $(".meter-timer").html("<p>00:00:00</p>");
};

const toggleMeter = (enabled) => {
    if (enabled) {
        $(".meter-status").html("<p>Started</p>");
        $(".meter-status").css({
            color: "rgb(51, 160, 37)"
        });
        $(".meter-timer").html("<p>00:00:00</p>");
        $(".meter-timer").css({
            color: "rgb(255,255,255)"
        });
    } else {
        $(".meter-status").html("<p>Stopped</p>");
        $(".meter-timer").html("<p>00:00:00</p>");
        $(".meter-status").css({
            color: "rgb(231, 30, 37)"
        });
    }
};

const updateTimer = (timer) => {
    let minutes = Math.floor(timer / 60);
    let seconds = timer % 60;

    seconds = seconds < 10 ? '0' + seconds : seconds;
    if (minutes <= 1) {
        $(".meter-timer").css({
            color: "rgb(231, 30, 37)"
        });
    } else {
        $(".meter-timer").css({
            color: "rgb(255,255,255)"
        });
    }
    $(".meter-timer").html(`<p>00:${minutes + ":" + seconds}</p>`);
}

const meterToggle = () => {
    if (!meterStarted) {
        $.post(
            "https://n_taxijob/enableMeter",
            JSON.stringify({
                enabled: true,
            })
        );
        toggleMeter(true);
        meterStarted = true;
    } else {
        $.post(
            "https://n_taxijob/enableMeter",
            JSON.stringify({
                enabled: false,
            })
        );
        toggleMeter(false);
        meterStarted = false;
    }
};

const openMeter = (meterData) => {
    $(".container").fadeIn(150);
    $("#total-price-per-100m").html("$ " + meterData.defaultPrice.toFixed(2));
};

const closeMeter = () => {
    $(".container").fadeOut(150);
};

$(document).ready(function() {
    $(".container").hide();
    window.addEventListener("message", (event) => {
        const eventData = event.data;
        switch (eventData.action) {
            case "openMeter":
                if (eventData.toggle) {
                    openMeter(eventData.meterData);
                } else {
                    closeMeter();
                }
                break;
            case "toggleMeter":
                meterToggle();
                break;
            case "updateMeter":
                updateMeter(eventData.meterData);
                break;
            case "resetMeter":
                resetMeter();
                break;
            default:
                break;
        }
    });
});