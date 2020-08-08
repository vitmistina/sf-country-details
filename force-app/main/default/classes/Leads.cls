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

    public override void onAfterInsert() {
        fflib_ISObjectUnitOfWork uow = Application.unitOfWork.newInstance();
        fillCountryDetailLookup((List<Lead>) Records, uow);
        uow.commitWork();
    }

    public void onAfterUpdate() {
        fflib_ISObjectUnitOfWork uow = Application.unitOfWork.newInstance();
        List<Lead> changedRecords = (List<Lead>) getChangedRecords(
            new Set<SObjectField>{ Lead.Country }
        );
        fillCountryDetailLookup(changedRecords, uow);
        uow.commitWork();
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

    private void fillCountryDetailLookup(
        List<Lead> selectedRecords,
        fflib_ISObjectUnitOfWork uow
    ) {
        Set<String> queriedValues = getQueriedValues();
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
                uow.registerDirty(record);
            }
        }
    }

    @TestVisible
    private Set<String> getQueriedValues() {
        Set<String> queriedValues = new Set<String>();
        for (Lead record : (List<Lead>) Records) {
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
