extension RangeReplaceableCollection where Self: StringProtocol {
    var digits: Self { filter(\.isWholeNumber)}
    
    var phoneNumberSymbols: Self {filter(\.isDigitOrPlus)}
}

extension RangeReplaceableCollection where Self: StringProtocol {
    mutating func removeAllNonPhoneSymbols() {
        removeAll { !$0.isDigitOrPlus }
    }
}
