import SKWebServiceController

class MyWebServiceController: WebServiceController {
    init() {
        super.init(baseURL: "https://jsonplaceholder.typicode.com/")
        self.useLocalFiles = true
    }
}
