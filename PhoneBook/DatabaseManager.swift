//
//  DatabaseManager.swift
//  PhoneBook
//
//  Created by Radik Nuriev on 25.04.2022.
//

import GRDB
import UIKit


protocol IDatabaseManager {
    func insertData(data: [Person])
    
    static func setup(for application: UIApplication) throws
    
    func ifTableExists() throws -> Bool
    
    func fetchData() throws -> [Person]
}

var dbQueue: DatabaseQueue!
let tableName = "person"

class DatabaseManager: IDatabaseManager {
    static func setup(for application: UIApplication) throws {
            let databaseURL = try FileManager.default
            .url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("db3.sqlite")

            dbQueue = try DatabaseQueue(path: databaseURL.path)
            try migrator.migrate(dbQueue)
        }
    
    static var migrator: DatabaseMigrator {
            var migrator = DatabaseMigrator()

            migrator.registerMigration("person") { db in
                try db.create(table: tableName) { t in
                    t.column("id", .text).primaryKey()
                    t.column("name", .text).notNull()
                    t.column("phone", .text).notNull()
                    t.column("height", .numeric).notNull()
                    t.column("biography", .numeric).notNull()
                    t.column("temperament", .integer)
                    t.column("educationStart", .date)
                    t.column("educationEnd", .date)
                }
            }

            return migrator
        }
    
    func ifTableExists() throws -> Bool {
        try dbQueue.read{ db in
            try db.tableExists(tableName)
        }
    }
    
    func fetchData() throws -> [Person] {
        try dbQueue.read{db in
            return try Person.fetchAll(db)
        }
    }
    
    func insertData(data: [Person]){
        do {
            try dbQueue.write{ db in
                do {
                    try Person.deleteAll(db)
                } catch {
                }
                data.forEach{ person in
                    try! person.insert(db)
                }
            }
        } catch {
            debugPrint(error)
        }
    }
}
