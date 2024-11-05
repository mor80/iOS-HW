import UIKit

// MARK: - UIColor methods
extension UIColor {
    // MARK: - HEX constructor
    public convenience init?(hexColor: String) {
        if (hexColor.hasPrefix("#") && hexColor.count == 7) {
            let start = hexColor.index(hexColor.startIndex, offsetBy: 1)
            let hex = String(hexColor[start...])
            
            let r = Int(hex[hex.index(hex.startIndex, offsetBy: 0)..<hex.index(hex.startIndex, offsetBy: 2)], radix: 16)
            let g = Int(hex[hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)], radix: 16)
            let b = Int(hex[hex.index(hex.startIndex, offsetBy: 4)..<hex.index(hex.startIndex, offsetBy: 6)], radix: 16)
                        
            self.init(red: CGFloat(r!) / 255, green: CGFloat(g!) / 255, blue: CGFloat(b!) / 255, alpha: 1)
            return
        }
        
        return nil
    }
}
