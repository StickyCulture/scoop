import SwiftData

@Model final class ScoopModel {
    var nickname: String = ""
    var collection: String
    var instance: String = ""
    var isDevelopment: Bool = false
    
    var title: String {
        if !nickname.isEmpty {
            return nickname
        }
        
        var _title = collection
        if instance.isEmpty || instance == "default" {
            return _title
        }
        _title += " (\(instance))"
        return _title
    }
    
    var collectionVariant: String {
        return isDevelopment ? "\(collection)-dev" : collection
    }
    
    init(collection: String) {
        self.collection = collection
    }
}
