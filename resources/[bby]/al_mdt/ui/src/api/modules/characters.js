//import store from '@/store'
const resourceName = 'al_mdt'

class charactersApi {
    async Post(method, data) {
        if (process.env.NODE_ENV !== 'development') {
            const formattedData = data === undefined ? '{}' : JSON.stringify(data)

            try {
                let response = await fetch(`https://${resourceName}/${method}`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: formattedData
                });

                return await response.json()
            } catch (error) {
                return false
            }
        }
    }

    // [POST] Fetch Data
    async GetCharacterByName(firstName, lastName, gender) {
        let charData = await this.Post('getCharacterByName', {
            firstName: firstName,
            lastName: lastName,
            gender: gender === 'NA' ? false : gender
        })
        let queryResults = [];

        if (Array.isArray(charData)) {
            charData.forEach((val, index, arry) => {
                if (val) {
                    if (gender !== "NA" && val.sex === gender) { // With gender filter
                        if (val.firstName.toLowerCase().match(firstName.toLowerCase())) {// First Name Match
                            if (val.lastName.toLowerCase().match(lastName.toLowerCase())) {// Last Name Match
                                queryResults.unshift(arry[index]);
                            } else {
                                queryResults.push(arry[index]);
                            }
                        } else if (val.lastName.toLowerCase().match(lastName.toLowerCase())) { // Last Name Match
                            queryResults.push(arry[index]);
                        }
                    } else if (gender === "NA") {// No gender filter
                        if (val.firstName.toLowerCase().match(firstName.toLowerCase())) {// First Name Match
                            if (val.lastName.toLowerCase().match(lastName.toLowerCase())) {// Last Name Match
                                queryResults.unshift(arry[index]);
                            } else {
                                queryResults.push(arry[index]);
                            }
                        } else if (val.lastName.toLowerCase().match(lastName.toLowerCase())) {// Last Name Match
                            queryResults.push(arry[index]);
                        }
                    }
                }
            });
        }
        return queryResults
    }

    // [POST] Fetch detailed profile
    async GetDetailedProfile(identifier) {
        return await this.Post('getCharacterDetailedProfile', { identifier: identifier })
    }

    // [POST] Fetch licenses
    async GetCharacterLicenses(identifier) {
        let licenses = await this.Post('getCharacterLicenses', identifier)

        return licenses
    }

    // [POST] Revoke license
    RevokeLicense(identifier, license) {
        this.Post('revokeLicense', {
            identifier: identifier,
            license: license
        })
    }

    // [POST] Grant license
    async GrantLicense(identifier, license) {
        return await this.Post('grantLicense', {
            identifier: identifier,
            license: license
        })
    }

    // [POST] Update profile
    UpdateProfile(identifier, photoId, contact, notes) {
        this.Post('updateProfile', {
            identifier: identifier,
            photoId: photoId,
            contact: contact,
            notes: notes
        })
    }
}

const instance = new charactersApi()

export default instance