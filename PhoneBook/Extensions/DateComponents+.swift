import Foundation

extension DateComponents {
    func getRuDateRepresentaion() -> String {
        guard let day = self.day, let month = self.month, let year = self.year else {
            return ""
        }
        return "\(day).\(month).\(year)"
    }
}
