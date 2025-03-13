import SwiftUI

struct BoopLineItemView: View {
    var boop: BoopItem
    @State var showDetails: Bool = false
    @State var scale: CGFloat = 1
    
    var body: some View {
        let value = boop.value
        let hasChildren = value != nil
        let isOpen = hasChildren && showDetails
        let multiplier: CGFloat = isOpen ? 2.0 : 1
        
        LazyVStack(spacing: 10) {
            Button {
                withAnimation(.bouncy(duration: 0.4)) {
                    showDetails.toggle()
                }
            } label: {
                HStack(alignment: .center, spacing: 10) {
                    HStack(spacing: 12) {
                        Image(systemName: boop.eventCategory.symbol)
                            .foregroundColor(boop.eventCategory.color)
                        Text(boop.event)
                        Spacer()
                        Text(boop.timestamp, style: .relative)
                    }
                    Image(systemName: scale == 1 ? isOpen ? "minus.circle.fill" : "circle.fill" : "minus.circle.fill")
                        .resizable()
                        .foregroundStyle(hasChildren ? showDetails ? .gray : .blue : .gray.opacity(0.5))
                        .frame(width: 6, height: 6)
                        .scaleEffect(scale * multiplier)
                }
                .padding(.horizontal, 5)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if isOpen {
                ZStack {
                    Color.gray.opacity(0.2)
                    VStack {
                        if let label = boop.label {
                            HStack {
                                Text(label)
                                    .font(.caption)
                                Spacer()
                            }
                        }
                        switch boop.eventCategory {
                            case .anyEvent:
                                JSONView(dictionary: value as Any)
                            case .sessionStart, .sessionStop, .sessionFlop:
                                if let timeValue = value as? Int {
                                    JSONView(dictionary: timeValue)
                                }
                            case .appLaunch:
                                EmptyView()
                            @unknown default:
                                EmptyView()
                        }
                    }
                    .padding(10)
                }
                .clipShape(
                    RoundedRectangle(
                        cornerSize: .init(width: 5, height: 5)
                    )
                )
            }
        }
        .clipped(antialiased: true)
        .onChange(of: showDetails) {
            guard showDetails else { return }
            
            withAnimation(.bouncy(duration: 0.2)) {
                scale = hasChildren ?  1.2 : 2.5
            } completion: {
                withAnimation(.bouncy) {
                    scale = 1.0
                    showDetails = hasChildren
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
