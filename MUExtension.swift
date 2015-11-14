import UIKit

// MARK: - UIAlertController Extension

extension UIAlertController {
    
    // MARK: Create Alert
    
    class func createSheet(title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
    }
    class func createSheet(title: String?) -> UIAlertController {
        return createSheet(title, message: nil)
    }
    class func createSheet() -> UIAlertController {
        return createSheet(nil, message: nil)
    }
    class func createAlert(title: String?, message: String?, cancelTitle: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(cancelTitle, style: UIAlertActionStyle.Cancel, handler: nil)
        return alert
    }
    class func createAlert(title: String?, message: String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    }
    class func createAlert(title: String?) -> UIAlertController {
        return createAlert(title, message: nil)
    }
    class func createAlert() -> UIAlertController {
        return createAlert(nil, message: nil)
    }
    
    
    // MARK: Set Actions
    
    func addAction(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?) {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
    }
    func addActions(titles: [String], handler: ((UIAlertAction) -> Void)?) {
        for actionTitle in titles {
            let action = UIAlertAction(title: actionTitle, style: UIAlertActionStyle.Default, handler: handler)
            self.addAction(action)
        }
    }
}
