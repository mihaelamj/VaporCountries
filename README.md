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
//configure database
  Continent<MySQLDatabase>.defaultDatabase = .mysql
  Country<MySQLDatabase>.defaultDatabase = .mysql
  //configure migrations
  migrations.add(migration: ContinentMigration<MySQLDatabase>.self, database: .mysql)
  migrations.add(migration: CountryMigration<MySQLDatabase>.self, database: .mysql)
  ```

 Usage (for PostgreSQL) : 
 ```swift
 //configure database
Continent<PostgreSQLDatabase>.defaultDatabase = .psql
Country<PostgreSQLDatabase>.defaultDatabase = .psql
//configure migrations
migrations.add(migration: ContinentMigration<PostgreSQLDatabase>.self, database: .psql)
migrations.add(migration: CountryMigration<PostgreSQLDatabase>.self, database: .psql)
 ```
 Usage (for SQLite) : 
 ```swift
 //configure database
Continent<SQLiteDatabase>.defaultDatabase = .sqlite
Country<SQLiteDatabase>.defaultDatabase = .sqlite
//configure migrations
migrations.add(migration: ContinentMigration<SQLiteDatabase>.self, database: .sqlite)
migrations.add(migration: CountryMigration<SQLiteDatabase>.self, database: .sqlite)
 ```

Example project:
https://github.com/mihaelamj/TestVaporCountries

Tutorial article on making a new Vapor Package
https://mihaelamj.github.io/Making%20a%20New%20Vapor%20Package/
