# microCMS iOS SDK

It helps you to use microCMS from iOS(Swift) applications.  
Check [the official documentation](https://document.microcms.io/tutorial/ios/ios-top) for more information

## Getting Started

### Installation

Use swift package manager.


## Hot to use

### Import

```swift
import MicrocmsSDK
```

### Create client object

```swift
let client = MicrocmsClient(
    serviceDomain: "YOUR_DOMAIN", // YOUR_DOMAIN is the XXXX part of XXXX.microcms.io
    apiKey: "YOUR_API_KEY"
    )
```

### Get content list

```swift
client.get(
    endpoint: "API_ENDPOINT") { result in
    print(result)
}
```

You can get decoded response like this:

```swift
struct Response: Decodable {
    let contents: [MyContent]
    let totalCount: Int
    let offset: Int
    let limit: Int
}

client.get(
    endpoint: "API_ENDPOINT") { (result: Result<Response, Error>) in
    print(result)
}
```

### Get content list with parameters

```swift
let params: [MicrocmsParameter] = [
    .limit(2),
    .filters("createdAt[greater_than]2021")
]
client.get(
    endpoint: "API_ENDPOINT",
    params: params) { result in
    print(result)
}
```

### Get single content

```swift
let params: [MicrocmsParameter] = [
    .fields(["id"]),
]
client.get(
    endpoint: "API_ENDPOINT",
    contentId: "CONTENT_ID",
    params: params) { result in
    print(result)
}
```

### Get object form content

```swift
client.get(
    endpoint: "API_ENDPOINT") { result in
    print(result)
}
```

### Create content

```swift
client.create(
    endpoint: "API_ENDPOINT",
    params: ["text": "Hello iOS SDK!"]) { result in
    print(result)
}
```

### Create content with specified ID

```swift
client.create(
    endpoint: "API_ENDPOINT",
    contentId: "CONTENT_ID",
    params: ["text": "Hello iOS SDK!"]) { result in
    print(result)
}
```

### Create draft content

```swift
client.create(
    endpoint: "API_ENDPOINT",
    params: ["text": "Hello iOS SDK!"],
    isDraft: true) { result in
    print(result)
}
```

### Update content

```swift
client.update(
    endpoint: "API_ENDPOINT",
    contentId: "CONTENT_ID",
    params: ["text": "Hello iOS SDK update method!"]) { result in
    print(result)
}
``` 

### Update object form content

```swift
client.update(
    endpoint: "API_ENDPOINT",
    params: ["text": "Hello iOS SDK update method!"]) { result in
    print(result)
}
```

### Delete content

```swift
client.delete(
    endpoint: "API_ENDPOINT",
    contentId: "CONTENT_ID") { result in
    print(result)
}
```
