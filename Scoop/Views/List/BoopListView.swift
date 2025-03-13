import SwiftUI

struct BoopListView: View {
    var boops: [BoopItem]
    
    var body: some View {
        VStack {
            if boops.isEmpty {
                Spacer()
                Text("waiting for boops...")
            } else {
                LazyVStack(spacing: 30) {
                    ForEach(boops) { boop in
                        BoopLineItemView(boop: boop)
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    BoopListView(boops: [
        .sessionStop,
        .tapEvent,
        .zoomEvent,
        .sessionStart,
        .sessionFlop,
        .appLaunch,
    ])
}
