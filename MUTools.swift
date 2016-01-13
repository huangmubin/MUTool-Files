import UIKit

class MUTools: NSObject {
    
    // MARK: - String Size
    
    class func sizeForString(str: String, width: CGFloat, options: NSStringDrawingOptions, attributes: [String:AnyObject]) -> CGSize {
        let size = CGSizeMake(width, CGFloat.max)
        let rect = NSString(string: str).boundingRectWithSize(size, options: options, attributes: attributes, context: nil)
        return rect.size
    }
    class func sizeForString(str: String, font: UIFont) -> CGSize {
        let options = unsafeBitCast(NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue | NSStringDrawingOptions.UsesFontLeading.rawValue, NSStringDrawingOptions.self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        let attributes:[String:AnyObject] = [NSFontAttributeName: font, NSParagraphStyleAttributeName:paragraphStyle]
        return sizeForString(str, width: UIScreen.mainScreen().bounds
            .width, options: options, attributes: attributes)
    }
    class func sizeForString(str: String, width: CGFloat) -> CGSize {
        let options = unsafeBitCast(NSStringDrawingOptions.UsesLineFragmentOrigin.rawValue | NSStringDrawingOptions.UsesFontLeading.rawValue, NSStringDrawingOptions.self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        let attributes:[String:AnyObject] = [NSFontAttributeName: UIFont.systemFontOfSize(17.0)]
        return sizeForString(str, width: width, options: options, attributes: attributes)
    }
    
    
    // MARK: - String Search
    
    /** 检查字段中哪个部分是检索内容。返回渲染后的字符串以及搜索结果次数 */
    class func searchText(note: String, searchStr: String, strColor: UIColor, findColor: UIColor) -> (NSMutableAttributedString, Int) {
        let lenght = note.characters.count
        let nsNote = NSString(string: note)
        let string = NSMutableAttributedString(string: note, attributes: [NSForegroundColorAttributeName: strColor])
        var time = 0
        var checkLenght = 0
        while checkLenght < lenght {
            let range = nsNote.rangeOfString(searchStr, options: .CaseInsensitiveSearch, range: NSMakeRange(checkLenght, lenght - checkLenght))
            if range.length == 0 {
                checkLenght = lenght
            } else {
                time++
                checkLenght = range.location + range.length
                string.addAttribute(NSForegroundColorAttributeName, value: findColor, range: range)
            }
        }
        
        return (string, time)
    }
    
}

// MARK: - Singleton pattern
/*
class TheOneAndOnlyKraken {
    static let sharedInstance = TheOneAndOnlyKraken()
}
*/