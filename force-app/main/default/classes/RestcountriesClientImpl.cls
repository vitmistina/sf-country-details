public with sharing class RestcountriesClientImpl implements IRestcountriesClient {
    public static IRestcountriesClient newInstance() {
        return (IRestcountriesClient) Application.service.newInstance(
            IRestcountriesClient.class
        );
    }

    public RestcountriesCountryDTO getAllCountries() {
        RestcountriesCountryDTO result = new RestcountriesCountryDTO();
        Http h = new Http();

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Restcountries/rest/v2/all');
        req.setMethod('GET');

        // Send the request, and return a response
        HttpResponse res = h.send(req);
        result.hash = Crypto.generateDigest('MD5', res.getBodyAsBlob());
        result.countries = (List<RestcountriesCountryDTO.Country>) JSON.deserialize(
            res.getBody(),
            List<RestcountriesCountryDTO.Country>.class
        );

        return result;
    }
}
