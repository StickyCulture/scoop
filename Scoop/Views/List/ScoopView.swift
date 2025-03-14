import SwiftUI

struct ScoopView: View {
    var scoop: ScoopModel
    @State private var listener: FirebaseListener = .init(for: .init(collection: ""))
    @State private var isEditorPresented = false
    
    private func beginListening() {
        listener = .init(for: scoop)
        listener.listen()
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
                    HStack {
                        if scoop.isDevelopment {
                            DevChipView()
                        }
                        Text(scoop.title)
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    ToolbarEditButton(mode: .edit, isActive: $isEditorPresented)
                }
            }
        }
        .onChange(of: isEditorPresented) {
            if !isEditorPresented {
                beginListening()
            }
        }
        .onAppear {
            beginListening()
        }
    }
}

#Preview {
    ScoopView(scoop: .init(collection: "my-custom-collection"))
}

