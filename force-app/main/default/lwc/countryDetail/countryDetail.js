import { LightningElement, api, wire } from "lwc";
import { getRecord, getFieldValue } from "lightning/uiRecordApi";

const COUNTRY_NAME_FIELD = "Lead.CountryDetail__r.Name";
const FLAG_URL_FIELD = "Lead.CountryDetail__r.FlagUrl__c";
const CAPITAL_FIELD = "Lead.CountryDetail__r.Capital__c";
const REGION_FIELD = "Lead.CountryDetail__r.Region__c";
const SUBREGION_FIELD = "Lead.CountryDetail__r.Subregion__c";
const REGIONAL_BLOCS_FIELD = "Lead.CountryDetail__r.RegionalBlocs__c";
const TIMEZONES_FIELD = "Lead.CountryDetail__r.Timezones__c";
const FIELDS = [
    COUNTRY_NAME_FIELD,
    CAPITAL_FIELD,
    FLAG_URL_FIELD,
    REGION_FIELD,
    SUBREGION_FIELD,
    REGIONAL_BLOCS_FIELD,
    TIMEZONES_FIELD
];

export default class CountryDetail extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    lead;

    get name() {
        return getFieldValue(this.lead.data, COUNTRY_NAME_FIELD);
    }

    get capital() {
        return getFieldValue(this.lead.data, CAPITAL_FIELD);
    }

    get flagUrl() {
        return getFieldValue(this.lead.data, FLAG_URL_FIELD);
    }

    get region() {
        return getFieldValue(this.lead.data, REGION_FIELD);
    }

    get subregion() {
        return getFieldValue(this.lead.data, SUBREGION_FIELD);
    }

    get regionalBlocs() {
        return getFieldValue(this.lead.data, REGIONAL_BLOCS_FIELD) || "-";
    }

    get timezones() {
        const timezoneMultipicklist = getFieldValue(
            this.lead.data,
            TIMEZONES_FIELD
        );
        return timezoneMultipicklist && timezoneMultipicklist.split
            ? timezoneMultipicklist.split(";")
            : [];
    }
}
