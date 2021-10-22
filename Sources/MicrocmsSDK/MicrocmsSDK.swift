import Foundation

public struct MicrocmsClient {
    
    private let baseDomain = "microcms.io"
    private let apiVersion = "v1"
    
    private let serviceDomain: String
    private let apiKey: String
    
    public init(serviceDomain: String,
         apiKey: String) {
        self.serviceDomain = serviceDomain
        self.apiKey = apiKey
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
        params: [MicrocmsParameter]?) -> URLRequest? {
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
            components.queryItems = params.map { $0.queryItem }
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-MICROCMS-API-KEY")
        
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
        params: [MicrocmsParameter]? = nil,
        completion: @escaping ((Result<Any, Error>) -> Void)) -> URLSessionTask? {
        
        guard let request = makeRequest(
                endpoint: endpoint,
                contentId: contentId,
                params: params) else { return nil }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: [])
                    completion(.success(object))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        
        return task
    }
}

