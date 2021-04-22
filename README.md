# microCMS iOS SDK

It helps you to use microCMS from iOS(Swift) applications.  
Check [the official documentation](https://document.microcms.io/tutorial/ios) for more information

## Getting Started

### Installation

Use swift package manager.


### Hot to use

First, create a client.

```swift
let client = MicrocmsClient(
    serviceDomain: "YOUR_DOMAIN",
    apiKey: "YOUR_API_KEY",
    globalDraftKey: "YOUR_GLOBAL_DRAFT_KEY" // if needed
    )
```

Next, you can call some api like below.  
Client will return `result`(`Result<[String: Any]>`) and you can use it.
```swift
client.get(
    endpoint: "API_ENDPOINT",
    params: ["limit": "2", "filters" to "createdAt[greater_than]2021") { result in
    switch result {
    case .success(let object):
        print("[SUCCESS]: \(object)")
    case .failure(let error):
        print("[ERROR]: \(error)")
    }
}

client.get(
    endpoint: "API_ENDPOINT",
    contentId: "CONTENT_ID",
    params: ["fields": "id"]) { result in
    switch result {
    case .success(let object):
        print("[SUCCESS]: \(object)")
    case .failure(let error):
        print("[ERROR]: \(error)")
    }
}
```
