import Foundation
import SwiftUI

import FirebaseFirestore

struct BoopItem: Identifiable {
    var id: String
    var instance: String
    var sessionId: String?
    var event: String
    var eventCategory: BoopEvent
    var label: String?
    var value: Any?
    var timestamp: Date
    
    init(sessionId: String = UUID().uuidString, event: String, label: String? = nil, value: Any? = nil, timestamp: Date = Date()) {
        self.id = UUID().uuidString
        self.instance = "default"
        self.sessionId = sessionId
        self.event = event
        self.eventCategory = .init(rawValue: event) ?? .anyEvent
        self.label = label
        self.value = value
        self.timestamp = timestamp

        if self.eventCategory == .appLaunch {
            self.sessionId = nil
        }
    }
    
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
        self.eventCategory = .init(rawValue: _event) ?? .anyEvent
        self.label = _label
        self.timestamp = _timestamp
        self.value = _value
    }
    
    static let sessionStop = BoopItem(event: BoopEvent.sessionStop.rawValue, label: "Session Duration in Milliseconds (minus Timeout delay)", value: 2120)
    static let tapEvent = BoopItem(event: "Tap Tap", label: "Tap Coordinates", value: ["x": 100.0, "y": 200.0])
    static let zoomEvent = BoopItem(event: "Zoom Zoom")
    static let sessionStart = BoopItem(event: BoopEvent.sessionStart.rawValue)
    static let sessionFlop = BoopItem(event: BoopEvent.sessionFlop.rawValue)
    static let appLaunch = BoopItem(event: BoopEvent.appLaunch.rawValue)
}

enum BoopEvent: String, Codable {
    case appLaunch = "App Launch"
    case sessionStart = "Session Start"
    case sessionStop = "Session Stop"
    case sessionFlop = "Session Flop"
    case anyEvent = "Any Event"
    
    var color: Color {
        switch self {
            case .appLaunch:
                return .BoopEvent.appLaunch
            case .sessionStart:
                return .BoopEvent.sessionStart
            case .sessionStop:
                return .BoopEvent.sessionStop
            case .sessionFlop:
                return .BoopEvent.sessionFlop
            case .anyEvent:
                return .BoopEvent.anyEvent
        }
    }
    
    var symbol: String {
        switch self {
            case .appLaunch:
                return "bolt.circle.fill"
            case .sessionStart:
                return "circle.fill"
            case .sessionStop:
                return "square.fill"
            case .sessionFlop:
                return "square.dotted"
            case .anyEvent:
                return "arrowtriangle.forward.fill"
        }
    }
}
