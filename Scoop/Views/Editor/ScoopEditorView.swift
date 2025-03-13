import SwiftUI

struct ScoopEditorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var scoop: ScoopModel? = nil
    private var editorTitle: String {
        scoop == nil ? "Add Scoop" : "Edit Scoop"
    }
    
    @State var nickName: String = ""
    @State var collectionName: String = ""
    @State var instanceName: String = ""
    
    private func save() {
        if let scoop {
            // Edit
            scoop.nickname = nickName
            scoop.collection = collectionName
            scoop.instance = instanceName
        } else {
            // Add
            let newScoop = ScoopModel(collection: collectionName)
            newScoop.collection = collectionName
            newScoop.instance = instanceName
            modelContext.insert(newScoop)
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
            if let scoop {
                nickName = scoop.nickname
                collectionName = scoop.collection
                instanceName = scoop.instance
            }
        }
    }
}

#Preview("Add a Scoop") {
    ScoopEditorView(scoop: nil)
        .modelContainer(.preview)
}

#Preview("Add a Scoop") {
    ScoopEditorView(scoop: .init(collection: "my-editor-collection"))
        .modelContainer(.preview)
}
