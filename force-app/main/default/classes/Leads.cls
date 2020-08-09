public with sharing class Leads extends fflib_SObjectDomain implements ILeads {
    public Leads(List<Lead> sObjectList) {
        super(sObjectList);
    }

    public static ILeads newInstance(List<Lead> recordList) {
        return (ILeads) Application.Domain.newInstance(recordList);
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

    public override void onValidate() {
        ISObjectValidateBehaviour ratingBehaviour = selectRatingBehaviour();
        ratingBehaviour.validate((List<Lead>) Records);
    }

    public override void onValidate(Map<Id, SObject> existingRecords) {
        ISObjectValidateBehaviour ratingBehaviour = selectRatingBehaviour();
        List<Lead> changedLeads = getChangedRecords(
            new Set<SObjectField>{ Lead.Rating }
        );
        ratingBehaviour.validate(changedLeads);
    }

    private ISObjectValidateBehaviour selectRatingBehaviour() {
        ISObjectValidateBehaviour behaviour;

        switch on getCurrentUserProfileName() {
            when 'System Administrator', 'Contract Manager' {
                behaviour = LeadsRatingCheckBehaviourLenient.newInstance(this);
            }
            when else {
                behaviour = LeadsRatingCheckBehaviourStrict.newInstance(this);
            }
        }
        return behaviour;
    }

    private String getCurrentUserProfileName() {
        Id profileId = userinfo.getProfileId();
        return [SELECT Id, Name FROM Profile WHERE Id = :profileId].Name;
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
