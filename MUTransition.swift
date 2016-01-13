import UIKit

enum Direction {
    case Top
    case Down
    case Left
    case Right
}

/** Transitioning转场动画。
    可以按方向进行变动，也可以按透明度。
    */
class MUTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    // MARK: - 属性接口
    
    /** 动画滑动方向。 */
    var direction: Direction
    /** 动画持续时间。 */
    var time: NSTimeInterval
    /** 动画类型，默认是滑动，该值设置为ture则是透明度。 */
    var typsIsAlpha: Bool
    /** 动画弹性阻尼 */
    var damping: CGFloat
    /** 动画启动速度 */
    var velocity: CGFloat
    /** 动画曲线类型 */
    var options: UIViewAnimationOptions
    /** 交互动画类型 */
    var interact: Bool
     
    // MARK: - 初始化
    
    
    init(direction: Direction, time: NSTimeInterval, typsIsAlpha: Bool, damping: CGFloat, velocity: CGFloat, options: UIViewAnimationOptions, interact: Bool) {
        self.direction   = direction
        self.time        = time
        self.typsIsAlpha = typsIsAlpha
        self.damping     = damping
        self.velocity    = velocity
        self.options     = options
        self.interact    = interact
    }
    convenience init(typsIsAlpha: Bool) {
        self.init(direction: Direction.Left, time: 0.5, typsIsAlpha: typsIsAlpha, damping: 1, velocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, interact: false)
    }
    convenience init(typsIsAlpha: Bool, time: NSTimeInterval) {
        self.init(direction: Direction.Left, time: time, typsIsAlpha: typsIsAlpha, damping: 1, velocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, interact: false)
    }
    convenience init(direction: Direction) {
        self.init(direction: direction, time: 0.5, typsIsAlpha: false, damping: 1, velocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, interact: false)
    }
    convenience init(direction: Direction, interact: Bool) {
        self.init(direction: direction, time: 0.5, typsIsAlpha: false, damping: 1, velocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, interact: interact)
    }
    
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    var fromViewController: UIViewController?
    var toViewController:   UIViewController?
    var container: UIView?
    var context: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return time
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // 获取ViewController以及动画容器
        fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        toViewController   = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        container = transitionContext.containerView()
        context = transitionContext
        
        // 把控制器的视图添加到动画容器中
        container?.addSubview(fromViewController!.view)
        container?.addSubview(toViewController!.view)
        
        // 根据视图类型调用对应动画
        switch (typsIsAlpha, interact) {
        case (true, false):
            alphaAnimation()
        case (true, true):
            alphaAnimation()
        case (false, true):
            transitionAnimationInteract()
        case (false, false):
            transitionAnimation()
        }
    }
    
    // MARK: Animation
    
    func alphaAnimation() {
        toViewController?.view.alpha = 0
        
        UIView.animateWithDuration(transitionDuration(context), delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: { () -> Void in
                self.toViewController?.view.alpha   = 1
            }) { (finish) -> Void in
                self.context!.completeTransition(!self.context!.transitionWasCancelled())
        }
    }
    
    func transitionAnimation() {
        let rect = countRect()
        
        toViewController?.view.frame = rect.2
        
        UIView.animateWithDuration(transitionDuration(context), delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: { () -> Void in
            self.fromViewController?.view.frame = rect.0
            self.toViewController?.view.frame   = rect.1
            }) { (finish) -> Void in
                self.fromViewController?.view.frame = rect.1
                self.context!.completeTransition(!self.context!.transitionWasCancelled())
        }
    }
    
    func transitionAnimationInteract() {
        let rect = countRect()
        
        toViewController?.view.frame = rect.2
        
        UIView.beginAnimations("move", context: nil)
        UIView.setAnimationDuration(transitionDuration(context))
        UIView.setAnimationDelegate(self)
        UIView.setAnimationCurve(UIViewAnimationCurve.Linear)
        
        self.fromViewController?.view.frame = rect.0
        self.toViewController?.view.frame   = rect.1
        
        UIView.commitAnimations()
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.fromViewController?.view.frame = UIScreen.mainScreen().bounds
        self.context!.completeTransition(!self.context!.transitionWasCancelled())
    }
    
    // MARK: Tool
    
    /** 计算滑动位置。 */
    func countRect() -> (CGRect, CGRect, CGRect) {
        let rect  = CGRect(origin: CGPointZero, size: UIScreen.mainScreen().bounds.size)
        var x1: CGFloat = 0
        var x2: CGFloat = 0
        var y1: CGFloat = 0
        var y2: CGFloat = 0
        switch direction {
        case .Top:
            y1 = -rect.height
            y2 = rect.height
        case .Down:
            y1 = rect.height
            y2 = -rect.height
        case .Left:
            x1 = -rect.width
            x2 = rect.width
        case .Right:
            x1 = rect.width
            x2 = -rect.width
        }
        let befor  = CGRect(x: x1, y: y1, width: rect.width, height: rect.height)
        let behind = CGRect(x: x2, y: y2, width: rect.width, height: rect.height)
        return (befor, rect, behind)
    }

}

/*
1. 继承UINavigationControllerDelegate
2. 在viewDidAppear中设置navigationController的代理
    self.navigationController?.delegate = self
3. 如果是直接变化则实现UINavigationControllerDelegate的两个方法之一。
    并在其中判断Push Pop。
4. 如果是拖动的。则两方法都要实现。
    并要设置一个UIPercentDrivenInteractiveTransition类型的值。从0~1的百分比。
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
5. 结束时，要调用它的两个方法之一。
    动画完成
    self.percentDrivenTransition?.finishInteractiveTransition()
    动画取消
    self.percentDrivenTransition?.cancelInteractiveTransition()


class AViewController: UIViewController, UINavigationControllerDelegate {
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.Push {
            return MUTransition(direction: Direction.Top)
        } else {
            return nil
        }
    }
    @IBAction func action(sender: AnyObject) {
        self.performSegueWithIdentifier("Segue", sender: nil)
    }
}

--------------------------------------------
class BViewController: UIViewController, UINavigationControllerDelegate {
    
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
    }
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.Pop {
            return MUTransition(direction: Direction.Down)
        } else {
            return nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is MUTransition {
            return self.percentDrivenTransition
        } else {
            return nil
        }
    }
    
    @IBAction func action(sender: UIScreenEdgePanGestureRecognizer) {
        let progress = sender.translationInView(self.view).x / self.view.bounds.width
        print(progress)
        if sender.state == UIGestureRecognizerState.Began {
            self.percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
        } else if sender.state == UIGestureRecognizerState.Changed {
            self.percentDrivenTransition?.updateInteractiveTransition(progress)
        } else if sender.state == UIGestureRecognizerState.Cancelled || sender.state == UIGestureRecognizerState.Ended {
            if progress > 0.5 {
                self.percentDrivenTransition?.finishInteractiveTransition()
            } else {
                self.percentDrivenTransition?.cancelInteractiveTransition()
            }
            self.percentDrivenTransition = nil
        }
    }
}
*/