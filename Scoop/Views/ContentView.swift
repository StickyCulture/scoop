import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var scoops: [ScoopModel]
    @State private var activeScoop: ScoopModel?
    @State private var isEditorPresented = false
    
    var body: some View {
        NavigationSplitView {
            VStack {
                if scoops.isEmpty {
                    Spacer()
                    Text("Add a scoop!")
                    Spacer()
                } else {
                    List(scoops, selection: $activeScoop) { scoop in
                        NavigationLink(value: scoop) {
                            HStack {
                                if scoop.isDevelopment {
                                    DevChipView()
                                }
                                Text(scoop.title)
                            }
                        }
                            .swipeActions(edge: .trailing) {
                                Button("Delete", role: .destructive) {
                                    modelContext.delete(scoop)
                                }
                            }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Scoop")
                        .font(.headline)
                }
                ToolbarItem(placement: .primaryAction) {
                    ToolbarEditButton(mode: .add, isActive: $isEditorPresented)
                }
            }
            .sheet(isPresented: $isEditorPresented) {
                ScoopEditorView()
            }
        } detail: {
            if let activeScoop {
                ScoopView(scoop: activeScoop)
            }
        }
    }
}



#Preview {
    ContentView()
        .modelContainer(.preview)
}
