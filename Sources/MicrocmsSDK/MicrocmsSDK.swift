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
    
    public func get(endpoint: String,
             contentId: String?,
             parameter: [String: String]?,
             completion: @escaping ((Result<Any, Error>) -> Void)) {
        
        var urlString = baseUrl + "/" + endpoint
        if let contentID = contentId {
            urlString += "/\(contentID)"
        }
        
        guard let url = URL(string: urlString),
              var components = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false) else {
            print("[ERROR] endpoint or parameter is invalid.")
            return
        }
        
        if let parameter = parameter {
            var queryItems: [URLQueryItem] = []
            for parameterKey in parameter.keys {
                queryItems.append(
                    URLQueryItem(name: parameterKey, value: parameter[parameterKey])
                )
            }
            
            components.queryItems = queryItems
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        if let globalDraftKey = globalDrafyKey {
            request.setValue(globalDraftKey, forHTTPHeaderField: "X-GLOBAL-DRAFT-KEY")
        }
        
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
    }
}

