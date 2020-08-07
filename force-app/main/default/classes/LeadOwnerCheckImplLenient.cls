public with sharing class LeadOwnerCheckImplLenient implements ILeadOwnerCheckBehaviour {
  private Leads domain;

  public static ILeadOwnerCheckBehaviour newInstance(Leads domain) {
    return ((LeadOwnerCheckImplLenient) Application.service.newInstance(
        LeadOwnerCheckImplLenient.class
      ))
      .withDomain(domain);
  }

  public ILeadOwnerCheckBehaviour withDomain(Leads domain) {
    this.domain = domain;
    return this;
  }

  public void checkLeads(List<Lead> leadRecords) {
    for (Lead record : leadRecords) {
      if (record.LeadSource == null) {
        record.OwnerId.addError(
          domain.error('You must provide Lead Source', record, Lead.OwnerId)
        );
      }
    }
  }
}
