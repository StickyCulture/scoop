import SwiftUI
import Charts

extension Int {
    /// gets Date by subtracting `n` hours from current time
    var hoursAgo: Date {
        return Calendar.current.date(byAdding: .hour, value: self * -1, to: .now) ?? .now.addingTimeInterval(self.hours * -1)
    }
    
    var hours: TimeInterval {
        Double(self) * 3600
    }
}

/// Displays the last 24 hours of session activity
struct SessionChart: View {
    var data: [BoopSession] = []
    
    @State var starting: Date = 24.hoursAgo
    @State var ending: Date = 0.hoursAgo
    @State var minuteOffset: Int = 0
    
    @State var zoomLevel: TimeInterval = 8.hours
    @State var scrollX: Date = 0.hoursAgo
    
    let hourLine = StrokeStyle(lineWidth: 1.0, dash: [2.0, 2.0])
    let quarterLine = StrokeStyle(lineWidth: 1.0, dash: [2.0, 14.0])
    
    let dataDebounce: Debouncer = .init()
    let zoomDebounce: Debouncer = .init()
    
    func setZoom(to level: TimeInterval) {
        if level == zoomLevel { return }
        
        withAnimation(.easeInOut) {
            zoomLevel = level
        } completion: {
            zoomDebounce.delay(for: 0.25) {
                scrollX = 0.hoursAgo
            }
        }
    }
    
    func resetTimeline() {
        withAnimation {
            starting = 24.hoursAgo
            ending = 0.hoursAgo
        }
    }
    
    var body: some View {
            VStack(spacing: 0) {
                ZStack {
                    Chart {
                        if let scale = data.first {
                            RectangleMark(
                                xStart: .value("Start Time", scale.startTime),
                                xEnd: .value("End Time", scale.startTime),
                                yStart: .value("row", 0.0),
                                yEnd: .value("row", 1.0)
                            )
                        }
                        ForEach(data) { session in
                            if session.duration > 1 {
                                RectangleMark(
                                    xStart: .value("Start Time", session.startTime),
                                    xEnd: .value("End Time", session.endTime),
                                    yStart: .value("row", 0.3),
                                    yEnd: .value("row", 1.0)
                                )
                                .foregroundStyle(LinearGradient(colors: [.BoopEvent.sessionStart, .BoopEvent.sessionStart, .BoopEvent.sessionStop], startPoint: .leading, endPoint: .trailing))
                            }
                        }
                    }
                    .frame(height: 100)
                    .chartXScale(domain: [starting, ending])
                    .chartXAxis {
                        AxisMarks(preset: .inset, values: .stride(by: .hour, roundLowerBound: true)) { value in
                            let hourMark: Date.FormatStyle = .dateTime.hour(.conversationalDefaultDigits(amPM: .abbreviated))
                            let dayMark: Date.FormatStyle = .dateTime.weekday(.wide)
                            
                            let dayLabel = AxisValueLabel(format: dayMark, collisionResolution: .disabled)
                                .font(.caption.bold())
                                .offset(y: 5)
                            let hourLabel = AxisValueLabel(format: hourMark, collisionResolution: .disabled)
                                .font(.caption2)
                                .offset(y: -8)
                            let gridLine = AxisGridLine(stroke: hourLine)
                                .foregroundStyle(Color.Chart.gridLine)
                            
                            switch zoomLevel {
                                case 24.hours:
                                    if value.index % 16 == 0 {
                                        dayLabel
                                        hourLabel
                                    }
                                    if value.index % 8 == 0 {
                                        gridLine
                                    }
                                case 8.hours:
                                    if value.index % 8 == 0 {
                                        dayLabel
                                    }
                                    if value.index % 2 == 0 {
                                        gridLine
                                        hourLabel
                                    }
                                case 4.hours:
                                    if value.index % 4 == 0 {
                                        dayLabel
                                    }
                                    hourLabel
                                    gridLine
                                default:
                                    gridLine
                                    dayLabel
                                    hourLabel
                            }
                        }
                        if zoomLevel < 4.hours {
                            AxisMarks(preset: .inset, values: .stride(by: .minute, roundLowerBound: true)) { value in
                                let minute = value.index + minuteOffset
                                if minute % 15 == 0 && minute % 60 != 0 {
                                    AxisGridLine(centered: true, stroke: quarterLine)
                                        .foregroundStyle(Color.Chart.gridLine)
                                }
                            }
                        }
                    }
                    .chartYAxis() {
                        AxisMarks(preset: .inset, values: [0.3]) { value in
                            AxisGridLine(centered: false, stroke: StrokeStyle(lineWidth: 1.0))
                                .foregroundStyle(Color.Chart.gridLine)
                        }
                    }
                    .chartScrollableAxes(.horizontal)
                    .chartXVisibleDomain(length: zoomLevel)
                    .chartScrollPosition(x: $scrollX)
                    
                    HStack {
                        Spacer()
                        Text("\(data.count)")
                            .font(.title.weight(.black))
                            .foregroundStyle(Color.Chart.highlight)
                            .padding(.horizontal, 10)
                    }
                }
                
                HStack(spacing: 20) {
                    Button("24 hr", action: { setZoom(to: 24.hours) })
                        .disabled(zoomLevel == 24.hours)
                    Button("8 hr", action: { setZoom(to: 8.hours) })
                        .disabled(zoomLevel == 8.hours)
                    Button("4 hr", action: { setZoom(to: 4.hours) })
                        .disabled(zoomLevel == 4.hours)
                    Button("1 hr", action: { setZoom(to: 1.hours) })
                        .disabled(zoomLevel == 1.hours)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .font(.caption2.bold())
                .padding(10)
            }
            .onChange(of: data.count, initial: true) {
                dataDebounce.delay(for: 1) {
                    resetTimeline()
                }
            }
            .onChange(of: starting, initial: true) {
                minuteOffset = Calendar.current.component(.minute, from: starting)
            }
        }
}

#Preview {
    let sessions = BoopSession.generateRandomTimeline(count: 20)
    SessionChart(data: sessions)
}
