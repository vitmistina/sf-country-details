public with sharing class LeadsRatingCheckBehaviourStrict implements ISObjectValidateBehaviour {
    private Leads domain;
    private static final Decimal THRESHOLD_REVENUE = 5000000.00;
    @TestVisible
    private static final String REVENUE_UNDER_MESSAGE_START = 'Hot leads must have revenue over ';
    @TestVisible
    private static final String REVENUE_NON_DIVISIBLE_MESSAGE_START = 'Hot leads must have revenue divisible by number 42. Try inputting ';

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
            if (record.Rating == 'Hot') {
                if (
                    (record.AnnualRevenue == null ||
                    record.AnnualRevenue <= THRESHOLD_REVENUE)
                ) {
                    record.OwnerId.addError(
                        domain.error(
                            REVENUE_UNDER_MESSAGE_START +
                            String.valueOf(THRESHOLD_REVENUE),
                            record,
                            Lead.OwnerId
                        )
                    );
                } else if (Math.mod(record.AnnualRevenue.intValue(), 42) != 0) {
                    record.OwnerId.addError(
                        domain.error(
                            REVENUE_NON_DIVISIBLE_MESSAGE_START +
                            (record.AnnualRevenue -
                            Math.mod(record.AnnualRevenue.intValue(), 42)),
                            record,
                            Lead.OwnerId
                        )
                    );
                }
            }
        }
    }
}
