import SwiftUI

struct CollectionView: View {
    var collection: CollectionModel
    @State private var listener: FirebaseListener
    @State private var isEditorPresented = false
    
    init(collection: CollectionModel) {
        self.collection = collection
        self.listener = .init(for: collection)
    }
    
    var body: some View {
        NavigationStack {
            BoopListView(boops: listener.boops)
            .padding()
            .sheet(isPresented: $isEditorPresented) {
                CollectionEditorView(collection: collection)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(collection.title)
                }
                ToolbarItem(placement: .primaryAction) {
                    ToolbarEditButton(mode: .edit, isActive: $isEditorPresented)
                }
            }
        }
        .onAppear {
            listener.listen()
        }
    }
}

#Preview {
    CollectionView(collection: .init(collection: "my-custom-collection"))
}
