<template>
    <div id="view-char-profile" class="container-fluid fade">
        <template v-if="!modalData.ViewReport.show">
            <!-- Modals -->
            <AddImage @submit-image="SetPhotoId" :parentElId="'view-char-profile'" :show="modalData.AddImage.show" />

            <Teleport to="body">
                <!-- Delete fine confirmation -->
                <ConfirmationModal :show="modalData.FineConfirmation.show" @cb="ExemptFine"
                    @close="modalData.FineConfirmation.show = false">
                    <template #body>
                        {{ modalData.FineConfirmation.data }}
                    </template>
                </ConfirmationModal>

                <!-- Delete image confirmation -->
                <ConfirmationModal :show="modalData.DelImgConfirmation.show" @cb="DeleteImage"
                    @close="modalData.DelImgConfirmation.show = false">
                    <template #body>
                        {{ modalData.DelImgConfirmation.data }}
                    </template>
                </ConfirmationModal>

                <!-- Add relations -->
                <CustomModal :show="modalData.AddRelation.show">
                    <template #header>
                        {{ $store.getters.GetTranslation('addrelation', 'title') }}
                    </template>

                    <template #body>
                        <div class="row justify-content-md-center mdt-form">
                            <div class="col-7 text-center mb-1">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('addrelation', 'col_name') }}
                                    <span class="mdt_required" title="Required">*</span>
                                </label>

                                <input class="form-control"
                                    :class="{ 'is-invalid': modalData.AddRelation.validationFeedback.length > 0 && modalData.AddRelation.inputFields.name.length <= 0 }"
                                    type="text" :placeholder="$store.getters.GetTranslation('addrelation', 'ph_name')"
                                    v-model="modalData.AddRelation.inputFields.name" required />
                                <div class="invalid-feedback">
                                    {{ modalData.AddRelation.validationFeedback }}
                                </div>
                            </div>
                        </div>

                        <div class="row justify-content-md-center mdt-form">
                            <div class="col-5 text-center">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('addrelation', 'col_relation') }}
                                    <span class="mdt_required" title="Required">*</span>
                                </label>

                                <input class="form-control"
                                    :class="{ 'is-invalid': modalData.AddRelation.validationFeedback.length > 0 && modalData.AddRelation.inputFields.relation.length <= 0, }"
                                    type="text"
                                    :placeholder="$store.getters.GetTranslation('addrelation', 'ph_relation')"
                                    v-model="modalData.AddRelation.inputFields.relation" required />
                                <div class="invalid-feedback">
                                    {{ modalData.AddRelation.validationFeedback }}
                                </div>
                            </div>
                        </div>

                        <div class="mt-4 text-center">
                            <button type="submit" class="btn green-btn"
                                @click="AddRelation(modalData.AddRelation.inputFields.name, modalData.AddRelation.inputFields.relation)">
                                {{ $store.getters.GetTranslation('addrelation', 'add') }}
                            </button>
                        </div>
                    </template>

                    <template #footer>
                        <button type="button" class="btn orange-btn" @click="modalData.AddRelation.show = false">
                            {{ $store.getters.GetTranslation('addrelation', 'close') }}
                        </button>
                    </template>
                </CustomModal>

                <!-- Grant license -->
                <CustomModal :show="modalData.GrantLicense.show">
                    <template #header>
                        {{ $store.getters.GetTranslation('viewcharprofile', 'grant_lic') }}
                    </template>

                    <template #body>
                        <div class="row justify-content-center">
                            <template v-for="(license, index) in $store.state.config.GrantableLicenses"
                                :key="`${index}_grant_license`">
                                <div class="col-4 mb-2">
                                    <span style="display: table; margin: 0 auto">
                                        <button type="button" class="btn btn-sm"
                                            :class="modalData.GrantLicense.selected === license ? 'green-btn' : 'blue-btn'"
                                            :disabled="webCharData.licenses.includes(license)"
                                            @click="modalData.GrantLicense.selected = webCharData.licenses.includes(license) ? '' : license;">
                                            {{ $store.state.config.LicenseLabels[license] || license }}
                                        </button>
                                    </span>
                                </div>
                            </template>
                        </div>
                    </template>

                    <template #footer>
                        <button type="button" class="btn me-2"
                            :class="modalData.GrantLicense.selected.length > 0 ? 'green-btn' : 'grey-btn'"
                            :disabled="modalData.GrantLicense.selected.length === 0" @click="GrantLicense()">
                            {{ $store.getters.GetTranslation('viewcharprofile', 'grant') }}
                        </button>

                        <button type="button" class="btn red-btn"
                            @click="modalData.GrantLicense = {show: false, selected: ''}">
                            {{ $store.getters.GetTranslation('viewcharprofile', 'close') }}
                        </button>
                    </template>
                </CustomModal>
            </Teleport>
        </template>

        <div class="row justify-content-md-center mb-4">
            <div class="col h3 text-center">
                {{ charName + $store.getters.GetTranslation('viewcharprofile', 'title') }}
            </div>
        </div>

        <div class="row justify-content-md-center">
            <div class="col-4">
                <!-- Photo Identification -->
                <div class="col-9 mdt-mugshot-frame m-auto">
                    <div class="row p-2">
                        <div class="col text-center" style="position: relative">
                            <template v-if="webCharData.photoIdImg.length > 1">
                                <Image :parentEl="'view-char-profile'" :img="webCharData.photoIdImg"
                                    :id="'profile_photo_identification'" :border="true" :options="{
                                        maxImgHeight: '25vh',
                                        canExpand: true,
                                    }" />
                            </template>

                            <template v-else>
                                <div class=" row d-flex align-items-center mdt-profiles-no-picture m-auto ">
                                    <div class="container-fluid">
                                        <div class="row justify-content-md-center mb-2">
                                            <div class="h6 text-center">
                                                {{ $store.getters.GetTranslation('viewcharprofile', 'no_photo') }}
                                            </div>
                                        </div>

                                        <template v-if="perms.editPhoto">
                                            <button class="btn blue-btn btn-sm" type="button" @click="SetImageModal()">
                                                {{ $store.getters.GetTranslation('viewcharprofile', 'add_photo') }}
                                            </button>
                                        </template>
                                    </div>
                                </div>
                            </template>
                        </div>
                    </div>

                    <div class=" row justify-content-md-center mdt-mugshot-lower p-2 pb-3 m-auto ">
                        <span class="h6 text-center align-middle" style="margin: 0">
                            {{ $store.getters.GetTranslation('viewcharprofile', 'photo_id') }}
                            <template v-if="webCharData.photoIdImg && !showPhotoOptions && perms.editPhoto">
                                <a href="#">
                                    <i class="fas fa-angle-down mdt-color-text ms-1"
                                        @click="showPhotoOptions = true"></i>
                                </a>
                            </template>

                            <template v-if="webCharData.photoIdImg && showPhotoOptions && perms.editPhoto">
                                <a href="#">
                                    <i class="fas fa-angle-up mdt-color-text ms-1"
                                        @click="showPhotoOptions = false"></i>
                                </a>
                            </template>
                        </span>

                        <template v-if="webCharData.photoIdImg && showPhotoOptions && perms.editPhoto">
                            <span class="text-center mt-2">
                                <button type="button" class="btn btn-sm blue-btn me-3" data-bs-toggle="tooltip"
                                    data-bs-placement="top"
                                    :title="$store.getters.GetTranslation('viewcharprofile', 'tooltip_1')"
                                    @click="SetImageModal()">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'replace') }}
                                </button>

                                <button type="button" class="btn btn-sm red-btn" data-bs-toggle="tooltip"
                                    data-bs-placement="top"
                                    :title="$store.getters.GetTranslation('viewcharprofile', 'tooltip_2')"
                                    @click="ShowModal('img')">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'delete') }}
                                </button>
                            </span>
                        </template>
                    </div>
                </div>

                <!-- Notes -->
                <div class="row justify-content-md-center mt-4">
                    <div class="col pt-1 pb-3">
                        <div class="row justify-content-center mdt-form">
                            <div class="row justify-content-md-center">
                                <div class="col h5 text-center">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'notes') }}
                                    <template v-if="editing.notes">
                                        <button type="button" class="btn btn-sm green-btn ms-1" @click="SaveNotes()">
                                            {{ $store.getters.GetTranslation('viewcharprofile', 'save') }}
                                        </button>
                                    </template>
                                </div>
                            </div>

                            <div class="col-11 text-center">
                                <textarea class="form-control"
                                    :placeholder="$store.getters.GetTranslation('viewcharprofile', 'ph_notes')"
                                    rows="10" v-model="webCharData.notes" @input="onNotesChange()"
                                    :disabled="!perms.editNotes"></textarea>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- General Data -->
            <div class="col-7">
                <div class="col pt-3 pb-3">
                    <div class="row justify-content-md-center">
                        <div class="col-4 h5 text-center">
                            {{ $store.getters.GetTranslation('viewcharprofile', 'general') }}
                        </div>
                    </div>

                    <div class="mdt-profiles-container pt-1 pb-3">
                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'col_fname') }}
                                </label>
                                <input class="form-control" type="text" v-model="webCharData.firstName" readonly />
                            </div>
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'col_lname') }}
                                </label>
                                <input class="form-control" type="text" v-model="webCharData.lastName" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'col_gender') }}
                                </label>
                                <input class="form-control" type="text" v-model="webCharData.gender" readonly />
                            </div>
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'col_dob') }}
                                </label>
                                <input class="form-control" type="text" v-model="webCharData.dob" readonly />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'col_war') }}
                                </label>
                                <input class="form-control"
                                    :class="{ alertStatus: webCharData.warrantStatus == $store.getters.GetTranslation('viewcharprofile', 'active_bolo'), 'fw-bold': webCharData.warrantStatus == $store.getters.GetTranslation('viewcharprofile', 'active_bolo'), }"
                                    type="text" v-model="webCharData.warrantStatus" readonly />
                            </div>

                            <div class="col-5">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'col_bolo') }}
                                </label>
                                <input class="form-control"
                                    :class="{ alertStatus: webCharData.boloStatus == $store.getters.GetTranslation('viewcharprofile', 'active_bolo'), 'fw-bold': webCharData.boloStatus == $store.getters.GetTranslation('viewcharprofile', 'active_bolo'), }"
                                    type="text" v-model="webCharData.boloStatus" readonly />
                            </div>
                        </div>
                    </div>

                    <div class="row justify-content-md-center mt-4">
                        <div class="col-6 h5 text-center">
                            {{ $store.getters.GetTranslation('viewcharprofile', 'contact') }}

                            <template v-if="!editing.contactInfo && perms.editContact">
                                <button type="button" class="btn btn-sm blue-btn ms-2"
                                    @click="editing.contactInfo = true">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'edit') }}
                                </button>
                            </template>

                            <template v-if="editing.contactInfo">
                                <button type="button" class="btn btn-sm green-btn ms-2" @click="SaveContactInfo()">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'save') }}
                                </button>
                            </template>
                        </div>
                    </div>

                    <div class="mdt-profiles-container pt-2 pb-2">
                        <div class="row justify-content-center mdt-form mt-2">
                            <div class="col-3">
                                <label class="col-form-label">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'col_phone') }}
                                </label>
                                <input class="form-control" :class="{ 'mdt-can-edit': editing.contactInfo }"
                                    :placeholder="$store.getters.GetTranslation('viewcharprofile', 'ph_none')"
                                    type="text" v-model="webCharData.phoneNumber" :readonly="!editing.contactInfo" />
                            </div>
                            <div class="col-7">
                                <label class="col-form-label">Address</label>
                                <input class="form-control" :class="{ 'mdt-can-edit': editing.contactInfo }"
                                    :placeholder="$store.getters.GetTranslation('viewcharprofile', 'ph_none')"
                                    type="text" v-model="webCharData.address" :readonly="!editing.contactInfo" />
                            </div>
                        </div>

                        <div class="row justify-content-center mdt-form mt-4">
                            <div class="text-center"
                                :class="{ 'col-6': !editing.contactInfo, 'col-8': editing.contactInfo }">
                                <div class="row justify-content-md-center">
                                    <div class="col-4 h6 text-center">
                                        {{ $store.getters.GetTranslation('viewcharprofile', 'col_related') }}
                                    </div>
                                </div>

                                <div class="mdtTable p-2">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th scope="col">
                                                    {{ $store.getters.GetTranslation('viewcharprofile', 'col_name') }}
                                                </th>
                                                <th scope="col">
                                                    {{ $store.getters.GetTranslation('viewcharprofile', 'col_relation')
                                                    }}
                                                </th>
                                                <template v-if="editing.contactInfo">
                                                    <th scope="col" style="width: 20%">
                                                        <button type="button" class="btn btn-sm green-btn"
                                                            @click="ShowModal('relations')">
                                                            {{ $store.getters.GetTranslation('viewcharprofile',
                                                            'add') }}
                                                        </button>
                                                    </th>
                                                </template>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <template v-for="(character, index) in webCharData.relatedTo"
                                                :key="`${index}_related_to`">
                                                <tr>
                                                    <td>{{ character.name }}</td>
                                                    <td>{{ character.relation }}</td>
                                                    <template v-if="editing.contactInfo">
                                                        <td>
                                                            <button type="button" class="btn btn-sm red-btn"
                                                                @click="webCharData.relatedTo.splice(index, 1)">
                                                                {{ $store.getters.GetTranslation('viewcharprofile',
                                                                'delete') }}
                                                            </button>
                                                        </td>
                                                    </template>
                                                </tr>
                                            </template>
                                        </tbody>
                                    </table>

                                    <template v-if="webCharData.relatedTo.length === 0 && !editing.contactInfo">
                                        <div class="h6 text-center">
                                            {{ $store.getters.GetTranslation('viewcharprofile', 'no_results') }}
                                        </div>
                                    </template>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row justify-content-center mt-4">
            <!-- Registered Vehicles -->
            <div class="col-4">
                <div class="row justify-content-md-center">
                    <div class="col h5 text-center">
                        {{ $store.getters.GetTranslation('viewcharprofile', 'vehicles') }}
                    </div>
                </div>

                <div class="mdt-profiles-container row justify-content-center p-2">
                    <div class="col">
                        <div class="mdtTable2 p-2">
                            <table class="table text-center">
                                <thead>
                                    <tr>
                                        <th scope="col" style="width: 45%">
                                            {{ $store.getters.GetTranslation('viewcharprofile', 'col_plate') }}
                                        </th>
                                        <th scope="col" style="width: 30%">
                                            {{ $store.getters.GetTranslation('viewcharprofile', 'col_vbolo') }}
                                        </th>
                                        <th scope="col" style="width: 25%">
                                            {{ $store.getters.GetTranslation('viewcharprofile', 'col_act') }}
                                        </th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <template v-for="(data, index) in pagination.vehicles.list" :key="index">
                                        <tr>
                                            <th>{{ data.plate }}</th>
                                            <td>
                                                <div
                                                    :class="{ 'alertStatus-vehicle': $store.getters.HasActiveVehBolo(data.plate) }">
                                                    {{ $store.getters.HasActiveVehBolo(data.plate) ?
                                                    $store.getters.GetTranslation('viewcharprofile', 'active_bolo') :
                                                    $store.getters.GetTranslation('viewcharprofile', 'no_bolo')
                                                    }}
                                                </div>
                                            </td>
                                            <td>
                                                <button type="button" class="btn btn-sm blue-btn ms-1"
                                                    @click="ViewVehProfile(data.plate)" data-bs-toggle="tooltip"
                                                    data-bs-placement="top"
                                                    :title="$store.getters.GetTranslation('viewcharprofile', 'tooltip_3')">
                                                    <i class="fas fa-external-link-alt"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </template>
                                </tbody>
                            </table>

                            <!-- Pagination -->
                            <div class="row" v-if="webCharData.vehicles.length > 0">
                                <div class="col">
                                    <nav aria-label="Page navigation example">
                                        <ul class="pagination justify-content-center">
                                            <!-- First -->
                                            <li class="page-item"
                                                :class="{ disabled: pagination.vehicles.currentPage === 1 }">
                                                <a class="page-link" href="#" @click="RefreshPage('vehicles', 1)">
                                                    <i class="fas fa-angle-double-left"></i>
                                                </a>
                                            </li>

                                            <!-- Pages -->
                                            <template
                                                v-for="page in Pagination(pagination.vehicles.currentPage, pagination.vehicles.totalPages)"
                                                :key="page">
                                                <li class="page-item"
                                                    :class="{ active: pagination.vehicles.currentPage === page }">
                                                    <a class="page-link" href="#"
                                                        @click="RefreshPage('vehicles', page)">
                                                        {{ page }}
                                                    </a>
                                                </li>
                                            </template>

                                            <!-- Last -->
                                            <li class="page-item"
                                                :class="{ disabled: pagination.vehicles.currentPage === pagination.vehicles.totalPages }">
                                                <a class="page-link" href="#"
                                                    @click="RefreshPage('vehicles', pagination.vehicles.totalPages)">
                                                    <i class="fas fa-angle-double-right"></i>
                                                </a>
                                            </li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>

                            <template v-if="webCharData.vehicles.length === 0">
                                <div class="h6 text-center">
                                    {{ $store.getters.GetTranslation('viewcharprofile', 'no_results') }}
                                </div>
                            </template>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Licenses & Criminal Record -->
            <div class="col-7">
                <div class="row justify-content-md-center">
                    <div class="col h5 text-center">
                        {{ $store.getters.GetTranslation('viewcharprofile', 'license_record') }}
                    </div>
                </div>

                <div class="container table-con mdtTable p-2">
                    <ul class="nav nav-pills mb-3 justify-content-center" id="pills-tab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="profiles-licenses-tab" data-bs-toggle="pill"
                                data-bs-target="#profiles-licenses" type="button" role="tab"
                                aria-controls="profiles-licenses" aria-selected="true">
                                {{ $store.getters.GetTranslation('viewcharprofile', 'cat_lic') }}
                            </button>
                        </li>

                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="profiles-unpaid-fines-tab" data-bs-toggle="pill"
                                data-bs-target="#profiles-unpaid-fines" type="button" role="tab"
                                aria-controls="profiles-unpaid-fines" aria-selected="false">
                                {{ $store.getters.GetTranslation('viewcharprofile', 'cat_fines') }}
                            </button>
                        </li>

                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="profiles-charges-tab" data-bs-toggle="pill"
                                data-bs-target="#profiles-charges" type="button" role="tab"
                                aria-controls="profiles-charges" aria-selected="false">
                                {{ $store.getters.GetTranslation('viewcharprofile', 'cat_record') }}
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content" id="pills-tabContent">
                        <div class="tab-pane fade active show" id="profiles-licenses" role="tabpanel"
                            aria-labelledby="profiles-licenses-tab">
                            <div class="row justify-content-center">
                                <div class="col-8 col-xxl-6">
                                    <table class="table text-center">
                                        <thead>
                                            <tr>
                                                <th scope="col" style="width: 75%">
                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                    'col_lictype') }}
                                                </th>
                                                <th scope="col" style="width: 25%">
                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                    'col_act') }}
                                                </th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <template v-for="(license, index) in webCharData.licenses"
                                                :key="`${index}_license`">
                                                <tr>
                                                    <td>
                                                        {{ $store.state.config.LicenseLabels[license] || `Unknown -
                                                        "${license}"` }}
                                                    </td>
                                                    <td>
                                                        <template v-if="perms.revokeLicenses">
                                                            <button type="button" class="btn btn-sm red-btn"
                                                                @click="RemoveLicense(license, index)">
                                                                {{ $store.getters.GetTranslation('viewcharprofile',
                                                                'revoke') }}
                                                            </button>
                                                        </template>

                                                        <template v-else>
                                                            <button type="button" class="btn btn-sm grey-btn" disabled>
                                                                {{ $store.getters.GetTranslation('viewcharprofile',
                                                                'revoke') }}
                                                            </button>
                                                        </template>
                                                    </td>
                                                </tr>
                                            </template>


                                        </tbody>
                                    </table>

                                    <template v-if="webCharData.licenses.length === 0">
                                        <div class="h6 text-center mb-2">
                                            {{ $store.getters.GetTranslation('viewcharprofile', 'no_results') }}
                                        </div>
                                    </template>

                                    <div class="mt-1 text-center">
                                        <button type="button" class="btn btn-sm blue-btn"
                                            @click="modalData.GrantLicense.show = true">
                                            {{ $store.getters.GetTranslation('viewcharprofile',
                                            'grant_lic') }}
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="profiles-unpaid-fines" role="tabpanel"
                            aria-labelledby="profiles-unpaid-fines-tab">
                            <div class="row justify-content-center">
                                <div class="col-11">
                                    <table class="table text-center">
                                        <thead>
                                            <tr>
                                                <th scope="col" style="width: 10%">
                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                    'col_id') }}
                                                </th>
                                                <th scope="col" style="width: 25%">
                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                    'col_fine') }}
                                                </th>
                                                <th scope="col" style="width: 20%">
                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                    'col_dateoffense') }}
                                                </th>
                                                <th scope="col" style="width: 20%">
                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                    'col_due') }}
                                                </th>
                                                <th scope="col" style="width: 25%">
                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                    'col_act') }}
                                                </th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <template v-for="(data, index) in pagination.unpaidFines.list" :key="index">
                                                <tr>
                                                    <td>{{ data.reference }}</td>
                                                    <th>{{ `$${FormatNumber(data.fine)}` }}</th>
                                                    <td>{{ FormatDate(data.date) }}</td>
                                                    <td :class="{ 'overdue-fine': data.due_date < Date.now() }">{{
                                                    FormatDate(data.due_date) }}</td>
                                                    <template v-if="data.paid !== 2">
                                                        <td>
                                                            <template v-if="perms.exemptFines">
                                                                <button type="button" class="btn btn-sm red-btn me-2"
                                                                    @click="ShowModal('fines', data.id)">
                                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                                    'exempt') }}
                                                                </button>
                                                            </template>

                                                            <button type="button" class="btn btn-sm blue-btn"
                                                                @click="ViewReport(data.reference)">
                                                                {{ $store.getters.GetTranslation('viewcharprofile',
                                                                'view') }}
                                                            </button>
                                                        </td>
                                                    </template>
                                                    <template v-else-if="data.paid === 2">
                                                        <td>
                                                            <button type="button" class="btn btn-sm grey-btn" disabled>
                                                                {{ $store.getters.GetTranslation('viewcharprofile',
                                                                'exempted') }}
                                                            </button>
                                                        </td>
                                                    </template>
                                                </tr>
                                            </template>
                                        </tbody>
                                    </table>

                                    <!-- Pagination -->
                                    <div class="row" v-if="webCharData.unpaidFines.length > 0">
                                        <div class="col">
                                            <nav aria-label="Page navigation example">
                                                <ul class="pagination justify-content-center">
                                                    <!-- First -->
                                                    <li class="page-item"
                                                        :class="{ disabled: pagination.unpaidFines.currentPage === 1 }">
                                                        <a class="page-link" href="#"
                                                            @click="RefreshPage('unpaidFines', 1)">
                                                            <i class="fas fa-angle-double-left"></i>
                                                        </a>
                                                    </li>

                                                    <!-- Pages -->
                                                    <template
                                                        v-for="page in Pagination(pagination.unpaidFines.currentPage, pagination.unpaidFines.totalPages)"
                                                        :key="page">
                                                        <li class="page-item"
                                                            :class="{ active: pagination.unpaidFines.currentPage === page }">
                                                            <a class="page-link" href="#"
                                                                @click="RefreshPage('unpaidFines', page)">
                                                                {{ page }}
                                                            </a>
                                                        </li>
                                                    </template>

                                                    <!-- Last -->
                                                    <li class="page-item"
                                                        :class="{ disabled: pagination.unpaidFines.currentPage === pagination.unpaidFines.totalPages }">
                                                        <a class="page-link" href="#"
                                                            @click="RefreshPage('unpaidFines', pagination.unpaidFines.totalPages)">
                                                            <i class="fas fa-angle-double-right"></i>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </nav>
                                        </div>
                                    </div>

                                    <template v-if="webCharData.unpaidFines.length === 0">
                                        <div class="h6 text-center">
                                            {{ $store.getters.GetTranslation('viewcharprofile', 'no_results') }}
                                        </div>
                                    </template>
                                </div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="profiles-charges" role="tabpanel"
                            aria-labelledby="profiles-charges-tab">
                            <div class="row justify-content-center">
                                <div class="col-11">
                                    <table class="table text-center">
                                        <thead>
                                            <tr>
                                                <th scope="col" style="width: 10%">
                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                    'col_id') }}
                                                </th>
                                                <th scope="col" style="width: 10%">
                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                    'col_type') }}
                                                </th>
                                                <th scope="col" style="width: 35%">
                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                    'col_ref') }}
                                                </th>
                                                <th scope="col" style="width: 25%">
                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                    'col_date') }}
                                                </th>
                                                <th scope="col" style="width: 15%">
                                                    {{ $store.getters.GetTranslation('viewcharprofile',
                                                    'col_act') }}
                                                </th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <template v-for="(data, index) in pagination.crimRecord.list" :key="index">
                                                <tr>
                                                    <th>{{ FormatNumber(data.id) }}</th>
                                                    <td>{{ data.type }}</td>
                                                    <td>{{ data.description }}</td>
                                                    <td>{{ FormatDate(data.date) }}</td>
                                                    <td>
                                                        <button type="button" class="btn btn-sm blue-btn"
                                                            @click="ViewReport(data.id)">
                                                            {{ $store.getters.GetTranslation('viewcharprofile',
                                                            'view') }}
                                                        </button>
                                                    </td>
                                                </tr>
                                            </template>
                                        </tbody>
                                    </table>

                                    <!-- Pagination -->
                                    <div class="row" v-if="webCharData.crimRecord.length > 0">
                                        <div class="col">
                                            <nav aria-label="Page navigation example">
                                                <ul class="pagination justify-content-center">
                                                    <!-- First -->
                                                    <li class="page-item"
                                                        :class="{ disabled: pagination.crimRecord.currentPage === 1 }">
                                                        <a class="page-link" href="#"
                                                            @click="RefreshPage('crimRecord', 1)">
                                                            <i class="fas fa-angle-double-left"></i>
                                                        </a>
                                                    </li>

                                                    <!-- Pages -->
                                                    <template
                                                        v-for="page in Pagination(pagination.crimRecord.currentPage, pagination.crimRecord.totalPages)"
                                                        :key="page">
                                                        <li class="page-item"
                                                            :class="{ active: pagination.crimRecord.currentPage === page }">
                                                            <a class="page-link" href="#"
                                                                @click="RefreshPage('crimRecord', page)">
                                                                {{ page }}
                                                            </a>
                                                        </li>
                                                    </template>

                                                    <!-- Last -->
                                                    <li class="page-item"
                                                        :class="{ disabled: pagination.crimRecord.currentPage === pagination.crimRecord.totalPages }">
                                                        <a class="page-link" href="#"
                                                            @click="RefreshPage('crimRecord', pagination.crimRecord.totalPages)">
                                                            <i class="fas fa-angle-double-right"></i>
                                                        </a>
                                                    </li>
                                                </ul>
                                            </nav>
                                        </div>
                                    </div>

                                    <template v-if="webCharData.crimRecord.length === 0">
                                        <div class="h6 text-center">
                                            {{ $store.getters.GetTranslation('viewcharprofile', 'no_results') }}
                                        </div>
                                    </template>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row justify-content-md-center mt-4">
            <div class="col h3 text-center">
                <button type="button" class="btn grey-btn" @click="GoBack()">
                    <i class="fas fa-caret-left"></i>
                    {{ $store.getters.GetTranslation('viewcharprofile', 'back') }}
                </button>
            </div>
        </div>
    </div>

    <template v-if="modalData.ViewReport.show">
        <ViewReport @go-back="GoBackReport" :parentElId="parentEl" :record="modalData.ViewReport.data" />
    </template>
