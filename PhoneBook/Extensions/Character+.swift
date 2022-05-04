extension Character {
    var isDigitOrPlus: Bool { "0"..."9" ~= self || self == "+"}
}
