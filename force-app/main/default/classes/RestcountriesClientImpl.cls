public with sharing class RestcountriesClientImpl implements IRestcountriesClient {
    public RestcountriesCountryDTO getAllCountries() {
        Http h = new Http();

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Restcountries/rest/v2/all');
        req.setMethod('GET');

        // Send the request, and return a response
        HttpResponse res = h.send(req);
        res.getBody();
        return null;
    }
}
