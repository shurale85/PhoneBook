import Foundation

@propertyWrapper
struct PhoneNumberSanitizer {
    private var phoneNumber: String
    
    var wrappedValue: String {
        set {
            phoneNumber = newValue.phoneNumberSymbols
        }
        get {
            phoneNumber
        }
    }
    
    init(wrappedValue: String){
        phoneNumber = wrappedValue.phoneNumberSymbols
    }
    
    var projectedValue: String {
        let numbers: [Character] = Array(phoneNumber.digits)
        let displayNumber = "+" + "\(numbers[0]) " + String(numbers[1...3]) + " " + String(numbers[4...6]) + "-" + String(numbers[7...8]) + "-" + String(numbers[9...10])
        return displayNumber
    }
}

extension PhoneNumberSanitizer: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            phoneNumber = ""
        } else {
            let string = try container.decode(String.self)
            phoneNumber = string
        }
    }
}
