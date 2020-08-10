@IsTest
private class LeadsRatingCheckBehaviourLenient_Test {
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

        ISObjectValidateBehaviour validator = LeadsRatingCheckBehaviourLenient.newInstance(
            mockDomain
        );

        List<Lead> records = new List<Lead>{
            new Lead(Rating = 'Hot', AnnualRevenue = 9000000.00)
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
    private static void negativeValidation() {
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

        ISObjectValidateBehaviour validator = LeadsRatingCheckBehaviourLenient.newInstance(
            mockDomain
        );

        List<Lead> records = new List<Lead>{
            new Lead(Rating = 'Hot', AnnualRevenue = 900000.00)
        };

        validator.validate(records);

        ((Leads) mocks.verify(mockDomain, 1))
            .error(
                fflib_Match.anyString(),
                fflib_Match.anySObject(),
                fflib_Match.anySObjectField()
            );
    }
}