</template>

<script>
import AddImage from "../../Modals/Images/AddImage";
import ViewReport from "./ViewReport";
import Image from "../../Modules/Image";
import ConfirmationModal from "../../Modals/General/Confirmation";
import CustomModal from "../../Modals/General/CustomModal";

import api from '@/api/main'

export default {
    name: "ViewCharModule",
    emits: ['go-back'],
    components: {
        AddImage,
        ViewReport,
        Image,
        ConfirmationModal,
        CustomModal,
    },
    props: ["parentEl", "charData", "charName"],
    data() {
        return {
            modalData: {
                DelImgConfirmation: {
                    show: false,
                    data: "",
                },
                FineConfirmation: {
                    show: false,
                    data: "",
                    id: false,
                },
                AddImage: {
                    show: false,
                },
                AddRelation: {
                    show: false,
                    validationFeedback: "",
                    inputFields: {
                        name: "",
                        relation: "",
                    },
                },
                GrantLicense: {
                    show: false,
                    selected: "",
                },
                ViewReport: {
                    show: false,
                    data: false,
                }
            },

            showPhotoOptions: false,

            webCharData: {
                // Data used in the front end
                // Photo Identification
                photoIdImg: "",

                // General
                firstName: "",
                lastName: "",
                dob: "",
                gender: "",
                warrantStatus: "",
                boloStatus: "",

                // Contact Info
                phoneNumber: "",
                address: "",
                relatedTo: [],

                // Registered Licenses
                licenses: [],

                // Criminal Record
                crimRecord: [],

                // Unpaid fines
                unpaidFines: [],

                // Registered/Owned vehicles
                vehicles: [],

                // Notes
                notes: "",
            },

            pagination: {
                vehicles: {
                    list: [],
                    currentPage: 1,
                    totalPages: false,
                },
                unpaidFines: {
                    list: [],
                    currentPage: 1,
                    totalPages: false,
                },
                crimRecord: {
                    list: [],
                    currentPage: 1,
                    totalPages: false,
                },
            },

            editing: {
                contactInfo: false,
                notes: false
            },

            perms: {
                editPhoto: false,
                editNotes: false,
                editContact: false,
                revokeLicenses: false,
                grantLicenses: false,
                exemptFines: false,
            }
        };
    },
    mounted() {
        this.SetupData();

        this.modalData.DelImgConfirmation.data = this.$store.getters.GetTranslation('viewcharprofile', 'img_del');
        this.modalData.FineConfirmation.data = this.$store.getters.GetTranslation('viewcharprofile', 'fine_exe');
        this.CheckPerms();
    },
    methods: {
        CheckPerms() {
            let player = this.$store.getters.GetSelf()

            if (player) {
                const playerJob = player.job

                this.perms.editPhoto = this.$store.getters.HasPerm(playerJob, 'civProfile', 'editPhotoID')
                this.perms.editNotes = this.$store.getters.HasPerm(playerJob, 'civProfile', 'editNotes')
                this.perms.editContact = this.$store.getters.HasPerm(playerJob, 'civProfile', 'editContact')
                this.perms.revokeLicenses = this.$store.getters.HasPerm(playerJob, 'civProfile', 'revokeLicenses')
                this.perms.grantLicenses = this.$store.getters.HasPerm(playerJob, 'civProfile', 'grantLicenses')
                this.perms.exemptFines = this.$store.getters.HasPerm(playerJob, 'civProfile', 'exemptFines')
            }
        },

        ShowModal(id, data) {
            if (id === 'fines') {
                if (!this.modalData.FineConfirmation.show) {
                    this.modalData.FineConfirmation.id = data;
                    this.modalData.FineConfirmation.show = true;
                }
            } else if (id === 'img') {
                if (!this.modalData.DelImgConfirmation.show) {
                    this.modalData.DelImgConfirmation.show = true;
                }
            } else if (id === 'relations') {
                if (!this.modalData.AddRelation.show) {
                    this.modalData.AddRelation.show = true;
                }
            }
        },

        ViewVehProfile(plate) {
            this.ToggleLoadingScreen(true)
            this.HidePage()

            setTimeout(async () => {
                const result = await api.vehicles.GetProfile(plate)
                //console.log(result)

                if (result) {
                    this.$emit('switch-veh-profile', result)
                } else {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('viewcharprofile', 'error_1'),
                        this.$store.getters.GetTranslation('viewcharprofile', 'error_1_msg'),
                        5000,
                        'error',
                        false,
                        true
                    );
                }
            }, 160)
        },

        GoBack() {
            this.HidePage()
            setTimeout(() => { this.$emit('go-back') }, 160)
        },

        SaveContactInfo() {
            this.editing.contactInfo = false

            let newContactInfo = {
                phone: this.webCharData.phoneNumber,
                address: this.webCharData.address,
                relatedTo: this.webCharData.relatedTo
            }

            this.SendNotification(
                this.$store.getters.GetTranslation('viewcharprofile', 'saved'),
                this.$store.getters.GetTranslation('viewcharprofile', 'saved_msg'),
                5000,
                'success',
                false,
                false
            );

            api.characters.UpdateProfile(this.charData.identifier, false, newContactInfo, false)
        },

        onNotesChange() {
            if ( !this.editing.notes ) {
                this.editing.notes = true
            }
        },
        SaveNotes() {
            this.editing.notes = false

            api.characters.UpdateProfile(this.charData.identifier, false, false, this.webCharData.notes)

            this.SendNotification(
                this.$store.getters.GetTranslation('viewcharprofile', 'saved'),
                this.$store.getters.GetTranslation('viewcharprofile', 'saved_msg'),
                5000,
                'success',
                false,
                false
            );
        },

        ExemptFine(status) {
            let fineID = this.modalData.FineConfirmation.id
            if (status) {
                api.reports.ExemptFine(fineID);

                let selectedFine = this.pagination.unpaidFines.list.find(fine => fine.id === fineID);
                selectedFine.paid = 2; // Mark as exempted

                this.SendNotification(
                    this.$store.getters.GetTranslation('viewcharprofile', 'fine_exempted'),
                    this.$store.getters.GetTranslation('viewcharprofile', 'fine_exempted_msg'),
                    5000,
                    'success',
                    false,
                    false
                );
            }

            this.modalData.FineConfirmation.id = false
        },

        async ViewReport(id) {
            if (!this.modalData.ViewReport.show) {
                let apiResp = await api.reports.FetchReport(id);

                if ( apiResp ) {
                    this.modalData.ViewReport.data = apiResp
                    this.modalData.ViewReport.show = true;

                    setTimeout(() => {
                        this.TransitionEl('view-char-profile', 'view-report')
                    }, 10)
                } else {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('viewcharprofile', 'error_2'),
                        this.$store.getters.GetTranslation('viewcharprofile', 'error_2_msg'),
                        7500,
                        'error',
                        false,
                        true
                    );
                }

            }
        },
        GoBackReport(refresh) {
            if (this.modalData.ViewReport.show) {
                setTimeout(async () => {
                    this.modalData.ViewReport.show = false;
                    this.modalData.ViewReport.data = false;

                    if ( refresh ) {
                        this.ToggleLoadingScreen(true)
                        this.webCharData.crimRecord = await api.reports.FetchReportHistory(this.charData.identifier);

                        this.InitPage('crimRecord')
                        this.ToggleLoadingScreen(false)
                    }
                }, 200)

                setTimeout(() => {
                    this.TransitionEl('view-report', 'view-char-profile')
                }, 10)
            }
        },

        async GrantLicense() {
            this.ToggleLoadingScreen(true);
            let license = this.modalData.GrantLicense.selected;

            if (license != '') {
                let resp = await api.characters.GrantLicense(this.charData.identifier, license);

                if (resp) {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('viewcharprofile', 'granted_success'),
                        this.$store.getters.GetTranslation('viewcharprofile', 'granted_success_msg'),
                        5000,
                        'success',
                        false,
                        false
                    );
                    this.webCharData.licenses.push(license);
                } else {
                    this.SendNotification(
                        this.$store.getters.GetTranslation('viewcharprofile', 'granted_error'),
                        this.$store.getters.GetTranslation('viewcharprofile', 'granted_error_msg'),
                        7500,
                        'error',
                        true,
                        true
                    );
                }
                this.ToggleLoadingScreen(false);
            }

            // Reset data
            this.modalData.GrantLicense = {
                show: false,
                selected: ""
            }
        },

        RemoveLicense(license, index) {
            this.webCharData.licenses.splice(index, 1);

            api.characters.RevokeLicense(this.charData.identifier, license)

            this.SendNotification(
                this.$store.getters.GetTranslation('viewcharprofile', 'revoked'),
                this.$store.getters.GetTranslation('viewcharprofile', 'revoked_msg'),
                5000,
                'success',
                false,
                false
            );
        },

        AddRelation(name, relation) {
            if (name != "" && relation != "") {
                this.modalData.AddRelation.validationFeedback = "";
                this.webCharData.relatedTo.push({
                    name: name,
                    relation: relation,
                });

                this.modalData.AddRelation.inputFields = {
                    name: "",
                    relation: "",
                };
                this.modalData.AddRelation.show = false
            } else {
                this.modalData.AddRelation.validationFeedback = this.$store.getters.GetTranslation('addrelation', 'feedback');
            }
        },

        DeleteImage(status) {
            if (status) {
                this.webCharData.photoIdImg = "";
                api.characters.UpdateProfile(this.charData.identifier, "", false, false)

                this.SendNotification(
                    this.$store.getters.GetTranslation('viewcharprofile', 'img_deleted'),
                    this.$store.getters.GetTranslation('viewcharprofile', 'img_deleted_msg'),
                    5000,
                    'success',
                    false,
                    false
                );

                setTimeout(() => {
                    this.RefreshBS();
                }, 100);
            }
        },
        SetImageModal() {
            if (!this.modalData.AddImage.show) {
                this.modalData.AddImage.show = true;

                setTimeout(() => {
                    this.modalData.AddImage.show = false;
                }, 200);
            }
        },
        SetPhotoId(data) {
            this.webCharData.photoIdImg = data.img;

            api.characters.UpdateProfile(this.charData.identifier, data.img, false, false)

            this.SendNotification(
                this.$store.getters.GetTranslation('viewcharprofile', 'submitted'),
                this.$store.getters.GetTranslation('viewcharprofile', 'submitted_msg'),
                5000,
                'success',
                false,
                false
            );
        },

        SetupData() {
            this.webCharData = {
                photoIdImg: this.charData.photoId,

                firstName: this.charData.firstName,
                lastName: this.charData.lastName,
                gender: this.charData.sex,
                dob: this.charData.dob,
                warrantStatus: this.$store.getters.HasActiveWarrant(this.charData.identifier) ? this.$store.getters.GetTranslation('viewcharprofile', 'active_bolo') : this.$store.getters.GetTranslation('viewcharprofile', 'no_bolo'),
                boloStatus: this.$store.getters.HasActiveBolo(this.charData.identifier) ? this.$store.getters.GetTranslation('viewcharprofile', 'active_bolo') : this.$store.getters.GetTranslation('viewcharprofile', 'no_bolo'),

                phoneNumber: this.charData.contact.phone,
                address: this.charData.contact.address,
                relatedTo: this.charData.contact.relatedTo,

                licenses: this.charData.licenses,
                crimRecord: this.charData.record,
                vehicles: this.charData.vehicles,

                notes: this.charData.notes,

                unpaidFines: this.charData.fines.filter((fine) => fine.paid === 0),
            };

            var priorsEl = document.getElementById('profiles-charges-tab')
            var finesTab = document.getElementById('profiles-unpaid-fines-tab')
            if (priorsEl.classList.contains('active') || finesTab.classList.contains('active')) {
                if (priorsEl.classList.contains('active')) {
                    priorsEl.classList.remove('active')
                } else if (finesTab.classList.contains('active')) {
                    finesTab.classList.remove('active')
                }

                var licenseEl = document.getElementById('profiles-licenses-tab')
                licenseEl.classList.add('active')
            }

            this.InitPage('vehicles')
            this.InitPage('crimRecord')
            this.InitPage('unpaidFines')

            setTimeout(() => {
                this.ShowPage()
                this.ToggleLoadingScreen(false)

                setTimeout(() => {
                    this.RefreshBS();
                }, 500)
            }, 1500)
        },

        InitPage(type) {
            const entriesPerPage = 8
            let newPage = []

            newPage = this.webCharData[type].slice(
                0, // Index start
                entriesPerPage // Index end
            )

            this.pagination[type].currentPage = 1
            this.pagination[type].list = newPage
            this.pagination[type].totalPages = Math.ceil(this.webCharData[type].length / entriesPerPage)
        },

        RefreshPage(type, page) {
            const entriesPerPage = 8
            let newPage = []

            newPage = this.webCharData[type].slice(
                entriesPerPage * (page - 1), // Index start
                (entriesPerPage * page) // Index end
            )

            this.pagination[type].currentPage = page
            this.pagination[type].list = newPage
        },

        ShowPage() {
            var page = document.getElementById('view-char-profile');
            page.classList.add("show");
        },
        HidePage() {
            var page = document.getElementById('view-char-profile');
            page.classList.remove("show");
        },

        TransitionEl(incoming, outgoing) {
            var incomingEl = document.getElementById(incoming);
            var outgoingEl = document.getElementById(outgoing);

            incomingEl.classList.remove("show");
            outgoingEl.style.display = 'none';
            setTimeout(() => {
                incomingEl.style.display = 'none';
                outgoingEl.style.display = 'block';

                setTimeout(() => {
                    outgoingEl.classList.add("show");

                    this.RefreshBS();
                }, 10);
            }, 150);
        },
    },
};
</script>

