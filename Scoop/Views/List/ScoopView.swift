import SwiftUI

struct ScoopView: View {
    var scoop: ScoopModel
    @State private var listener: FirebaseListener
    @State private var isEditorPresented = false
    
    init(scoop: ScoopModel) {
        self.scoop = scoop
        self.listener = .init(for: scoop)
    }
    
    var body: some View {
        NavigationStack {
            BoopListView(boops: listener.boops)
            .padding()
            .sheet(isPresented: $isEditorPresented) {
                ScoopEditorView(scoop: scoop)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(scoop.title)
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
    ScoopView(scoop: .init(collection: "my-custom-collection"))
}
