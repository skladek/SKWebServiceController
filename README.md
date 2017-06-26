# SKWebServiceController

![Travis Status](https://travis-ci.org/skladek/SKWebServiceController.svg?branch=master)
![Codecov Status](https://img.shields.io/codecov/c/github/skladek/SKWebServiceController.svg)
![Pod Version](https://img.shields.io/cocoapods/v/SKWebServiceController.svg)
![Platform Status](https://img.shields.io/cocoapods/p/SKWebServiceController.svg)
![License Status](https://img.shields.io/github/license/skladek/SKWebServiceController.svg)

SKWebServiceController provides a barebones networking layer to interact with services returning JSON or images. Check out the SampleProject in the workspace to see some usage examples.

- [Installation](#installation)
- [Initialization](#initialization)
- [WebServiceController](#webservicecontroller)
- [RequestConfiguration](#requestconfiguration)

---

## Installation

### Cocoapods

Instalation is supported through Cocoapods. Add the following to your pod file for the target where you would like to use SKWebServiceController:

```
pod 'SKWebServiceController'
```

---

## Initialization

Initialization requires only a base URL. All requests, except for getImages, will append the supplied endpoint information onto this base URL. The most common implementation is likely to subclass this controller and provide the baseURL. If you have multiple baseURLs, they will each require a separate WebServiceController object. The most common implementation would include a singleton to access the WebServiceController object.


```
import SKWebServiceController

class MyWebServiceController: WebServiceController {
	static let shared = MyWebServiceController()

    init() {
        super.init(baseURL: "https://jsonplaceholder.typicode.com/")
    }
}
```

Optionally, a dictionary of default parameters can be passed in. These values are appended to every URL as query parameters after the endpoint.

---

## WebServiceController

The WebServiceController subclass will be used to perform requests. There are methods exposed that facilitate these requests. Each of these requests takes an endpoint and a `RequestConfiguration` object to handle header fields and parameters. Additionally, each method returns a URLSessionDataTask object to allow the request to be cancelled midflight.

### JSON Methods

These methods are used to interact with endpoints that send and receive JSON. All requests have a `JSONCompletion` object that is executed when the request is complete.

#### Delete

Performs a delete request on the provided endpoint.

#### Get

Performs a get request on the provided endpoint.

#### Post

Performs a post request on the provided endpoint. This method has an optional json parameter. This object must be a valid JSON object. This will be converted to data and sent with the request.

#### Put

Performs a put request on the provided endpoint. This method has an optional json parameter. This object must be a valid JSON object. This will be converted to data and sent with the request.

### Image Methods

There is currently a single method for getting an image from a URL. This method has an `ImageCompletion` object that is executed when the request is complete.

#### Get Image

Unlike the other methods that take an endpoint string and build the URL dynamically, this method takes the full URL of the remote image. When the method is complete, the image or an error will be returned through the `ImageCompletion` object.

---

## RequestConfiguration

The `RequestConfiguration` object allows headers and parameters to be set on a per request basis. IIf the same header appears in the RequestConfiguration and the URLSessionConfiguration object, the RequestConfiguration header takes precedence.