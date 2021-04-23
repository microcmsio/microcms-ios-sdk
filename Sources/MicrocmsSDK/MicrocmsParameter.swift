import Foundation

/// Parameters that can be passed to the get function.
public enum MicrocmsParameter {
    // MARK: - Common Parameters
    ///
    /// Elements to be retrieved in the content.
    /// ex) .fields(["title", "main_image", "updatedAt", "author.name"]
    case fields([String])
    
    /// Depth of the hierarchy from which to retrieve the reference content.
    /// Default value is 1, and maximum is 3.
    case depth(Int)
    
    // MARK: - List Parameters
    
    /// Number of retrievals,  default value is 10.
    case limit(Int)
    
    /// Offset, default value is 0.
    case offset(Int)
    
    /// Sort the contents to be retrieved.
    /// ex) .orders(["publishedAt"])
    ///
    /// If you want to specify descending order, prefix the field name with - (minus).
    /// .orders(["publishedAt", "-updatedAt"])
    ///
    /// Only fields with "Date", "True/False", and "Numeric" can be sorted,
    /// and any other field specification will be ignored.
    case orders([String])
    
    /// Performs a full-text search of the content.
    /// The fields to be searched are "text field", "text area", and "rich editor".
    case q(String)
    
    /// Get only the target content by specifying the content id.
    /// ex) .ids(["first_id", "second_id", "third_id"])
    case ids([String])
    
    /// Filters the content to be retrieved by specifying conditions.
    /// There are various options, so please refer to the API reference for available conditional expressions.
    /// https://document.microcms.io/content-api/get-list-contents#hdebbdc8e86
    case filters(String)
    
    var queryItem: URLQueryItem {
        switch self {
        
        case .fields(let value):
            return .init(name: "fields", value: value.joined(separator: ","))
        case .depth(let value):
            return .init(name: "depth", value: String(value))
        case .limit(let value):
            return .init(name: "limit", value: String(value))
        case .offset(let value):
            return .init(name: "offset", value: String(value))
        case .orders(let value):
            return .init(name: "orders", value: value.joined(separator: ","))
        case .q(let value):
            return .init(name: "q", value: value)
        case .ids(let value):
            return .init(name: "ids", value: value.joined(separator: ","))
        case .filters(let value):
            return .init(name: "filters", value: value)
        }
    }
}
