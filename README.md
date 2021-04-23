# microCMS iOS SDK

It helps you to use microCMS from iOS(Swift) applications.  
Check [the official documentation](https://document.microcms.io/tutorial/ios) for more information

## Getting Started

### Installation

Use swift package manager.


### Hot to use

First, import microCMS SDK.

```swift
import MicrocmsSDK
```

Next, create a client.

```swift
let client = MicrocmsClient(
    serviceDomain: "YOUR_DOMAIN",
    apiKey: "YOUR_API_KEY",
    globalDraftKey: "YOUR_GLOBAL_DRAFT_KEY" // if needed
    )
```

And you can call some api like below.  
Client will return `result`(`Result<Any>`) and you can use it.
```swift
let params: [MicrocmsParameter] = [
    .limit(2),
    .filters("createdAt[greater_than]2021")
]
client.get(
    endpoint: "API_ENDPOINT",
    params: params) { result in
    switch result {
    case .success(let object):
        print("[SUCCESS]: \(object)")
    case .failure(let error):
        print("[ERROR]: \(error)")
    }
}
```

```swift
let params: [MicrocmsParameter] = [
    .fields(["id"]),
]
client.get(
    endpoint: "API_ENDPOINT",
    contentId: "CONTENT_ID",
    params: params) { result in
    switch result {
    case .success(let object):
        print("[SUCCESS]: \(object)")
    case .failure(let error):
        print("[ERROR]: \(error)")
    }
}
```
