import UIKit

extension String {
    func toDate() -> String {
        let dateFormatter = DateFormatter()
        let indexes = self.index(self.startIndex, offsetBy: 16)
        let formattedDate = String(self.prefix(upTo: indexes))
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        guard let date = dateFormatter.date(from: formattedDate) else {
          return "Error"
        }
        dateFormatter.dateFormat = "dd MMM y HH:mm"
        let newDate = dateFormatter.string(from: date)
        return newDate
    }
    
    func getCountryName() -> String {
        let identifier = NSLocale(localeIdentifier: self)
        let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: self)
        guard let country = countryName else { return "" }
        return country
    }
    
    func getTextHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil)
        return boundingBox.height
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
