import UIKit
// 未完成……谁用谁知道……
class MUSQLite: NSObject {
    
    var sqlite: COpaquePointer = nil
    /**
     Create Sqlite file in path.
     */
    func create(name: String, path: String, cover: Bool) -> String? {
        let address = path + "/" + name + ".sqlite"
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(address) && !cover {
            return address
        }
        return fileManager.createFileAtPath(address, contents: nil, attributes: nil) ? address : nil
    }
    /**
     Open sqlite.
     */
    func open(path: String) -> Bool {
        if sqlite3_open(path, &sqlite) == SQLITE_OK {
            return true
        } else {
            sqlite3_close(sqlite)
            return false
        }
    }
    /**
     Close sqlite.
     */
    func close() -> Bool {
        if sqlite3_close(sqlite) == SQLITE_OK {
            return true
        } else {
            sqlite3_close(sqlite)
            return false
        }
    }
    /**
     Create table.
     */
    func createTable(table: String, columns: [(name: String, type: String)]) -> Bool {
        var str = "create table if not exists \(table) (id integer primary key autoincrement"
        for column in columns {
            str += ",\(column.name) \(column.type)"
        }
        str += ")"
        return sqlite3_exec(sqlite, str, nil, nil, nil) == SQLITE_OK
    }
    
    
    // MARK: Class func.
    /**
     Create Sqlite file in path.
     */
    class func createSqlite(name: String, path: String, cover: Bool) -> String? {
        let address = path + "/" + name + ".sqlite"
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(address) && !cover {
            return address
        }
        return fileManager.createFileAtPath(address, contents: nil, attributes: nil) ? address : nil
    }
    /**
     Open sqlite.
     */
    class func openSqlite(path: String) -> COpaquePointer? {
        var database:COpaquePointer = nil
        if sqlite3_open(path, &database) == SQLITE_OK {
            return database
        } else {
            sqlite3_close(database)
            return nil
        }
    }
    /**
     Close sqlite.
     */
    class func closeSqlite(database: COpaquePointer) -> Bool {
        // 关闭数据库之前还有某些没有完成的（nonfinalized）SQL语句，那么sqlite3_close函数将会返回SQLITE_BUSY错误。客户程序员需要finalize所有的预处理语句（prepared statement）之后再次调用sqlite3_close。
        return sqlite3_close(database) == SQLITE_OK ? true : false
    }
    
}
