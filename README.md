# SKWebServiceController

![Travis Status](https://travis-ci.org/skladek/SKWebServiceController.svg?branch=master)
![Codecov Status](https://img.shields.io/codecov/c/github/skladek/SKWebServiceController.svg)
![Pod Version](https://img.shields.io/cocoapods/v/SKWebServiceController.svg)
![Platform Status](https://img.shields.io/cocoapods/p/SKWebServiceController.svg)
![License Status](https://img.shields.io/github/license/skladek/SKWebServiceController.svg)

SKWebServiceController provides a barebones networking layer to interact with services returning JSON or images. Check out the SampleProject in the workspace to see some usage examples.

---

## Installation

### Cocoapods

Instalation is supported through Cocoapods. Add the following to your pod file for the target where you would like to use SKWebServiceController:

```
pod 'SKWebServiceController'
```

---

## Initialization

Initialization requires only a base URL. All requests, except for getImages, will append the supplied endpoint information onto this base URL. The most common implementation is likely to subclass this controller and provide the baseURL. If you have multiple baseURLs, they will each require a separate WebServiceController object. The shared URLSession is used so it is not necessary to make singleton WebServiceController objects.


```
import SKWebServiceController

class MyWebServiceController: WebServiceController {
    init() {
        super.init(baseURL: "https://jsonplaceholder.typicode.com/")
    }
}
```

Optionally, a dictionary of default parameters can be passed in. These values are appended to every URL as query parameters after the endpoint.

---
