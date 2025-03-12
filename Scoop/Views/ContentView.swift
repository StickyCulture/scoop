import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var collections: [CollectionModel]
    @State private var selectedCollection: CollectionModel?
    @State private var isEditorPresented = false
    
    var body: some View {
        NavigationSplitView {
            List(collections, selection: $selectedCollection) { collection in
                NavigationLink(collection.title, value: collection)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    ToolbarEditButton(mode: .add, isActive: $isEditorPresented)
                }
            }
            .sheet(isPresented: $isEditorPresented) {
                CollectionEditorView()
            }
        } detail: {
            if let selectedCollection {
                NavigationStack {
                    CollectionView(collection: selectedCollection)
                }
                .navigationTitle(selectedCollection.title)
            }
        }
    }
}



#Preview {
    ContentView()
        .modelContainer(.preview)
}
