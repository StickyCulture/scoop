import SwiftUI

struct CollectionEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var collection: CollectionModel? = nil
    private var editorTitle: String {
        collection == nil ? "Add Collection" : "Edit Collection"
    }
    
    @State var nickName: String = ""
    @State var collectionName: String = ""
    @State var instanceName: String = ""
    
    private func save() {
        if let collection {
            // Edit
            collection.nickname = nickName
            collection.collection = collectionName
            collection.instance = instanceName
        } else {
            // Add
            let newCollection = CollectionModel(collection: collectionName)
            newCollection.collection = collectionName
            newCollection.instance = instanceName
            modelContext.insert(newCollection)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name (optional)", text: $nickName)
                TextField("Collection", text: $collectionName)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                TextField("Instance (optional)", text: $instanceName)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(editorTitle)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        withAnimation {
                            save()
                            dismiss()
                        }
                    }
                    // Require a category to save changes.
                    .disabled(
                        collectionName.trimmingCharacters(in: .whitespaces).isEmpty
                    )
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let collection {
                // Edit the incoming animal.
                nickName = collection.nickname
                collectionName = collection.collection
                instanceName = collection.instance
            }
        }
    }
}

#Preview("Add a Collection") {
    CollectionEditorView(collection: nil)
        .modelContainer(.preview)
}

#Preview("Add a Collection") {
    CollectionEditorView(collection: .init(collection: "my-editor-collection"))
        .modelContainer(.preview)
}
