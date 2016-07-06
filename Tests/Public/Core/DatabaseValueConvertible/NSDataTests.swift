import XCTest
#if USING_SQLCIPHER
    import GRDBCipher
#elseif USING_CUSTOMSQLITE
    import GRDBCustomSQLite
#else
    import GRDB
#endif

class NSDataTests: GRDBTestCase {
    
    func testDatabaseValueCanNotStoreEmptyData() {
        // SQLite can't store zero-length blob.
        let databaseValue = NSData().databaseValue
        XCTAssertEqual(databaseValue, DatabaseValue.Null)
    }
    
    func testNSDataDatabaseValueRoundTrip() {
        
        func roundTrip(value: NSData) -> Bool
        {
            let databaseValue = value.databaseValue
            guard let back = NSData.fromDatabaseValue(databaseValue) else
            {
                XCTFail("Failed to convert from DatabaseValue to NSData")
                return false
            }
            return back.isEqual(value)
        }
        
        XCTAssertTrue(roundTrip("bar".dataUsingEncoding(NSUTF8StringEncoding)!))
    }
    
    func testNSDataFromDatabaseValueFailure() {
        let databaseValue_Null = DatabaseValue.Null
        let databaseValue_Int64 = Int64(1).databaseValue
        let databaseValue_Double = Double(100000.1).databaseValue
        let databaseValue_String = "foo".databaseValue
        XCTAssertNil(NSData.fromDatabaseValue(databaseValue_Null))
        XCTAssertNil(NSData.fromDatabaseValue(databaseValue_Int64))
        XCTAssertNil(NSData.fromDatabaseValue(databaseValue_Double))
        XCTAssertNil(NSData.fromDatabaseValue(databaseValue_String))
    }
}