import UIKit

class MUFile: NSObject {
    
    // MARK: - Get The Path

    /** 
     Get the path with app.
     File: "D" = "Document"; "L" = "Library"; "T" = "Temporary"; "C" = "Caches";
     Other or nil all is the NSHomeDirectory.
     */
    class func getPath(file: String?) -> String {
        if let _ = file {
            switch file! {
            case "D":
                return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
            case "L":
                return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
            case "T":
                var tmp = NSTemporaryDirectory()
                tmp.removeAtIndex(tmp.endIndex.predecessor())
                return tmp
            case "C":
                return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
            default: break
            }
        }
        return NSHomeDirectory()
    }
    
    // MARK: - Manage file.
    /**
     Create the directory.
     */
    class func createPath(path: String) -> Bool {
        if !path.isEmpty {
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(path) {
                return true
            }
            if let _ = try? fileManager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil) {
                return true
            }
        }
        return false
    }
    /**
     Create the file.
     */
    class func createFile(path: String, cover: Bool) -> Bool {
        if !path.isEmpty {
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(path) && !cover {
                return true
            }
            return fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        }
        return false
    }
    /**
     Remove the file.
     */
    class func removeFile(path: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        if let _ = try? fileManager.removeItemAtPath(path) {
            return true
        }
        return false
    }
    
    // MARK: - Archiver Operate
    
    /**
     Archiver objects use key:Object.
     */
    class func archiverObjects(objects:[String:AnyObject]) -> NSData {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        for (key, object) in objects {
            archiver.encodeObject(object, forKey: key)
        }
        archiver.finishEncoding()
        return data
    }
    /**
     ArchoverObject
     */
    class func archiverObject(object:AnyObject) -> NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(object)
    }
    
    /**
     UnarchoverObjects
     */
    class func unarchiverObjects(data data:NSData, keys:[String]) -> [String:AnyObject?] {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
        var objects = [String:AnyObject?]()
        for key in keys {
            objects[key] = unarchiver.decodeObjectForKey(key)
        }
        unarchiver.finishDecoding()
        return objects
    }
    
    /**
     UnarchoverObject
     */
    class func unarchiverObject(data data:NSData) -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(data)
    }

}