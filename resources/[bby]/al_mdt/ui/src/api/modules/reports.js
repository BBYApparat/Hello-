import store from '@/store'
const resourceName = 'al_mdt'

class reportsApi {
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

    // [POST] Jail Player
    async JailPlayer(identifier, reason, time) {
        try {
            this.Post('jailPlayer', {
                identifier: identifier,
                reason: reason,
                time: time,
            })
        } catch (error) {
            console.log('Error caught (Jailing player): ', error)
            return false
        }
    }

    // [POST] Fetch report
    async FetchReport(id) {
        try {
            return await this.Post('fetchReport', id)
        } catch (error) {
            console.log('Error caught (Fetching report): ', error)
            return false
        }
    }

    // [POST] Fetch criminal record
    async FetchReportHistory(identifier) {
        return await this.Post('getCriminalRecord', identifier)
    }

    // [POST] Fetch recent reports
    async FetchRecentReports() {
        try {
            return await this.Post('fetchSelfRecentReports', store.getters.GetSelf().identifier)
        } catch (error) {
            console.log('Error caught (Fetching self recent reports): ', error)
            return false
        }
    }

    // [POST] Fetch all reports
    async FetchAllReports(page, getTotalPages, filter) {
        try {
            return await this.Post('fetchReports', {
                page: page,
                getTotalPages: getTotalPages,
                filter: filter
            })
        } catch (error) {
            console.log('Error caught (Fetching all reports): ', error)
            return false
        }
    }

    // [POST] Add (incident or arrest) report entry
    AddRecordEntry(entry) {
        try {
            this.Post('addRecordEntry', entry)
        } catch (error) {
            console.log('Error caught (Adding report): ', error)
        }
    }

    // [POST] Update (incident or arrest) report entry
    UpdateRecordEntry(entry) {
        try {
            this.Post('updateRecordEntry', entry)
        } catch (error) {
            console.log('Error caught (Updating report): ', error)
        }
    }

    // [POST] Delete (incident or arrest) report entry
    DeleteRecordEntry(entryId) {
        try {
            this.Post('deleteRecordEntry', entryId)
        } catch (error) {
            console.log('Error caught (Deleting report): ', error)
        }
    }

    // [POST] Fetch fines
    async FetchFines(identifier) {
        try {
            return await this.Post('fetchFines', identifier)
        } catch (error) {
            console.log('Error caught (Fetching fines): ', error)
        }
    }

    // [POST] Update fine
    async PayFine(data) {
        try {
            return await this.Post('payFine', data)
        } catch (error) {
            console.log('Error caught (Updating fines): ', error)
        }
    }

    // [POST] Exempt fine
    ExemptFine(id) {
        try {
            this.Post('exemptFine', id)
        } catch (error) {
            console.log('Error caught (Exempting fine): ', error)
        }
    }
}

const instance = new reportsApi()

export default instance