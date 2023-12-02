//
//  SQLDatabaseManager.swift
//  teamhungary
//
//  Created by Sophia Horng on 12/1/23.
//

import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()

    private var db: Connection?

    private init() {
        do {
            // Initialize the SQLite database connection
            let path = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("your_database.sqlite3")
                .path

            db = try Connection(path)

                // Call methods to create tables or perform any other setup
            try createTables()
        } catch {
            print("Error initializing database: \(error)")
        }
    }

    private func createTables() throws {
        // Implement table creation logic here
        let users = Table("users")
        let id = Expression<Int>("id")
        let name = Expression<String>("name")
        let email = Expression<String>("email")
        let gradyear = Expression<String>("graduation_year")
        let school = Expression<String>("school")
        let iguser = Expression<String>("instagram_username")
        let pfPicPath = Expression<String?>("profile_picture_path")

        try db?.run(users.create { table in
            table.column(id, primaryKey: .autoincrement)
            table.column(name)
            table.column(email, unique: true)
            table.column(gradyear, check: gradyear.like("20[2-9][0-9]"))
            table.column(school)
            table.column(iguser)
            table.column(pfPicPath)
        })
    }
}
