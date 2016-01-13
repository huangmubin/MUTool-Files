import UIKit

// MARK: - UIView Extension

extension UIView {
    
    // MARK: Create Layout Contraint
    
    /** 设置translatesAutoresizingMaskIntoConstraints为false，否则自动布局将无法生效。 */
    func anchor() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /** 设置该视图单一尺寸约束 */
    func anchorSize(attribute: NSLayoutAttribute, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: attribute, multiplier: 1, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    /** 设置该视图长宽约束 */
    func anchorSize(width: CGFloat, height: CGFloat) -> (width: NSLayoutConstraint, height: NSLayoutConstraint) {
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: width)
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: height)
        self.addConstraints([widthConstraint, heightConstraint])
        return (widthConstraint, heightConstraint)
    }
    
    /** 设置两视图的某一边对齐 */
    func anchorSingle(view1: UIView, attribute1: NSLayoutAttribute, view2: UIView, attribute2: NSLayoutAttribute, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: view1, attribute: attribute1, relatedBy: .Equal, toItem: view2, attribute: attribute2, multiplier: 1, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
    /** 设置两视图的某一边对齐 */
    func anchorSingle(view: UIView, attribute: NSLayoutAttribute, constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .Equal, toItem: view, attribute: attribute, multiplier: 1, constant: constant)
        self.addConstraint(constraint)
        return constraint
    }
    
}

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
