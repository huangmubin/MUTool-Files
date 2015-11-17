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
}

// MARK: - Singleton pattern
/*
class func shareInstance() -> ClassName { // Change here!
    struct SingletonStruct {
        static var predicate: dispatch_once_t = 0
        static var instance: ClassName? = nil // Change here!
    }
    dispatch_once(&SingletonStruct.predicate, {
        SingletonStruct.instance = ClassName() // Change here!
        }
    )
    return SingletonStruct.instance!
}
*/