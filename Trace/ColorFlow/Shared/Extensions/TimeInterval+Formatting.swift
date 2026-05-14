import Foundation

extension TimeInterval {
    var formattedMMSS: String {
        let total = Int(self)
        let minutes = total / 60
        let seconds = total % 60
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
}
