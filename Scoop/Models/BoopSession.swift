import Foundation

struct BoopSession: Identifiable {
    var id: String
    var startTime: Date
    var endTime: Date
    
    var duration: TimeInterval {
        endTime.timeIntervalSince(startTime)
    }
    
    init (id: String, startTime: Date, endTime: Date) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
    }
    
    init(from boop: BoopItem) throws {
        guard let milliseconds = boop.value as? Int else {
            throw NSError(domain: "BoopSession must be initialized with a SessionStop event with Int value", code: 1, userInfo: nil)
        }
        let negative_duration: Double = TimeInterval(milliseconds) / -1000
        id = boop.id
        startTime = boop.timestamp.addingTimeInterval(negative_duration)
        endTime = boop.timestamp
    }
    
    static func generateRandomTimeline(count: Int) -> [BoopSession] {
        var sessions: [BoopSession] = []
        var latestTime: Date = .now
        for _ in 0..<count {
            let randomOffset = Double.random(in: 0...3600) // Random offset between 0 and 1 hour
            let endTime = latestTime.addingTimeInterval(-randomOffset)
            let randomDuration = Double.random(in: 10...1200) // Random duration between 10 seconds and 20 minutes
            let startTime = endTime.addingTimeInterval(-randomDuration)
            let session = BoopSession(id: UUID().uuidString, startTime: startTime, endTime: endTime)
            sessions.append(session)
            latestTime = startTime
        }
        return sessions
    }
}
