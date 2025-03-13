import SwiftUI

struct ToolbarEditButton: View {
    enum Mode {
        case add
        case edit
    }
    
    var mode: Mode
    @Binding var isActive: Bool
    
    var body: some View {
        Button {
            isActive = true
        } label: {
            switch mode {
                case .add:
                    Text("Add")
                case .edit:
                    Text("Edit")
            }
        }
    }
}
