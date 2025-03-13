import Foundation
import SwiftData
import OSLog

import FirebaseFirestore

@Observable class FirebaseListener {
    var scoop: ScoopModel
    var boops: [BoopItem] = []

    private var listener: ListenerRegistration?
    
    init(for scoop: ScoopModel) {
        self.scoop = scoop
    }
    
    func listen() {
        removeAll()
        
        let collectionRef = Firestore.firestore().collection(
            scoop.collectionVariant
        )
        var query = collectionRef
            .whereField(
                "timestamp",
                isGreaterThanOrEqualTo: FirebaseFirestore.Timestamp(date: Date())
            )
        query = query.order(
            by: "timestamp",
            descending: true
        )
        .limit(to: 50)
        
        self.listener = query.addSnapshotListener { (querySnapshot: QuerySnapshot?, error: Error?) in
            self.receiveSnapshot(querySnapshot: querySnapshot, error: error)
        }
    }
    
    private func receiveSnapshot(querySnapshot: QuerySnapshot?, error: Error?) {
        if let error = error {
            print("receiveSnapshot: error \(error)")
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
                
                
                if scoop.instance.isEmpty || scoop.instance != boop.instance {
                    return
                }
                boops.insert(boop, at: 0)
            }
        }
    }
    
    func removeAll() {
        self.listener?.remove()
        self.boops.removeAll()
    }
    
    deinit {
        removeAll()
    }
}
