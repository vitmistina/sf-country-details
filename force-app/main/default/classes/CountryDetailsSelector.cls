public with sharing class CountryDetailsSelector extends fflib_SObjectSelector implements ICountryDetailsSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            CountryDetail__c.Id,
            CountryDetail__c.Name,
            CountryDetail__c.IsoCode2__c,
            CountryDetail__c.IsoCode3__c,
            CountryDetail__c.Capital__c,
            CountryDetail__c.Region__c,
            CountryDetail__c.Subregion__c,
            CountryDetail__c.RegionalBlocs__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return CountryDetail__c.sObjectType;
    }

    public static ICountryDetailsSelector newInstance() {
        return (ICountryDetailsSelector) Application.selector.newInstance(
            CountryDetail__c.sObjectType
        );
    }

    public List<CountryDetail__c> getAllCountryDetails() {
        return (List<CountryDetail__c>) Database.query(
            newQueryFactory().toSOQL()
        );
    }

    public Map<String, CountryDetail__c> getByCountryInLeads(
        Set<String> queriedValues
    ) {
        String condition =
            'IsoCode2__c IN :queriedValues OR ' +
            'IsoCode3__c IN :queriedValues OR ' +
            'Name IN :queriedValues';
        List<CountryDetail__c> countryDetails = (List<CountryDetail__c>) Database.query(
            newQueryFactory().setCondition(condition).toSOQL()
        );
        return mapCountriesToQueriedValues(queriedValues, countryDetails);
    }

    private Map<String, CountryDetail__c> mapCountriesToQueriedValues(
        Set<String> queriedValues,
        List<CountryDetail__c> countryDetails
    ) {
        Map<String, CountryDetail__c> result = new Map<String, CountryDetail__c>();

        for (CountryDetail__c country : countryDetails) {
            //TODO can be done less lazy
            result.put(country.IsoCode2__c, country);
            result.put(country.IsoCode3__c, country);
            result.put(country.Name, country);
        }

        return result;
    }
}
