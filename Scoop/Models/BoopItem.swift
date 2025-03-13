import Foundation
import FirebaseFirestore

struct BoopItem {
    var id: String
    var instance: String
    var sessionId: String?
    var event: String
    var label: String?
    var value: Any?
    var timestamp: Date
    
    init(from document: DocumentSnapshot, withId id: String) {
        let data = document.data()!
        
        let _instance = (data["instance"] as? String) ?? ""
        let _sessionId = data["sessionId"] as? String
        let _event = (data["event"] as? String) ?? ""
        let _label = (data["label"] as? String)
        let _timestamp = (data["timestamp"] as! FirebaseFirestore.Timestamp).dateValue()
        let _value = data["value"]
        
        self.id = id
        self.instance = _instance
        self.sessionId = _sessionId
        self.event = _event
        self.label = _label
        self.timestamp = _timestamp
        self.value = _value
    }
}
