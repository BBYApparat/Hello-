//import store from '@/store'
const resourceName = 'al_mdt'

class vehiclesApi {
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
    async GetVehiclePlates(plate) {
        let vehData = await this.Post('getVehiclePlates', {
            plate: plate,
        })
        let queryResults = [];

        if (Array.isArray(vehData)) {
            vehData.forEach((val, index, arry) => {
                if (val) {
                    if (val === plate) { // Plate match
                        queryResults.unshift(arry[index]);
                    } else {
                        queryResults.push(arry[index]);
                    }
                }
            });
        }
        return queryResults
    }

    // [POST] Fetch vehicle profile
    async GetProfile(plate) {
        return await this.Post('getVehProfile', plate)
    }

    // [POST] Update profile
    UpdateProfile(plate, model, color, photoId, notes) {
        this.Post('updateVehProfile', {
            plate: plate,
            model: model,
            color: color,
            photoId: photoId,
            notes: notes,
        })
    }
}

const instance = new vehiclesApi()

export default instance