import UIKit
import CoreData

class MUCoreData: NSObject {
    
    static let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // MARK: - 新方法
    
    // MARK: - 插入，保存，删除数据操作。
    
    /** 根据数据表名称插入一行新数据，并返回它的NSManagedObject。 */
    class func insert(entityName name: String) -> NSManagedObject {
        let datas: NSManagedObject = NSEntityDescription.insertNewObjectForEntityForName(name, inManagedObjectContext: applicationDelegate.managedObjectContext)
        return datas
    }
    /** 保存数据 */
    class func save() {
        applicationDelegate.saveContext()
    }
    /** 删除数据 */
    class func deleteData(data: NSManagedObject) {
        applicationDelegate.managedObjectContext.deleteObject(data)
        applicationDelegate.saveContext()
    }
    
    // MARK: - 查询操作
    
    /**按特定的顺序，对某一组数据分类汇总后输出。
     name: 数据表名称。
     predicate: 查询条件语句。
     sortsArray: [(排序列名称, 正序倒叙)]。
     group: 查询结果的分组名称。
    例如：
     let datas = findDatas(name: "DataBase", predicate: "id >= 0", sortsArray: [("id", true)], group: "name")
     let str = datas?.valueForKeyPath("notesName") as? [String]
     datas = 在DataBase中，id列大于0的数据，按照id列正序排列，并根据name列进行分类汇总后，输出一个包含字典的数组，字典中只有name一个Key值。如：[{name="***"},{name="***"}]
     str = datas的结果数组，如：["***","***"]
    */
    class func findDatas(name: String, predicate: String, sortsArray: [(String, Bool)], group: String) -> NSArray? {
        
        let request: NSFetchRequest = NSFetchRequest(entityName: name)
        
        var sorts: [NSSortDescriptor] = []
        for sort in sortsArray {
            let fetchSort: NSSortDescriptor = NSSortDescriptor(key: sort.0, ascending: sort.1)
            sorts.append(fetchSort)
        }
        request.sortDescriptors = sorts
        
        request.predicate = NSPredicate(format: predicate)
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        
        request.propertiesToFetch = [group]
        request.propertiesToGroupBy = [group]
        
        return try? applicationDelegate.managedObjectContext.executeFetchRequest(request)
    }
    
    /** 按predicate的查询条件，以sortsArray的排行顺序进行查询，输出结果为数据库指针。 */
    class func findDatas(name: String, predicate: String, sortsArray: [(String, Bool)]) -> NSArray? {
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let request: NSFetchRequest = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(name, inManagedObjectContext: applicationDelegate.managedObjectContext)
        let predicate: NSPredicate = NSPredicate(format: predicate)
        request.predicate = predicate
        
        var sorts: [NSSortDescriptor] = []
        for sort in sortsArray {
            let fetchSort: NSSortDescriptor = NSSortDescriptor(key: sort.0, ascending: sort.1)
            sorts.append(fetchSort)
        }
        request.sortDescriptors = sorts
        
        return try? applicationDelegate.managedObjectContext.executeFetchRequest(request)
    }
    
    /** 按predicate的查询条件，以sortsArray的排行顺序进行查询，输出结果为按offset偏移后limit条数的数据库指针。 */
    class func findDatas(name: String, sortsArray: [(String, Bool)], limit: Int, offset: Int) -> NSArray? {
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let request: NSFetchRequest = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(name, inManagedObjectContext: applicationDelegate.managedObjectContext)
        
        var sorts: [NSSortDescriptor] = []
        for sort in sortsArray {
            let fetchSort: NSSortDescriptor = NSSortDescriptor(key: sort.0, ascending: sort.1)
            sorts.append(fetchSort)
        }
        request.sortDescriptors = sorts
        
        request.fetchLimit = limit
        request.fetchOffset = offset
        return try? applicationDelegate.managedObjectContext.executeFetchRequest(request)
    }

    
    
    
    
    
    
    
    
    
    // --------------------------------------------------
    // MARK: - 旧方法
    
        // MARK: 查询数据
    class func findDatas(entityName name: String, sortAndAscending: [(String, Bool)]) -> NSArray? {
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let request: NSFetchRequest = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(name, inManagedObjectContext: applicationDelegate.managedObjectContext)
        
