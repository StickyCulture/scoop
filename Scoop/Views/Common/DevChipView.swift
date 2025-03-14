import SwiftUI
struct DevChipView: View {
    var body: some View {
        Text("dev")
            .textCase(.uppercase)
            .font(.system(size: 10, weight: .bold, design: .monospaced))
            .padding(5)
            .background(.gray.opacity(0.4))
            .cornerRadius(5)
    }
}
