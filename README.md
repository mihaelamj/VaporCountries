# VaporCountries

Vapor package to add Country and Continent data to any database.

Import it into your project:
```
let package = Package(
    name: "TestVaporCountries",
    dependencies: [      
      //VaporCountries
        .package(url: "https://github.com/mihaelamj/VaporCountries.git", from: "0.0.4")
  ],
    targets: [
      .target(name: "App", dependencies: ["FluentSQLite", "FluentMySQL", "FluentPostgreSQL", "VaporCountries"]),
  ]
)

```

Usage (for MySQL) :

```swift
  migrations.add(migration: ContinentMigration<MySQLDatabase>.self, database: .mysql)
  migrations.add(migration: CountryMigration<MySQLDatabase>.self, database: .mysql)
  ```

 Usage (for PostgreSQL) : 
 ```swift
migrations.add(migration: ContinentMigration<PostgreSQLDatabase>.self, database: .psql)
migrations.add(migration: CountryMigration<PostgreSQLDatabase>.self, database: .psql)
 ```
 Usage (for SQLite) : 
 ```swift
migrations.add(migration: ContinentMigration<SQLiteDatabase>.self, database: .sqlite)
migrations.add(migration: CountryMigration<SQLiteDatabase>.self, database: .sqlite)
 ```

Example project:
https://github.com/mihaelamj/TestVaporCountries
