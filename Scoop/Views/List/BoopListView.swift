import SwiftUI

struct BoopListView: View {
    var boops: [BoopItem]
    
    var body: some View {
        if boops.isEmpty {
            VStack {
                Spacer()
                Text("waiting for boops...")
                Spacer()
            }
        } else {
            ScrollView {
                LazyVStack(spacing: 30) {
                    ForEach(boops) { boop in
                        BoopLineItemView(boop: boop)
                    }
                }
            }
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
