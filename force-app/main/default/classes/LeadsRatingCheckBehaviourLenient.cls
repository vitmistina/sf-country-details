public with sharing class LeadsRatingCheckBehaviourLenient implements ISObjectValidateBehaviour {
    private Leads domain;
    private static final Decimal THRESHOLD_REVENUE = 1000000.00;

    public static ISObjectValidateBehaviour newInstance(Leads domain) {
        return ((LeadsRatingCheckBehaviourLenient) Application.service.newInstance(
                LeadsRatingCheckBehaviourLenient.class
            ))
            .withDomain(domain);
    }

    public ISObjectValidateBehaviour withDomain(Leads domain) {
        this.domain = domain;
        return this;
    }

    public void validate(List<SObject> records) {
        for (Lead record : (List<Lead>) records) {
            if (
                (record.AnnualRevenue == null ||
                record.AnnualRevenue <= THRESHOLD_REVENUE) &&
                record.Rating == 'Hot'
            ) {
                record.OwnerId.addError(
                    domain.error(
                        'Hot leads must have revenue over ' +
                        String.valueOf(THRESHOLD_REVENUE),
                        record,
                        Lead.OwnerId
                    )
                );
            }
        }
    }
}
