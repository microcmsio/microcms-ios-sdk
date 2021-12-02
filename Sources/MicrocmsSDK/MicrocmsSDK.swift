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
    
    /// make write request for microCMS .
    ///
    /// - Parameters:
    ///   - method: HTTP method.
    ///   - endpoint: endpoint of contents.
    ///   - contentId: contentId. It's needed if you want to fetch a element of list.
    ///   - params: some parameters for body.
    ///   - isDraft: if true, create or update content as draft.
    /// - Returns: URLRequest made with given parameters.
    public func makeWriteRequest(
        method: HTTPMethod,
        endpoint: String,
        contentId: String?,
        params: [String: Any]?,
        isDraft: Bool?) -> URLRequest? {
            
            var urlString = baseUrl + "/" + endpoint
            if let contentId = contentId {
                urlString += "/" + contentId
            }
            
            guard let url = URL(string: urlString),
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                      print("[ERROR] endpoint or parameter is invalid.")
                      return nil
                  }
            
            if let isDraft = isDraft, isDraft {
                components.queryItems = [.init(name: "status", value: "draft")]
            }
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = method.rawValue
            request.httpBody = makeBody(params: params)
            request.setValue(apiKey, forHTTPHeaderField: "X-MICROCMS-API-KEY")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            return request
        }
    
    private func makeBody(params: [String: Any]?) -> Data? {
        guard let params = params else { return nil }
        
        do {
            return try JSONSerialization.data(
                withJSONObject: params,
                options: .prettyPrinted)
        } catch {
            print("[ERROR] failed to make json body")
            return nil
        }
    }
    
    private func request(method: HTTPMethod,
                         endpoint: String,
                         contentId: String?,
                         params: [String: Any]?,
                         isDraft: Bool?,
                         completion: @escaping ((Result<Any, Error>) -> Void)) -> URLSessionTask? {
        let request = makeWriteRequest(method: method,
                                       endpoint: endpoint,
                                       contentId: contentId,
                                       params: params,
                                       isDraft: isDraft)
        
        guard let request = request else {
            print("[ERROR] failed to make request")
            return nil
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                do {
                    if method == .DELETE {
                        completion(.success("success"))
                    } else {
                        let object = try JSONSerialization.jsonObject(with: data, options: [])
                        completion(.success(object))
                    }
                } catch let error {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
        
        return task
    }
    
    /// post content for microCMS .
    ///
    /// - Parameters:
    ///   - endpoint: endpoint of contents.
    ///   - params: some parameters for body.
    ///   - isDraft: if true, create or update content as draft.
    /// - Returns: URLSessionTask you requested. Basically, you don't need to use it, but it helps you to manage state or cancel request.
    @discardableResult
    public func create(
        endpoint: String,
        params: [String: Any]?,
        isDraft: Bool,
        completion: @escaping ((Result<Any, Error>) -> Void)) -> URLSessionTask? {
            request(method: .POST,
                    endpoint: endpoint,
                    contentId: nil,
                    params: params,
                    isDraft: isDraft,
                    completion: completion)
        }
    
    /// create content with specified ID.
    ///
    /// - Parameters:
    ///   - endpoint: endpoint of contents.
    ///   - contentId: contentId. you can specify contentId for new content.
    ///   - params: some parameters for body.
    ///   - isDraft: if true, create or update content as draft.
    /// - Returns: URLSessionTask you requested. Basically, you don't need to use it, but it helps you to manage state or cancel request.
    @discardableResult
    public func create(
        endpoint: String,
        contentId: String,
        params: [String: Any]?,
        isDraft: Bool,
        completion: @escaping ((Result<Any, Error>) -> Void)) -> URLSessionTask? {
            request(method: .PUT,
                    endpoint: endpoint,
                    contentId: contentId,
                    params: params,
                    isDraft: isDraft,
                    completion: completion)
        }
    
    /// update content for microCMS .
    ///
    /// - Parameters:
    ///   - endpoint: endpoint of contents.
    ///   - contentId: contentId of target.
    ///   - params: some parameters for body.
    /// - Returns: URLSessionTask you requested. Basically, you don't need to use it, but it helps you to manage state or cancel request.
    @discardableResult
    public func update(
        endpoint: String,
        contentId: String? = nil,
        params: [String: Any]?,
        completion: @escaping ((Result<Any, Error>) -> Void)) -> URLSessionTask? {
            request(method: .PATCH,
                    endpoint: endpoint,
                    contentId: contentId,
                    params: params,
                    isDraft: nil,
                    completion: completion)
        }
    
    /// delete content for microCMS .
    ///
    /// - Parameters:
    ///   - endpoint: endpoint of contents.
    ///   - contentId: contentId of target.
    /// - Returns: URLSessionTask you requested. Basically, you don't need to use it, but it helps you to manage state or cancel request.
    @discardableResult
    public func delete(
        endpoint: String,
        contentId: String,
        completion: @escaping ((Result<Any, Error>) -> Void)) -> URLSessionTask? {
            request(method: .DELETE,
                    endpoint: endpoint,
                    contentId: contentId,
                    params: nil,
                    isDraft: nil,
                    completion: completion)
        }
}

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}
