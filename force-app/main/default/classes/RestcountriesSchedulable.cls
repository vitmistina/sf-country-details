global with sharing class RestcountriesSchedulable implements Schedulable {
    global void execute(SchedulableContext SC) {
        RestcountriesServiceImpl.newInstance().updateCountryDetails();
    }
}