<style lang="scss" scoped>
$primaryColor: #1d1f25;
$primaryColorLight: #2a2c34;
$primaryColorLightHover: #383a44;
$secondaryColor: #e37926;
$secondaryColorHover: #b46020;
$secondaryDarkColor: #a5571b;
$secondaryDarkColorHover: #854513;
$textColor: #ececec;
$textColorHover: #bfbfbf;

// Form specific
//$formBackground: #0000002a;
$formBackground: #2d3138;
$formPlaceholderText: #0504047c;

// Colors
$redColor: #9f1600;
$redFadedColor: #9f1500ab;
$redColorHover: #7e1100;

$greenColor: #007b1d;
$greenFadedColor: #007b1db6;
$greenColorHover: #006317;

$purpleColor: #884ea0;
$purpleFadedColor: #874ea0a9;
$purpleColorHover: #71368a;

$tealColor: #16a085;
$tealFadedColor: #16a084a8;
$tealColorHover: #107a65;

$yellowColor: #d39736;
$yellowFadedColor: #f5b041b7;
$yellowColorHover: #d39634;

$blueColor: #2e86c1;
$blueFadedColor: #2e86c1a6;
$blueColorHover: #2170a5;

$greyColor: #839192;
$greyFadedColor: #8391929d;
$greyColorHover: #707b7c;

