RestcountriesServiceImpl.newInstance().updateCountryDetails();

String cronExpression = '0 0 0 ? * * *';
System.schedule(
    'testRestcountriesSchedulable',
    cronExpression,
    new RestcountriesSchedulable()
);
