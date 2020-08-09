public with sharing class LeadsRatingCheckBehaviourStrict implements ISObjectValidateBehaviour {
    private Leads domain;

    public static ISObjectValidateBehaviour newInstance(Leads domain) {
        return ((LeadsRatingCheckBehaviourStrict) Application.service.newInstance(
                LeadsRatingCheckBehaviourStrict.class
            ))
            .withDomain(domain);
    }

    public ISObjectValidateBehaviour withDomain(Leads domain) {
        this.domain = domain;
        return this;
    }

    public void validate(List<SObject> records) {
        for (Lead record : (List<Lead>) records) {
            if (record.LeadSource == null) {
                record.OwnerId.addError(
                    domain.error(
                        'You must provide Lead Source',
                        record,
                        Lead.OwnerId
                    )
                );
            }
        }
    }
}
