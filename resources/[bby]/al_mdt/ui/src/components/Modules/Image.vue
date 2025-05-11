<template>
    <div class="container-fluid">
        <ViewImage
            :parentElId="parentEl"
            :show="modalData.ViewImage.show"
            :img="img"
            :id="`${id}_view_image`"
        />

        <div class="fade" :id="`${id}_img_container`" :style="{ 'display': loading ? 'none' : 'block' }">
            <img :src="img" class="img-fluid" :style="{ 'max-height': options.maxImgHeight,  'border': border ? '5px solid #1d1f25' : false,  'border-radius': border ? '5px' : false }" @load="hasImageLoaded = true" @click="ExpandImage()" />
        </div>

        <template v-if="loading">
            <div :id="`${id}_img_load`" class="container-fluid fade show">
                <div class="row d-flex align-items-center justify-content-md-center" :style="{ 'height': options.maxImgHeight }">
                    <div class="col-3 text-center">
                        <span v-if="loading">
                            <div class="spinner-border ms-1" style="width: 1rem; height: 1rem" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </span>
                    </div>
                </div>
            </div>
        </template>
    </div>
</template>

<script>
import ViewImage from "../Modals/Images/ViewImage";

export default {
    name: "Image",
    components: {
        ViewImage,
    },
    data() {
        return {
            loading: false,
            hasImageLoaded: false,
            cancelLoading: false,
            canStopLoading: true,

            modalData: {
                ViewImage: {
                    show: false,
                },
            }
        };
    },
    props: [
        "parentEl",
        "img",
        "id",
        "border",
        "options",
        /*
            Options:
            maxImgHeight: string
            canExpand: bool
        */
    ],
    mounted() {
        this.ShowImage()
    },
    methods: {
        ShowImage() {
            this.hasImageLoaded = false;
            this.loading = true;
            this.canStopLoading = false;

            setTimeout(() => {
                this.canStopLoading = true;
            }, 1000);

            setTimeout(() => {
                if (!this.hasImageLoaded) {
                    this.cancelLoading = true;
                }
            }, 5000);

            setTimeout(() => {
                var tabEl = document.getElementById(`${this.id}_img_container`);

                const waitInterval = setInterval(() => {
                    if (this.canStopLoading && this.loading && this.hasImageLoaded) {
                        document.getElementById(`${this.id}_img_load`).classList.remove('show')

                        setTimeout(() => {
                            this.loading = false;
                            this.canStopLoading = true;

                            setTimeout(() => {
                                tabEl.classList.add("show");
                            }, 100);

                            clearInterval(waitInterval);
                        }, 500)
                    } else if (this.cancelLoading) {
                        this.loading = false;
                        this.canStopLoading = true;
                        this.cancelLoading = false;

                        clearInterval(waitInterval);
                    }
                }, 500);
            }, 500);
        },
        ExpandImage() {
            if (!this.modalData.ViewImage.show && this.options.canExpand) {
                this.modalData.ViewImage.show = true;

                setTimeout(() => {
                    this.modalData.ViewImage.show = false;
                }, 200);
            }
        }
    },
};
</script>
