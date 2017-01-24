# TODO

Note: Initially only the GET requests which are accessible from the Public scope will be implemented. Later the ability to use other scopes will be supported. 

1. ~~Add test automation~~
   1. ~~Make requests testable~~
   1. ~~Test calls to API endpoints~~
   1. ~~Increase code coverage~~
1. Add support to use as a dependency
   1. ~~CocoaPods~~
   1. ~~Carthage~~  
   1. SwiftPM (Swift Package Manager)
1. Implement full API
   1. ~~/v3/oauth~~
   1. ~~Implement secure access data storage~~
   1. ~~/v3/athlete~~
   1. ~~/v3/athletes/:id~~
   1. ~~/v3/athlete/activities/~~
   1. ~~/v3/activities/:id~~
   1. ~~/v3/activities/following~~
   1. ~~/v3/clubs/:id~~
   1. ~~/v3/athlete/clubs~~
   1. ~~/v3/segments/:id~~
   1. ~~/v3/segments/:id/leaderboard~~
   1. ~~/v3/segments/starred~~
   1. ~~/v3/segments/:id/all_efforts~~
   1. /v3/uploads
   1. ~~Add support for paging for all paged resources~~
   1. ~~Implement error handling by checking error on JSON response~~
   1. ~~Support date string convertion to date object (ISO 8601 formatted)~~
   1. Review for compliance with models and Strava docs for all properties and types
   1. Define policy for types such as polylines, dates and non-optional properties
1. Implement full demo app (live integration testing)
   1. ~~/v3/oauth~~
   1. ~~/v3/athlete~~
   1. ~~/v3/athletes/:id~~
   1. ~~/v3/athlete/activities/~~
   1. ~~/v3/activities/:id~~
   1. ~~/v3/activities/following~~
   1. ~~/v3/clubs/:id~~
   1. ~~/v3/athlete/clubs~~
   1. ~~/v3/segments/:id~~
   1. ~~/v3/segments/:id/leaderboard~~
   1. ~~/v3/segments/starred~~
   1. ~~/v3/segments/:id/all_efforts~~
   1. ~~/v3/athlete/zones~~
   1. /v3/uploads
1. Review performance
   1. ~~Implement rate limiting support~~
   1. Profile API calls for various calls
   1. Plan and implement retry logic for rating limiting
1. Plan work to store data to disk
   1. Generic data store protocol
   1. JSON implementation
   1. sqlite implementation
   1. Realm implementation

## Notes

[Rating Limiting](http://strava.github.io/api/#rate-limiting
) has reasonable settings for moderate use. It will be necessary to detect when a 403 Forbidden response is returned with the JSON payload indicating that the rate limit was exceeded. When that happens the current failed request can detect the state, wait a moment and try the request again. The delay could be 1 second initially and increase with each failed request. A maximum retry count of 5 or 10 may be reasonable to provide the best possible user experience.  