        var sorts: [NSSortDescriptor] = []
        for sort in sortAndAscending {
            let fetchSort: NSSortDescriptor = NSSortDescriptor(key: sort.0, ascending: sort.1)
            sorts.append(fetchSort)
        }
        request.sortDescriptors = sorts
        return try? applicationDelegate.managedObjectContext.executeFetchRequest(request)
    }
    
    class func findDatas(entityName name: String, predicateString: String) -> NSArray? {
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let request: NSFetchRequest = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(name, inManagedObjectContext: applicationDelegate.managedObjectContext)
        let predicate: NSPredicate = NSPredicate(format: predicateString)
        request.predicate = predicate
        return try? applicationDelegate.managedObjectContext.executeFetchRequest(request)
    }
    
    class func findDatasWithPage(entityName name: String, sortAndAscending: [(String, Bool)], limit: Int, offset: Int) -> NSArray? {
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let request: NSFetchRequest = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(name, inManagedObjectContext: applicationDelegate.managedObjectContext)
        
        var sorts: [NSSortDescriptor] = []
        for sort in sortAndAscending {
            let fetchSort: NSSortDescriptor = NSSortDescriptor(key: sort.0, ascending: sort.1)
            sorts.append(fetchSort)
        }
        request.sortDescriptors = sorts
        
        request.fetchLimit = limit
        request.fetchOffset = offset
        return try? applicationDelegate.managedObjectContext.executeFetchRequest(request)
    }
    class func findDatasWithPage(entityName name: String, predicateString: String, sortAndAscending: [(String, Bool)], limit: Int, offset: Int) -> NSArray? {
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let request: NSFetchRequest = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(name, inManagedObjectContext: applicationDelegate.managedObjectContext)
        let predicate: NSPredicate = NSPredicate(format: predicateString)
        request.predicate = predicate
        
        var sorts: [NSSortDescriptor] = []
        for sort in sortAndAscending {
            let fetchSort: NSSortDescriptor = NSSortDescriptor(key: sort.0, ascending: sort.1)
            sorts.append(fetchSort)
        }
        request.sortDescriptors = sorts
        
        request.fetchLimit = limit
        request.fetchOffset = offset
        return try? applicationDelegate.managedObjectContext.executeFetchRequest(request)
    }
    
    // MARK: - 单一字段查询
    /** let expressionDescription = NSExpressionDescription()
    expressionDescription.name = "longCount"
    expressionDescription.expression = NSExpression(format: "@sum.long")
    expressionDescription.expressionResultType = .Integer64AttributeType */
    class func findDatasWithGroup(name: String, predicate: String, groups: [String], expressions: [AnyObject]) -> NSArray? {
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let request: NSFetchRequest = NSFetchRequest(entityName: "DataEntity")
        
        request.predicate = NSPredicate(format: predicate)
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        
        var expression = [AnyObject]()
        
        for group in groups {
            expression.append(group)
        }
        for express in expressions {
            expression.append(express)
        }
        
        request.propertiesToFetch = expression
        request.propertiesToGroupBy = groups
        
        return try? applicationDelegate.managedObjectContext.executeFetchRequest(request)
    }
    
    class func findDatasWithGroup(name: String, groups: [String], expressions: [AnyObject]) -> NSArray? {
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let request: NSFetchRequest = NSFetchRequest(entityName: "DataEntity")
        
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        
        var expression = [AnyObject]()
        
        for group in groups {
            expression.append(group)
        }
        for express in expressions {
            expression.append(express)
        }
        
        request.propertiesToFetch = expression
        request.propertiesToGroupBy = groups
        
        return try? applicationDelegate.managedObjectContext.executeFetchRequest(request)
    }
    
    /** 创建数据库表列名称。 */
    class func expression(name: String, expression: String, type: NSAttributeType) -> NSExpressionDescription {
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = name
        expressionDescription.expression = NSExpression(format: expression)
        expressionDescription.expressionResultType = type
        return expressionDescription
    }
    
    /** 根据条件从数据库中进行查找，找到结果之后，提取groupName列的内容单独输出一个字典数组。*/
    class func findDatasWithName(name: String, predicateString: String, groupName: String) -> NSArray? {
        let applicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let request: NSFetchRequest = NSFetchRequest(entityName: name)
        
        request.predicate = NSPredicate(format: predicateString)
        request.resultType = NSFetchRequestResultType.DictionaryResultType
        
        request.propertiesToFetch = [groupName]
        request.propertiesToGroupBy = [groupName]
        
        return try? applicationDelegate.managedObjectContext.executeFetchRequest(request)
    }
    
    
    
}
