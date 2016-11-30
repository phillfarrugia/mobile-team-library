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

## Alamofire

https://github.com/Alamofire/Alamofire

Network Requests made throughout this app rely on the use of the Alamofire framework. Alamofire provides a lot of out-of-the box functionality including Caching, Result Validation, Authentication and Parameter Encoding that are useful for this project.

## AlamofireImage

https://github.com/Alamofire/AlamofireImage

This application heavily relies on performing asynchronous network-based requests for images. AlamofireImage couples very well with the use of Alamofire to provide powerful and convenient caching of Images that heavily improve the performance of loading UICollectionViewCells and UITableViewCells with asynchronous images.

## Gloss

https://github.com/hkellaway/Gloss

Gloss makes decoding JSON into native Swift objects clean, easy and simple.

Why not decode JSON without Gloss in Swift?

It's definitely possible to decode JSON in Swift without a third party tool, although Gloss is an existing, well-tested and capable tool that allows the developer to be more productive in building this application in a short amount of time.

## UIImageColors

https://github.com/jathu/UIImageColors

Calculates the primary, secondary and detail colours from a UIImage asynchronously. Performing this calculating asynchronously is a difficult task and this tool is a well-tested solution that enables me to be more productive in building this application in a short amount of time.

## Quick and Nimble

https://github.com/Quick/Quick
<br>https://github.com/Quick/Nimble

Quick and Nimble are the cornerstone tools for implementing Behavioural Driven Development (BDD) unit tests in Swift.


