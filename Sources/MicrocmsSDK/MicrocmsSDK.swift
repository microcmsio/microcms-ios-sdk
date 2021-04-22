import Foundation

public struct MicrocmsClient {
    
    private let baseDomain = "microcms.io"
    private let apiVersion = "v1"
    
    private let serviceDomain: String
    private let apiKey: String
    private let globalDrafyKey: String?
    
    public init(serviceDomain: String,
         apiKey: String,
         globalDraftKey: String? = nil) {
        self.serviceDomain = serviceDomain
        self.apiKey = apiKey
        self.globalDrafyKey = globalDraftKey
    }
    
    var baseUrl: String {
        return "https://\(serviceDomain).\(baseDomain)/api/\(apiVersion)"
    }
    
    /// make request for microCMS .
    ///
    /// - Parameters:
    ///   - endpoint: endpoint of contents.
    ///   - contentId: contentId. It's needed if you want to fetch a element of list.
    ///   - params: some parameters for filtering or sorting results.
    /// - Returns: URLRequest made with given parameters.
    public func makeRequest(
        endpoint: String,
        contentId: String?,
        params: [String: String]?) -> URLRequest? {
        var urlString = baseUrl + "/" + endpoint
        if let contentId = contentId {
            urlString += "/\(contentId)"
        }
        
        guard let url = URL(string: urlString),
              var components = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false) else {
            print("[ERROR] endpoint or parameter is invalid.")
            return nil
        }
        
        if let params = params {
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        if let globalDraftKey = globalDrafyKey {
            request.setValue(globalDraftKey, forHTTPHeaderField: "X-GLOBAL-DRAFT-KEY")
        }
        
        return request
    }
    
    /// fetch microCMS contents.
    ///
    /// - Parameters:
    ///   - endpoint: endpoint of contents.
    ///   - contentId: contentId. It's needed if you want to fetch a element of list.
    ///   - params: some parameters for filtering or sorting results.
    ///   - completion: handler of api result, `Any` or `Error`.
    /// - Returns: URLSessionTask you requested. Basically, you don't need to use it, but it helps you to manage state or cancel request.
    @discardableResult
    public func get(
        endpoint: String,
        contentId: String? = nil,
        params: [String: String]? = nil,
        completion: @escaping ((Result<Any, Error>) -> Void)) -> URLSessionTask? {
        
        guard let request = makeRequest(
                endpoint: endpoint,
                contentId: contentId,
                params: params) else { return nil }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: [])
                completion(.success(object))
            } catch let error {
                completion(.failure(error))
            }
        }
        task.resume()
        
        return task
    }
}

