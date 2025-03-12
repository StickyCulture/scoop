import SwiftUI

@main
struct ScoopApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(try! .configure(for: "Release"))
        }
    }
}
