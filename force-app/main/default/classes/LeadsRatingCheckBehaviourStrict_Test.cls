@IsTest
private class LeadsRatingCheckBehaviourStrict_Test {
    @IsTest
    private static void positiveValidation() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        Leads mockDomain = (Leads) mocks.mock(Leads.class);

        mocks.startStubbing();
        mocks.when(
                mockDomain.error(
                    fflib_Match.anyString(),
                    fflib_Match.anySObject(),
                    fflib_Match.anySObjectField()
                )
            )
            .thenReturn('error');
        mocks.stopStubbing();

        ISObjectValidateBehaviour validator = LeadsRatingCheckBehaviourStrict.newInstance(
            mockDomain
        );

        List<Lead> records = new List<Lead>{
            new Lead(Rating = 'Hot', AnnualRevenue = 8999970)
        };

        validator.validate(records);

        ((Leads) mocks.verify(mockDomain, 0))
            .error(
                fflib_Match.anyString(),
                fflib_Match.anySObject(),
                fflib_Match.anySObjectField()
            );
    }

    @IsTest
    private static void negativeValidationAmount() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        Leads mockDomain = (Leads) mocks.mock(Leads.class);

        mocks.startStubbing();
        mocks.when(
                mockDomain.error(
                    fflib_Match.anyString(),
                    fflib_Match.anySObject(),
                    fflib_Match.anySObjectField()
                )
            )
            .thenReturn('error');
        mocks.stopStubbing();

        ISObjectValidateBehaviour validator = LeadsRatingCheckBehaviourStrict.newInstance(
            mockDomain
        );

        List<Lead> records = new List<Lead>{
            new Lead(Rating = 'Hot', AnnualRevenue = 900000.00)
        };

        validator.validate(records);

        ((Leads) mocks.verify(mockDomain, 1))
            .error(
                fflib_Match.stringStartsWith(
                    LeadsRatingCheckBehaviourStrict.REVENUE_UNDER_MESSAGE_START
                ),
                fflib_Match.anySObject(),
                fflib_Match.anySObjectField()
            );
    }

    @IsTest
    private static void negativeValidationDivisibility() {
        fflib_ApexMocks mocks = new fflib_ApexMocks();

        Leads mockDomain = (Leads) mocks.mock(Leads.class);

        mocks.startStubbing();
        mocks.when(
                mockDomain.error(
                    fflib_Match.anyString(),
                    fflib_Match.anySObject(),
                    fflib_Match.anySObjectField()
                )
            )
            .thenReturn('error');
        mocks.stopStubbing();

        ISObjectValidateBehaviour validator = LeadsRatingCheckBehaviourStrict.newInstance(
            mockDomain
        );

        List<Lead> records = new List<Lead>{
            new Lead(Rating = 'Hot', AnnualRevenue = 9000000.00)
        };

        validator.validate(records);

        ((Leads) mocks.verify(mockDomain, 1))
            .error(
                fflib_Match.stringStartsWith(
                    LeadsRatingCheckBehaviourStrict.REVENUE_NON_DIVISIBLE_MESSAGE_START
                ),
                fflib_Match.anySObject(),
                fflib_Match.anySObjectField()
            );
    }
}
