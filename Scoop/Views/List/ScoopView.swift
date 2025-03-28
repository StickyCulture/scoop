import SwiftUI

struct ScoopView: View {
    var scoop: ScoopModel
    @State private var listener: FirebaseListener = .init(for: .init(collection: ""))
    @State private var isEditorPresented = false
    
    private func beginListening() {
        listener = .init(for: scoop)
        listener.getSessions()
        listener.listen()
    }
    
    private func handleIndexCreation() {
        guard let url = listener.indexUrls.keys.first else { return }
        DispatchQueue.main.async {
            UIApplication.shared.open(url)
            listener.indexUrls.removeValue(forKey: url)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    SessionChart(data: listener.sessions)
                    BoopListView(boops: listener.boops)
                        .padding()
                }
                if listener.indexUrls.count > 0 {
                    VStack {
                        Spacer()
                        Button(action: handleIndexCreation) {
                            Label {
                                VStack(alignment: .leading) {
                                    Text("\(listener.indexUrls.count) \(listener.indexUrls.count == 1 ? "Index" : "Indices") Required")
                                        .foregroundColor(.primary)
                                    Text("Tap to create index in Cloud Firestore console.")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            } icon: {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundStyle(.yellow)
                            }
                            .padding(10)
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                    }
                }
            }
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
        .navigationTitle(scoop.title)
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

