# prolific-library
A simple iOS app to track who has which book from the prolific library.

## Architecture

This application has been seperated out into two key Application Targets - Prolific Library Core (Core Framework) and Prolific Library (iOS Target). This allows for a clear seperation of concerns between core business-related logic and target or platform specific logic.

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

Potential issues:

#### Cell is offscreen

If a cell scrolls offscreen before an asynchronous image request callsback, the image is cached in memory and saved to the viewModel for use when a cell is dequeued again for the same indexPath. In this case, no new network request is needed.

#### Cell is reused for another indexPath

If a cell is reused for a different indexPath, the image is coupled with the viewModel instead of the cell. Therefore no mismatching issues can occur.




