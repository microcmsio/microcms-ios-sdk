# microCMS iOS SDK

> [!WARNING]
> このSDKの現在の保守レベルは `Deprecated` です。
>
> 新規利用は推奨していません。新規開発では代替手段の利用を検討してください。
>
> 詳細は[SDKの保守方針](https://document.microcms.io/manual/limitations#h8725a1f02a)をご覧ください。

iOS（Swift）アプリケーションからmicroCMSを簡単に利用できます。

## はじめに

### インストール

Swift Package Managerを使用してください。

## 使い方

### インポート

```swift
import MicrocmsSDK
```

### クライアントオブジェクトの作成

```swift
let client = MicrocmsClient(
    serviceDomain: "YOUR_DOMAIN", // YOUR_DOMAINはXXXX.microcms.ioのXXXXの部分です
    apiKey: "YOUR_API_KEY"
    )
```

### コンテンツ一覧の取得

```swift
client.get(
    endpoint: "API_ENDPOINT") { result in
    print(result)
}
```

次のように、デコードされたレスポンスを取得できます。

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

### パラメータを指定したコンテンツ一覧の取得

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

### 単一コンテンツの取得

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

### オブジェクト形式のコンテンツの取得

```swift
client.get(
    endpoint: "API_ENDPOINT") { result in
    print(result)
}
```

### コンテンツの作成

```swift
client.create(
    endpoint: "API_ENDPOINT",
    params: ["text": "Hello iOS SDK!"]) { result in
    print(result)
}
```

### IDを指定したコンテンツの作成

```swift
client.create(
    endpoint: "API_ENDPOINT",
    contentId: "CONTENT_ID",
    params: ["text": "Hello iOS SDK!"]) { result in
    print(result)
}
```

### 下書きコンテンツの作成

```swift
client.create(
    endpoint: "API_ENDPOINT",
    params: ["text": "Hello iOS SDK!"],
    isDraft: true) { result in
    print(result)
}
```

### コンテンツの更新

```swift
client.update(
    endpoint: "API_ENDPOINT",
    contentId: "CONTENT_ID",
    params: ["text": "Hello iOS SDK update method!"]) { result in
    print(result)
}
``` 

### オブジェクト形式のコンテンツの更新

```swift
client.update(
    endpoint: "API_ENDPOINT",
    params: ["text": "Hello iOS SDK update method!"]) { result in
    print(result)
}
```

### コンテンツの削除

```swift
client.delete(
    endpoint: "API_ENDPOINT",
    contentId: "CONTENT_ID") { result in
    print(result)
}
```
