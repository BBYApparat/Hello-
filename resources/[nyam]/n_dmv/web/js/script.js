const app = new Vue({
    el: '#app',
    resourceName : GetParentResourceName(),
    screen : 'license',
    data: {
        resourceName : GetParentResourceName(),
        selectedLanguage: "en",
        schermata : 'license',
        group : [],
        license : [],
        userLicenses : [],
        currentQuestions : false,
        currentQuestion : {},
        selectedIndex : false,
        licenseSelected : false,
        correctAnswers : 0,
        dmvTitle : "",
        descriptionTitle : "",
        pointsMinimum : 1,
        doingTheory : false,
        doingPractice : false,
        config: [],
        cash : 0,
        bank : 0,
        showNotification: false,
        isFlagDisabled: false
    },

    methods: {
        postMessage(type, data) {
            $.post(`https://${this.resourceName}/${type}`, JSON.stringify(data));
        },
        
        setLanguage(lang) {
            this.selectedLanguage = lang;
            
            var randomNumber = Math.floor(Math.random() * this.config.Questions[lang].length);
            app.group = this.config.Questions[lang][randomNumber]

            if (lang === "gr") {
                this.notify("Language changed to Greek");
              } else {
                this.notify("Language changed to English");
              }
        },
        notify(message) {
            this.notificationMessage = message;
            this.showNotification = true;
            // Hide notification after 3 seconds
            setTimeout(() => {
                this.showNotification = false;
            }, 3000);
        },
        checkLicense(license) {
            for(const[k,v] of Object.entries(this.userLicenses)) {
                if(v.id == license) {
                    if(v.theory && !v.practice) {
                        let priceCost = 0;
                        this.config.License.forEach(_license => {
                            if (_license.id == license) {
                                priceCost = _license.pricing.practice;
                                return true;
                            }
                        });
                        this.config.Lang.start_theory_extra = ` ${priceCost}$`;
                        return "practice"
                    } else if(v.theory && v.practice) {
                        return "none"
                    } else {
                        let priceCost = 0;
                        this.config.License.forEach(_license => {
                            if (_license.id == license) {
                                priceCost = _license.pricing.theory;
                                return true;
                            }
                        });
                        this.config.Lang.start_theory_extra = ` ${priceCost}$`;
                        return "theory"
                    }
                }
            }
            return false;
        },
        getNotAttr() {
            var cosi = []
            for(const[k,v] of Object.entries(this.currentQuestions)) {
                if(!v.attr) {
                    cosi.push(k)
                }
            }
            return cosi
        },

        updateQuestion(disableupdate, controllocheck) {
            $("input[type='radio']").prop('checked', false);
            if(!disableupdate) {
                if(this.selectedIndex != false) {
                    if(this.currentQuestion.options[this.selectedIndex].correct) {
                        this.correctAnswers = this.correctAnswers + 1;
                    }
                }
            }

            if(this.getNotAttr().length == 0) {
                this.currentQuestion = false
                this.updateSchermata('risultato')
                this.selectedIndex = false
                if(this.correctAnswers >= this.pointsMinimum) {
                    this.postMessage('theoryOk', {
                        license : this.licenseSelected
                    })
                    this.licenseSelected = false
                    this.descriptionTitle = this.config.Lang.theory_success
                    this.dmvTitle = "THEORY SUCCEED";
                } else {
                    this.descriptionTitle = this.config.Lang.theory_error
                    this.dmvTitle = "THEORY FAILED";
                }
                for(const[k,v] of Object.entries(this.currentQuestions)) {
                    v.attr = false
                }
                return
            }
            var randomNumber = Math.floor(Math.random() * this.group.length);
            for(const[k,v] of Object.entries(this.currentQuestions)) {
                if(k == randomNumber && v.attr) {
                    this.updateQuestion(true)
                    return
                }
            }
            for(const[k,v] of Object.entries(this.currentQuestions)) {
                if(k == randomNumber) {
                    v.attr = true
                    this.currentQuestion = this.group[randomNumber]
                    this.descriptionTitle = this.currentQuestion.label
                }
            }
            this.updateSelectedQuestion(false)
        },  

        updateSelectedQuestion(index) {
            this.selectedIndex = index
        },

        startTheory(id, question) {
            this.isFlagDisabled = true;
            this.dmvTitle = "THEORY TEST";
            for(const[k,v] of Object.entries(this.license)) {
                if(v.id == id) {
                    if(this.cash >= v.pricing.theory) {
                        this.postMessage('removeMoney', {
                            account : "money",
                            amount : v.pricing.theory
                        })
                    } else if(this.bank >= v.pricing.theory) {
                        this.postMessage('removeMoney', {
                            account : "bank",
                            amount : v.pricing.theory
                        })
                    } else {
                        var missingMoney = (v.pricing.theory - this.cash)
                        this.descriptionTitle = this.config.Lang.money_error.replace("%s", missingMoney)
                        setTimeout(() => {
                            this.descriptionTitle  = ""
                        }, 5000);
                        return
                    }
                }
            }
            this.doingTheory = true
            this.doingPractice = false
            this.licenseSelected = id+"dmv"
            this.correctAnswers = 0
            this.updateSchermata('theory')
            for(const[k,v] of Object.entries(question)) {
                v.attr = false
            }
            this.currentQuestions = question
            this.correctAnswers = 0
            this.updateQuestion()
        },

        startPractice(id) {
            for(const[k,v] of Object.entries(this.license)) {
                if(v.id == id) {
                    if(this.cash >= v.pricing.practice) {
                        this.postMessage('removeMoney', {
                            account : "money",
                            amount : v.pricing.theory
                        })
                    } else if(this.bank >= v.pricing.practice) {
                        this.postMessage('removeMoney', {
                            account : "bank",
                            amount : v.pricing.theory
                        })
                    } else {
                        var missingMoney = v.pricing.practice - this.cash
                        this.descriptionTitle = this.config.Lang.money_error.replace("%s", missingMoney)
                        setTimeout(() => {
                            this.descriptionTitle  = ""
                        }, 5000);
                        return
                    }
                }
            }
            this.licenseSelected = id
            this.doingTheory = false 
            this.doingPractice = true
            $("#app").fadeOut(800)
            this.postMessage("close")
            this.postMessage('startPractice', {
                license : id
            })   
        },

        updateDescription(msg) {
            this.descriptionTitle = msg
        },

        close() {
            this.doingPractice = false
            this.doingTheory = false
            this.isFlagDisabled = false;
            $("#app").fadeOut(800)
            this.postMessage("close");
        },

        updateSchermata(sch) {
            this.schermata = sch
            if(sch == "license") {
                this.updateDescription("")
                this.doingTheory = false
                this.doingPractice = false
                this.isFlagDisabled = false;
            }
        }
    }

});

