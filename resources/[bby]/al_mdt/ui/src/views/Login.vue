<template>
    <div id="login" class="container pt-4 pb-4">
        <div class="row">
            <div class="mb-3 text-center">
                <h3>{{ $store.getters.GetTranslation('login', 'term_login') }}</h3>
            </div>
        </div>

        <div class="row justify-content-center" v-if="$store.state.general.loginUsername.length > 0">
            <div class="col-xxl-7 col-10">
                <div class="mb-3 row">
                    <label class="col-3 col-form-label text-lg-end fw-bold">
                        {{ $store.getters.GetTranslation('login', 'username') }}
                    </label>

                    <div class="col-9">
                        <input class="form-control" :value="$store.state.general.loginUsername" disabled />
                    </div>
                </div>

                <div class="mb-3 row">
                    <label class="col-3 col-form-label text-lg-end fw-bold">
                        {{ $store.getters.GetTranslation('login', 'password') }}
                    </label>
                    <div class="col-9">
                        <input type="password" class="form-control" value="AProtectedPassword" disabled />
                    </div>
                </div>

                <div class="text-center">
                    <button type="button" class="btn green-btn" @click="Login()">
                        {{ $store.getters.GetTranslation('login', 'login') }}
                    </button>
                </div>
            </div>
        </div>

        <div class="row justify-content-center"
            v-if="$store.state.general.registerUser.username.length > 0 && $store.state.general.registerUser.job.length > 0">
            <div class="col-xxl-7 col-10">
                <div class="mb-3 row">
                    <label class="col-3 col-form-label text-lg-end fw-bold">
                        {{ $store.getters.GetTranslation('login', 'username') }}
                    </label>

                    <div class="col-9">
                        <input class="form-control" :value="$store.state.general.registerUser.username" disabled />
                    </div>
                </div>

                <div class="mb-3 row">
                    <label class="col-lg-3 col-form-label text-lg-end fw-bold">
                        {{ $store.getters.GetTranslation('login', 'job') }}
                    </label>

                    <div class="col-9">
                        <input class="form-control"
                            :value="$store.state.general.registerUser.job.charAt(0).toUpperCase() + $store.state.general.registerUser.job.slice(1)"
                            disabled />
                    </div>
                </div>

                <div class="mb-3 row">
                    <label class="col-3 col-form-label text-lg-end fw-bold">
                        {{ $store.getters.GetTranslation('login', 'password') }}
                    </label>
                    <div class="col-9">
                        <input type="password" class="form-control" value="AProtectedPassword" disabled />
                    </div>
                </div>

                <div class="text-center">
                    <button type="button" class="btn green-btn" @click="Login(true)">
                        {{ $store.getters.GetTranslation('login', 'register') }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "Login",
    methods: {
        Login(registerUser) {
            this.ToggleLoadingScreen(true)
            const start = Date.now()

            var interval = setInterval(() => { // Fail attempt if exceeds 5 seconds
                if ( Date.now() - start > 5000 ) {
                    this.ToggleLoadingScreen(false)

                    this.SendNotification(
                        this.$store.getters.GetTranslation('login', 'try_later'),
                        this.$store.getters.GetTranslation('login', 'login_error'),
                        5000,
                        'error',
                        false,
                        true
                    );

                    clearInterval(interval)
                }
            }, 100)

            this.$store.dispatch('Login', registerUser).then((resp) => {
                if ( Date.now() - start <= 5000 && resp !== undefined ) { // Proceed if result came before 5 seconds
                    let timer = 100

                    if ( Date.now() - start <= 2000 ) {
                        timer = 1000
                    }

                    setTimeout(() => {
                        if ( resp ) { // Authorized
                            this.$router.push('/dashboard')

                            setTimeout(() => {
                                this.ToggleLoadingScreen(false)

                                this.SendNotification(
                                    `${this.$store.getters.GetTranslation('login', 'welcome')} ${this.$store.getters.GetSelf().name}!`,
                                    this.$store.getters.GetTranslation('login', 'successful_login'),
                                    4000,
                                    'success',
                                    false,
                                    false
                                );
                            }, 1000);
                        } else { // Unauthorized
                            this.ToggleLoadingScreen(false)

                            this.SendNotification(
                                this.$store.getters.GetTranslation('login', 'error'),
                                this.$store.getters.GetTranslation('login', 'error_msg_1'),
                                7500,
                                'error',
                                false,
                                true
                            );
                        }
                    }, timer)

                    clearInterval(interval)
                }
            }).catch(() => { // If error occurs
                this.ToggleLoadingScreen(false)

                this.SendNotification(
                    this.$store.getters.GetTranslation('login', 'error'),
                    this.$store.getters.GetTranslation('login', 'error_msg_2'),
                    5000,
                    'error',
                    false,
                    true
                );

                if ( Date.now() - start <= 5000 ) {
                    clearInterval(interval)
                }
            });
        }
    },
};
</script>

<style lang="scss" scoped>
$primaryColor: #1d1f25;
$primaryColorLight: #2a2c34;
$primaryColorLightHover: #383a44;
$secondaryColor: #e37926;
$secondaryColorHover: #b46020;
$textColor: #ececec;
$redColor: #9f1600;
$redColorHover: #7e1100;
$greenColor: #007b1d;
$greenColorHover: #006317;

#login {
    position: absolute;
    width: 40vw;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);

    background: $primaryColorLight;
    border-radius: 5px;

    .form-floating {
        color: $primaryColor;
    }
}
</style>
