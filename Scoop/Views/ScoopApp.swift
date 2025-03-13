import SwiftUI
import Firebase

@main
struct ScoopApp: App {
    init() {
        FirebaseApp.configure()
        let settings = FirestoreSettings()
        settings.cacheSettings = MemoryCacheSettings()
        Firestore.firestore().settings = settings
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(try! .configure(for: "Release"))
        }
    }
}