$light-greenColor: #41a068;
$light-greenFadedColor: #41a068b4;
$light-greenColorHover: #31794f;

.mdt-profiles-no-picture {
    height: 25vh;
    background-color: rgba(0, 0, 0, 0.425);
    width: 100%;
}

.mdt-profiles-container {
    background-color: $primaryColorLightHover;
    border-radius: 5px;

    input,
    textarea {
        background-color: $formBackground !important;
    }

    .mdtTable {
        background-color: $formBackground;

        .table {
            color: $textColor;
            background-color: $formBackground !important;
        }
    }
}

.alertStatus {
    color: $textColor !important;
    box-shadow: 0 0 10px $redFadedColor;
    padding: 4px 6px;
    border-radius: 5px;
    animation: blinkAlert 1s ease infinite;
}

.alertStatus-vehicle {
    font-weight: bold;
    background-color: $redColor;
    box-shadow: 0 0 10px $redFadedColor;
    padding: 4px 6px;
    border-radius: 5px;
    animation: blinkVehAlert 1s ease infinite;
}

@keyframes blinkVehAlert {
    0% {
        box-shadow: 0 0 10px rgba(255, 255, 255, 0);
        background-color: rgba(255, 255, 255, 0);
    }
    50% {
        box-shadow: 0 0 10px $redFadedColor;
        background-color: $redColorHover;
    }
    100% {
        box-shadow: 0 0 10px rgba(255, 255, 255, 0);
        background-color: rgba(255, 255, 169, 0);
    }
}

