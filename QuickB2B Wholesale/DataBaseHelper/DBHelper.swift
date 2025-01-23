//
//  DBHelper.swift
//  QuickB2BWholesale
//
//  Created by braintech on 20/07/21.
//

import UIKit

import SQLite3


class DBHelper
{
    private let TABLE_FILE = "table_suppliers"

    private let KEY_FILE_ID = "file_id"
    private let keyClientCode = "client_code"
    private let keySupplierName = "supplier_name"
    private let keyUserCode = "user_code"
    
    init() {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "create table if not exists \(TABLE_FILE) (\(KEY_FILE_ID) integer primary key autoincrement, \(keyClientCode) text,\(keySupplierName) text,\(keyUserCode) text);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("supplier table created.")
            } else {
                print("supplier table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(strClientCode:String, strSupplierName:String, strUserCode:String)
    {
        let insertStatementString = "INSERT INTO table_suppliers (\(keyClientCode), \(keySupplierName), \(keyUserCode)) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (strClientCode as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (strSupplierName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (strUserCode as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func readData()->[[String:Any]] {
        let queryStatementString = "SELECT * FROM table_suppliers;"
        var queryStatement: OpaquePointer? = nil
        var arrData = [[String:Any]]()
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                var dictData = [String:Any]()
                let strSheetId = String(describing: String(cString: sqlite3_column_text(queryStatement, 0)))
                let strClientCode = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let strSupplierName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let strUserCode = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                dictData["file_id"] = strSheetId
                dictData["client_code"] = strClientCode
                dictData["supplier_name"] = strSupplierName
                dictData["user_code"] = strUserCode
                arrData.append(dictData)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return arrData
    }
    
    
    func updateData(strClientCodee:String,strUserCode:String,strSupplierName:String){
        let updateStatementString = "UPDATE table_suppliers SET supplier_name='\(strSupplierName)',user_code='\(strUserCode)' WHERE client_code='\(strClientCodee)'"
         var updateStatement: OpaquePointer? = nil
         if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                       print("Successfully updated row.")
                } else {
                       print("Could not update row.")
                }
              } else {
                    print("UPDATE statement could not be prepared")
              }
              sqlite3_finalize(updateStatement)
    }
    
    func isAlreadyInSupplier(strClientCodee:String)->Bool {
        
        let queryStatementString = "SELECT * FROM table_suppliers;"
        var queryStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let strClientCode = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                if(strClientCode == strClientCodee){
                    sqlite3_finalize(queryStatement)
                    return true
                }
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return false
    }
    
    func deleteByClientCode(strClientCode:String) {
        let deleteStatementStirng = "DELETE FROM table_suppliers WHERE  \(keyClientCode) = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(deleteStatement, 1, (strClientCode as NSString).utf8String, -1, nil)
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
}
