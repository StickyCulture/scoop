import Foundation
import SwiftData

extension ModelContainer {
    static func configure(for temporaryDatabaseName: String) throws -> ModelContainer {
        let storageUrl = URL.documentsDirectory.appending(path: "ScoopApp").appending(path: "\(temporaryDatabaseName).sqlite")
        do {
            let config = ModelConfiguration(url: storageUrl)
            let schema = Schema([CollectionModel.self])
            let modelContainer = try ModelContainer(
                for: schema,
                migrationPlan: nil,
                configurations: config
            )
            print("init: storage URL is \(storageUrl)")
            #if targetEnvironment(simulator)
            Task { @MainActor in
                // if there are no CollectionModels in the database yet, create them
                if let existing = try? modelContainer.mainContext.fetch(FetchDescriptor<CollectionModel>()), existing.isEmpty {
                    let leopardModel = CollectionModel(collection: "leopard-telemetry")
                    leopardModel.nickname = "Leopard"
                    let geckoModel = CollectionModel(collection: "gecko-telemetry")
                    geckoModel.nickname = "Gecko"
                    geckoModel.instance = "dev"
                    
                    modelContainer.mainContext.insert(leopardModel)
                    modelContainer.mainContext.insert(geckoModel)
                    try? modelContainer.mainContext.save()
                }
            }
            #endif
            return modelContainer
        } catch {
            fatalError("Failed to configure the SwiftData container")
        }
    }
    
    static var preview: ModelContainer {
        try! .configure(for: "preview")
    }
}
