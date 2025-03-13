import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var scoops: [ScoopModel]
    @State private var activeScoop: ScoopModel?
    @State private var isEditorPresented = false
    
    var body: some View {
        NavigationSplitView {
            List(scoops, selection: $activeScoop) { scoop in
                NavigationLink(scoop.title, value: scoop)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    ToolbarEditButton(mode: .add, isActive: $isEditorPresented)
                }
            }
            .sheet(isPresented: $isEditorPresented) {
                ScoopEditorView()
            }
        } detail: {
            if let activeScoop {
                NavigationStack {
                    ScoopView(scoop: activeScoop)
                }
                .navigationTitle(activeScoop.title)
            }
        }
    }
}



#Preview {
    ContentView()
        .modelContainer(.preview)
}
