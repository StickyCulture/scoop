import SwiftUI

extension Encodable {
    func prettyPrintedJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(self),
              let output = String(data: data, encoding: .utf8) else {
            return "Error: Unable to encode JSON"
        }
        return output
    }
}

struct JSONView: View {
    let dictionary: Any
    
    var body: some View {
        ScrollView {
            Text(prettyJSON)
                .font(.system(size: 12, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var prettyJSON: String {
        guard JSONSerialization.isValidJSONObject(dictionary),
              let data = try? JSONSerialization.data(withJSONObject: dictionary, options: [.prettyPrinted, .sortedKeys]),
              let output = String(data: data, encoding: .utf8) else {
            return "\(dictionary)"
        }
        return output
    }
}
