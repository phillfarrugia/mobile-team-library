<a href="http://i.imgur.com/dNIROyC.png"><img src="http://i.imgur.com/dNIROyC.png" width="180"/></a>

# prolific-library
A simple iOS app to track who has which book from the prolific library.

## Architecture

This application has been seperated out into two key Application Targets - Prolific Library Core (Core Framework) and Prolific Library (iOS Target). This allows for a clear seperation of concerns between core business-related logic and target or platform specific logic.

![](http://i.imgur.com/h7Bzwbe.png)

### Core Framework

ProlificLibraryCore consists of the following types of classes:

- Models
- View Models
- Controllers
- Network Managers
- Utilities

This target has been embedded in the Xcode Project as a Cocoa Touch Dynamic Framework. It seperates out any of the core logic that exist independently to User Interfaces or platform specific objects.

By seperating these files out into a seperate framework, it allows mobility and easability to changing underlying systems of the application. It allows the developer, or business the ability to embed the framework in multiple targets in the future such as a watchOS, tvOS, macOS application if needed.

Ideally these files should have concrete unit test coverage as they encompass the core logic of the application and developers have the most to gain by ensuring they perform as intended.

### iOS Target

This target is a typical iOS application target consisting of the following types of classes:

- Views
- View Controllers
- Table View Cells
- Collection View Cells
- Storyboards
- Assets
- Plists
- Supporting Files

These files are specific to the iOS platform currently being built for. Unit testing of these files should have a clear seperation from the Core framework, as these files are heavily coupled with Apple's UIKit framework and other platform specific frameworks.

Unit tests have not currently been provided for these files.

## Third Party Dependencies

### Alamofire

https://github.com/Alamofire/Alamofire

Network Requests made throughout this app rely on the use of the Alamofire framework. Alamofire provides a lot of out-of-the box functionality including Caching, Result Validation, Authentication and Parameter Encoding that are useful for this project.

### AlamofireImage

https://github.com/Alamofire/AlamofireImage

This application heavily relies on performing asynchronous network-based requests for images. AlamofireImage couples very well with the use of Alamofire to provide powerful and convenient caching of Images that heavily improve the performance of loading UICollectionViewCells and UITableViewCells with asynchronous images.

### Gloss

https://github.com/hkellaway/Gloss

Gloss makes decoding JSON into native Swift objects clean, easy and simple.

Why not decode JSON without Gloss in Swift?

It's definitely possible to decode JSON in Swift without a third party tool, although Gloss is an existing, well-tested and capable tool that allows the developer to be more productive in building this application in a short amount of time.

### UIImageColors

https://github.com/jathu/UIImageColors

Calculates the primary, secondary and detail colours from a UIImage asynchronously. Performing this calculating asynchronously is a difficult task and this tool is a well-tested solution that enables me to be more productive in building this application in a short amount of time.

### Quick and Nimble

https://github.com/Quick/Quick
<br>https://github.com/Quick/Nimble

Quick and Nimble are the cornerstone tools for implementing Behavioural Driven Development (BDD) unit tests in Swift.

## Unit Tests

Unit tests have not been fully implemented for the project due to the time constraints of this project. Given more time tests would need to be implemented for the NetworkManager (a stubbing or mocking solution for network requests would need to be determined).

Tests currently exist for:

AddBookValidatorSpec
DateFormatter+BookSpec

## Collection View and Table View

In order to showcase my abilities with using both UICollectionView and UITableView I've implemented both throughout this application. 

### Asynchronous Images

These implementations rely heavily on loading images asyncronoushly from the network.

My solution to this problem is as follows:

1. View Controller dequeues a reusable Cell
2. View Controller checks if cell's viewModel has an image already
3. If image exists, image is set on the cell by the View Controller and cell is returned
4. If no image, View Controller makes an asynchronous request using the ImageHandler
5. Asynchronous request callsback to the View Controller
6. ImageHandler caches the image in memory using AlamofireImage
7. View Controller saves the image in the cell's viewModel
6. View Controller checks if cell still exists at the same indexPath
7. If cell doesn't exist, View Controller returns, because cell is off screen
8. If cell does exist, View Controller sets image on cell and cell is returned

See the following for actual implementation:

BookListViewController+TableView.swift (tableView:cellForRowAtIndexPath:)
BookListViewController+CollectionView.swift (collectionView:cellForItemAtIndexPath:)

Potential issues:

#### Cell is offscreen

If a cell scrolls offscreen before an asynchronous image request callsback, the image is cached in memory and saved to the viewModel for use when a cell is dequeued again for the same indexPath. In this case, no new network request is needed.

#### Cell is reused for another indexPath

If a cell is reused for a different indexPath, the image is coupled with the viewModel instead of the cell. Therefore no mismatching issues can occur.


## Problems I Encountered

### Book Details - Share, Edit, Delete

#### Problem

During development of the `BookDetailViewController` I was faced with the task of implementing buttons to 'Share', 'Edit' and 'Delete' a specific book. Along with the `UINavigationBar` and the `UITabBar`, I found it difficult to determine the most User Friendly way to present these options to the user.

Initially I implemented the following solution, which placed the native iOS Share button in the Navigation Bar, but this left me no room to place an Edit or Delete button.

#### Screenshot
<a href="http://i.imgur.com/8iQaQ94.png"><img src="http://i.imgur.com/8iQaQ94.png" width="400" /></a>

#### Solution

In order to find a solution I researched into the existing Navigation patterns for popular iOS apps on the App Store, such as Facebook, Instagram, Snapchat, Twitter among others. Eventually I settled on an approach that I've used in previous projects I've worked on of displaying several actions in an animated custom Alert View modal overlay. 

I don't feel as comfortable as I would like with hiding these 3 actions behinds a 'more' button (three dots), like a hamburger-menu style button. But due to the time constraints of the building this project, I had to settle on something clean and this was the best solution I settled on.

#### Screenshot

<a href="http://i.imgur.com/WEpoMyz.png"><img src="http://i.imgur.com/WEpoMyz.png" width="400" /></a>

### Heroku Server Downtime

#### Problem

While developing this project, I was provided with a Heroku API for fetching, adding, removing, updating and deleting books from the network. I had no control over this server, as is a usual occurance on many software projects. Halfway through my development the API experienced issues and went down. With no control over the server, I was faced with building my app without the server.

#### Solution

I've experienced this exact scenario many times on software projects, so although this was an issue it did not take my by surprise. In order to workaround the server issues, I was able to use tools such as Charles Proxy (https://www.charlesproxy.com/), and ServeUp (http://www.blackdogfoundry.com/blog/introducing-serveup/) to implement a mock local Web Server that returned pre-defined JSON responses for specific network requests. This enabled me to mock the server independently of my application code, and ensure that everything would be working given a working Heroku API again.

Before completing this project, I was able to request a fix on the server in order to run final integration tests to ensure no issues, and to fix any minor bugs before finalising.

## Feedback

This project was a great approach to showcasing my pragmatic iOS development knowledge and experience. The instructions left enough room for interpretation to craft a unique mobile app with the data provided.

Despite the Book data provided being simple and brief, I found it enabled me to open up to new ways of presenting that data to the user. One such example was the Book categories. Instead of taking the comma seperating string of categories from the server and simply presenting them as a boring UILabel to the user, I enjoyed crafting TagViews that placed the tags in colourful rounded bubbles, that flowed onto multilines. I even found a way to add features to the app that let the user search and catalogue through books using these tags more powerfully.
