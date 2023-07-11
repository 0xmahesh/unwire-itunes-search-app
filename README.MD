## iTunes Search App

![alt text](https://i.ibb.co/LSTpthw/i-Tunes-Search.gif)

### Checking out the code
```
git clone https://github.com/0xmahesh/unwire-itunes-search-app.git
```

switch to <b>main</b> branch.

### Prerequisites
- Xcode 14.2 or later

### Functionality
- Users can perform keyword search using the search bar implemented in the home screen.
- User input is subjected to a debounce to avoid unnecessary API requests being made.
- If there is a match, the response is displayed in a list under the search bar.
- Each search result cell displays track name, artist’s name, album art, the year in which the album was released along with the album name. 
- Pagination is supported, with 50 results per page. Infinite scroll is implemented for more search results.
- Clearing the search text will clear the results.
- If no results are returned from the API, the screen will display a "No results. Please try another keyword" banner.
- If there were any errors encountered while fetching results, the app will present a standard error alert.
- An in-memory cache is implemented to cache image downloads.
- Selecting a search result will present a detail screen with album artwork and a UI mimicking Apple Music subscription screen.
- Localization support is added with keys provided for English only.
- An activity indicator is shown during search queries or prefetching data requests.

### Architecture
- The application adopts Clean Architecture with 4 major components: Presentation layer, Data layer, Domain layer, and Infrastructure layer.
- Global level implementations such as Dependency Injection and Flow Coordinators are grouped under a common Application layer.
- Presentation layer is implemented using MVVM architecture with data binding handled using Swift's Combine framework.
- Dependency Injection is handled using Compositional Root pattern with constructor injection.
- Navigation is handled using the Coordinator pattern.

### Networking
- Networking layer is implemented using URLSession with Swift's structured concurrency (async/await).
- GET requests are supported, while POST support for Codable request objects is not implemented.
- Custom errors are propagated to data sources in case of an error.
- An enum-based APIEndpoint pattern is used for granular control of creating a URLRequest.

### UI
- The Search screen is implemented using UIKit and programmatic AutoLayout.
- Detail screen is implemented using SwiftUI and presented by embedding inside a UIHostingController.

### Unit Testing
- Unit tests cover basic cases in ViewModels, Network Service, Data Source, and Repository implementations.
