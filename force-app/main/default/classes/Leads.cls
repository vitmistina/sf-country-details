public with sharing class Leads extends fflib_SObjectDomain implements ILeads {
    public Leads(List<Lead> sObjectList) {
        super(sObjectList);
    }

    public static ILeads newInstance(List<Lead> recordList) {
        return (ILeads) Application.Domain.newInstance(recordList);
    }

    public override void onValidate() {
        //TODO behaviour select
        ILeadOwnerCheckBehaviour leadOwnerCheck = LeadOwnerCheckImplLenient.newInstance(
            this
        );
        leadOwnerCheck.checkLeads((List<Lead>) Records);
    }

    public override void onBeforeInsert() {
        fillCountryDetailLookup((List<Lead>) Records);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        List<Lead> changedRecords = (List<Lead>) getChangedRecords(
            new Set<SObjectField>{ Lead.Country }
        );
        fillCountryDetailLookup(changedRecords);
    }

    public override void onValidate(Map<Id, SObject> existingRecords) {
        //TODO behaviour select
        ILeadOwnerCheckBehaviour leadOwnerCheck = LeadOwnerCheckImplLenient.newInstance(
            this
        );
        List<Lead> changedLeads = getChangedRecords(
            new Set<SObjectField>{ Lead.OwnerId }
        );
        leadOwnerCheck.checkLeads(changedLeads);
    }

    private void fillCountryDetailLookup(List<Lead> selectedRecords) {
        Set<String> queriedValues = getQueriedValues(selectedRecords);
        Map<String, CountryDetail__c> mapByQueriedValue = CountryDetailsSelector.newInstance()
            .getByCountryInLeads(queriedValues);
        for (Lead record : selectedRecords) {
            CountryDetail__c countryDetail = mapByQueriedValue.get(
                record.Country
            );
            Id foundLookupValue = countryDetail != null
                ? countryDetail.Id
                : null;
            if (foundLookupValue != record.CountryDetail__c) {
                record.CountryDetail__c = foundLookupValue;
            }
        }
    }

    @TestVisible
    private Set<String> getQueriedValues(List<Lead> selectedRecords) {
        Set<String> queriedValues = new Set<String>();
        for (Lead record : selectedRecords) {
            if (String.isNotBlank(record.Country)) {
                queriedValues.add(record.Country);
            }
        }
        return queriedValues;
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Leads(sObjectList);
        }
    }
}
