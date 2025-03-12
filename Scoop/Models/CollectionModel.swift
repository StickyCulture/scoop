import SwiftData

@Model final class CollectionModel {
    var nickname: String = ""
    var collection: String
    var instance: String = ""
    
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
    
    init(collection: String) {
        self.collection = collection
    }
}
