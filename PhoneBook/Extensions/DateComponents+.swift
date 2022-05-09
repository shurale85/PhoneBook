import Foundation

extension DateComponents {
    func getRuDateRepresentaion() -> String {
        guard let day = self.day, let month = self.month, let year = self.year else {
            return ""
        }
        var srtingDay = "\(day)"
        if day < 10 {
            srtingDay = "0" + "\(day)"
        }
        
        var stringMonth = "\(month)"
        if month < 10 {
            stringMonth = "0" + "\(month)"
        }
        
        return "\(srtingDay).\(stringMonth).\(year)"
    }
}