window.addEventListener('message', function(event) {
    var data = event.data;
    if (data.type === "OPEN") {
        $("#app").fadeIn(500)
        app.userLicenses = data.licenses
        app.license = data.license
        app.updateSchermata('license')
        app.isFlagDisabled = false
        app.dmvTitle = app.config.Lang.dmv
    } else if(data.type === "UPDATE_LICENSE") {
        app.userLicenses = data.licenses
        app.isFlagDisabled = false
    } else if(data.type === "DISPLAY_RESULTS_AFTER_DRIVE") {
        $("#app").fadeIn(800)
        app.correctAnswers = data.speedLimitReached
        app.updateSchermata('risultato')
        app.doingPractice = true
        app.doingTheory = false
        if(data.speedLimitReached >= app.config.MaxErrors) {
            app.descriptionTitle = app.config.Lang["practice_error"]
        } else {
            app.descriptionTitle = app.config.Lang["practice_success"]
            app.postMessage('practiceOk', {
                license : app.licenseSelected
            })
        }
    } else if(data.type === "SET_CONFIG") {
        app.config = data.config
        app.dmvTitle = app.config.Lang.dmv
        var randomNumber = Math.floor(Math.random() * data.config.Questions[app.selectedLanguage].length);
        app.group = data.config.Questions[app.selectedLanguage][randomNumber]
        app.config.Lang = app.config.Lang[app.config.Language]
        app.pointsMinimum = data.config.MaxErrors
        app.isFlagDisabled = false
    } else if(data.type === "SET_MONEY") {
        app.cash = data.cash,
        app.bank = data.bank
    }
})

document.onkeyup = function (data) {
    if (data.key == 'Escape' && app.schermata == 'license') {
        $("#app").fadeOut(800)
        app.postMessage("close")
    }
};
