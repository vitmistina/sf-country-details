public with sharing class Leads extends fflib_SObjectDomain implements ILeads {
    public Leads(List<Lead> sObjectList) {
        super(sObjectList);
    }

    public override void onValidate() {
        ILeadOwnerCheckBehaviour leadOwnerCheck = LeadOwnerCheckImplLenient.newInstance(
            this
        );
        leadOwnerCheck.checkLeads((List<Lead>) Records);
    }

    public override void onValidate(Map<Id, SObject> existingRecords) {
        ILeadOwnerCheckBehaviour leadOwnerCheck = LeadOwnerCheckImplLenient.newInstance(
            this
        );
        List<Lead> changedLeads = getChangedRecords(
            new Set<SObjectField>{ Lead.OwnerId }
        );
        leadOwnerCheck.checkLeads(changedLeads);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Leads(sObjectList);
        }
    }
}
