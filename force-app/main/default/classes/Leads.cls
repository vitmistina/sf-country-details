public with sharing class Leads extends fflib_SObjectDomain implements ILeads {
  public Leads(List<Lead> sObjectList) {
    super(sObjectList);
  }

  public override void onValidate() {
    for (Lead leadRecord : (List<Lead>) Records) {
      ownerCheckBehaviour(leadRecord);
    }
  }

  public override void onValidate(Map<Id, SObject> existingRecords) {
    List<Lead> changedLeads = getChangedRecords(
      new Set<SObjectField>{ Lead.OwnerId }
    );
    for (Lead leadRecord : changedLeads) {
      ownerCheckBehaviour(leadRecord);
    }
  }

  private void ownerCheckBehaviour(Lead leadRecord) {
    if (leadRecord.LeadSource == null) {
      leadRecord.OwnerId.addError(
        error('You must provide Lead Source', leadRecord, Lead.OwnerId)
      );
    }
  }

  public class Constructor implements fflib_SObjectDomain.IConstructable {
    public fflib_SObjectDomain construct(List<SObject> sObjectList) {
      return new Leads(sObjectList);
    }
  }
}