.overdue-fine {
    color: $yellowColor;
    font-weight: bold;
}

.mdt-mugshot-frame {
    background-color: $primaryColorLightHover;
    border-radius: 5px;

    .mdt-mugshot-lower {
        width: 100%;
        background-color: $primaryColorLightHover;
    }
}

.mdt-can-edit {
    color: $textColor !important;
}

.mdtTable {
    background-color: $primaryColorLightHover;
    border-radius: 5px;

    .table {
        color: $textColor;
        background-color: $primaryColorLightHover;
    }

    .table-con {
        border: 10px $primaryColorLightHover solid;
        border-radius: 5px;
        background-color: $primaryColorLightHover;
    }
}

.mdtTable2 {
    background-color: $primaryColorLightHover;
    border-radius: 5px;

    .table {
        color: $textColor;
        background-color: $primaryColorLightHover;
    }

    .table-con {
        border: 10px $primaryColorLightHover solid;
        border-radius: 5px;
        background-color: $primaryColorLightHover;
    }
}

@keyframes blinkAlert {
    0% {
        box-shadow: 0 0 10px rgba(255, 255, 255, 0);
        background-color: rgba(255, 255, 255, 0);
    }
    50% {
        box-shadow: 0 0 10px $redColor;
    }
    100% {
        box-shadow: 0 0 10px rgba(255, 255, 255, 0);
        background-color: rgba(255, 255, 169, 0);
    }
}
</style>
