import Foundation
import SwiftData
import OSLog

import FirebaseFirestore

@Observable class FirebaseListener {
    var scoop: ScoopModel
    var boops: [BoopItem] = []
    var sessions: [BoopSession] = []
    var indexUrls: [URL:Bool] = [:]

    private var listener: ListenerRegistration?
    
    init(for scoop: ScoopModel) {
        self.scoop = scoop
    }
    
    func listen() {
        let collectionRef = Firestore.firestore().collection(
            scoop.collectionVariant
        )
        var query = collectionRef
            .whereField(
                "timestamp",
                isGreaterThanOrEqualTo: FirebaseFirestore.Timestamp(date: Date())
            )
        
        if !scoop.instanceFilter.isEmpty {
            query = query.whereField("instance", isEqualTo: scoop.instanceFilter)
        }
        
        query = query.order(by: "timestamp", descending: true)
        
        self.listener = query.addSnapshotListener { (querySnapshot: QuerySnapshot?, error: Error?) in
            self.receiveSnapshot(querySnapshot: querySnapshot, error: error)
        }
    }
    
    private func receiveSnapshot(querySnapshot: QuerySnapshot?, error: Error?) {
        if let error = error {
            print("receiveSnapshot: error \(error)")
            handleIndexError(error)
            return
        }
        
        guard let snapshot = querySnapshot else {
            print("receiveSnapshot: no snapshot")
            return
        }
        
        snapshot.documentChanges.forEach { diff in
            if diff.type == .added {
                let document = diff.document
                let boop = BoopItem(
                    from: document,
                    withId: document.documentID
                )

                boops.insert(boop, at: 0)
                
                if boop.eventCategory == .sessionStop,
                   let session = try? BoopSession(from: boop) {
                    sessions.append(session)
                }
            }
        }
    }
    
    func getSessions() {
        let collectionRef = Firestore.firestore().collection(
            scoop.collectionVariant
        )
        var query = collectionRef
            .whereField(
                "timestamp",
                isGreaterThanOrEqualTo: FirebaseFirestore.Timestamp(date: 24.hoursAgo)
            )
            .whereField(
                "event",
                isEqualTo: BoopEvent.sessionStop.rawValue
            )
        
        if !scoop.instanceFilter.isEmpty {
            query = query.whereField("instance", isEqualTo: scoop.instanceFilter)
        }
        
        query = query.order(by: "timestamp", descending: true)
        
        query.getDocuments { (querySnapshot: QuerySnapshot?, error: Error?) in
            self.receiveSessionsSnapshot(querySnapshot: querySnapshot, error: error)
        }
    }
    
    private func receiveSessionsSnapshot(querySnapshot: QuerySnapshot?, error: Error?) {
        if let error = error {
            print("receiveSnapshot: error \(error.localizedDescription)")
            handleIndexError(error)
            return
        }
        
        guard let snapshot = querySnapshot else {
            print("receiveSnapshot: no snapshot")
            return
        }
        
        snapshot.documentChanges.forEach { diff in
            if diff.type == .added {
                let document = diff.document
                let boop = BoopItem(from: document, withId: document.documentID)
                
                if boop.eventCategory == .sessionStop,
                   let session = try? BoopSession(from: boop) {
                    sessions.append(session)
                }
            }
        }
    }
    
    private func handleIndexError(_ error: Error) {
        guard let firestoreError = error as NSError?,
              firestoreError.domain == "FIRFirestoreErrorDomain",
              firestoreError.code == 9,
              let description = firestoreError.userInfo["NSLocalizedDescription"] as? String,
              let urlRange = description.range(of: "https://console.firebase.google.com/.*?(?=\\s|$)", options: .regularExpression) else {
            return
        }
        
        let indexUrl = String(description[urlRange])
        
        if let url = URL(string: indexUrl) {
            indexUrls[url] = true
        }
    }
    
    func removeAll() {
        self.listener?.remove()
        self.boops.removeAll()
        self.sessions.removeAll()
    }
    
    deinit {
        removeAll()
    }
}
