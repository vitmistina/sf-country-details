@IsTest
private class RestcountriesSchedulable_Test {
    @IsTest
    private static void executeTest() {
        String cronExpression = '0 0 0 ? * * *';

        fflib_ApexMocks mocks = new fflib_ApexMocks();

        IRestcountriesService serviceMock = (IRestcountriesService) mocks.mock(
            IRestcountriesService.class
        );

        Application.service.setMock(IRestcountriesService.class, serviceMock);

        Test.startTest();
        String jobId = System.schedule(
            'testRestcountriesSchedulable',
            cronExpression,
            new RestcountriesSchedulable()
        );

        CronTrigger ct = [
            SELECT Id, CronExpression, TimesTriggered, NextFireTime
            FROM CronTrigger
            WHERE id = :jobId
        ];

        System.assertEquals(cronExpression, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);

        ((IRestcountriesService) mocks.verify(serviceMock, 0))
            .updateCountryDetails();
        Test.stopTest();

        ((IRestcountriesService) mocks.verify(serviceMock, 1))
            .updateCountryDetails();
    }
}
