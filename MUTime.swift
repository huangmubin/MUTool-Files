import UIKit

class MUTime {
    // MARK: - 日期转化
    // MARK: 时间戳转化
    
    class func timestampToDate(timestamp: Int) -> NSDate {
        return NSDate(timeIntervalSince1970: Double(timestamp))
    }
    class func timestampToString(timestamp: Int, format: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(timestampToDate(timestamp))
    }
    
    // MARK: 日期转化
    class func dateToTimestamp(date: NSDate) -> Int {
        return Int(date.timeIntervalSince1970)
    }
    class func dateToString(date: NSDate, format: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(date)
    }
    
    // MARK: 字符串转化
    class func stringToTimestamp(string: String, format: String) -> Int? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        if let timestamp = formatter.dateFromString(string)?.timeIntervalSince1970 {
            return Int(timestamp)
        } else {
            return nil
        }
    }
    class func stringToDate(string: String, format: String) -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(string)
    }
    class func dateZone(date: NSDate) -> NSDate {
        var dateTime = MUTime.dateToTimestamp(date)
        dateTime = dateTime - (dateTime % 86400)
        return MUTime.timestampToDate(dateTime)
    }
    // MARK: - 日期运算
    class func advanceTime(advance: NSTimeInterval, date: NSDate) -> NSDate {
        return NSDate(timeInterval: advance, sinceDate: date)
    }
    class func advanceTime(advance: NSTimeInterval, date: String) -> String {
        let time = stringToTimestamp(date, format: "yyyy-MM-dd HH:mm")! + Int(advance)
        return timestampToString(time, format: "yyyy-MM-dd HH:mm")
    }
}