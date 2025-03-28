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
    @State var isDevelopment: Bool = false
    
    private func save() {
        if let scoop {
            // Edit
            scoop.nickname = nickName
            scoop.collection = collectionName
            scoop.instanceFilter = instanceName
            scoop.isDevelopment = isDevelopment
        } else {
            // Add
            let newScoop = ScoopModel(collection: collectionName)
            newScoop.nickname = nickName
            newScoop.instanceFilter = instanceName
            newScoop.isDevelopment = isDevelopment
            modelContext.insert(newScoop)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Basic Information") {
                    TextField("Collection", text: $collectionName)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                    TextField("Name (optional)", text: $nickName)
                }
                Section("Filters") {
                    Toggle(isOn: $isDevelopment) {
                        Text("Development")
                    }
                    TextField("Instance", text: $instanceName)
                        .autocorrectionDisabled(true)
                        .autocapitalization(.none)
                }
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
                instanceName = scoop.instanceFilter
                isDevelopment = scoop.isDevelopment
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
