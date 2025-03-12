import SwiftUI

struct CollectionView: View {
    var collection: CollectionModel
    @State private var isEditorPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
            }
            .navigationTitle(collection.title)
            .sheet(isPresented: $isEditorPresented) {
                CollectionEditorView(collection: collection)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    ToolbarEditButton(mode: .edit, isActive: $isEditorPresented)
                }
            }
        }
    }
}

#Preview {
    CollectionView(collection: .init(collection: "my-custom-collection"))
}
