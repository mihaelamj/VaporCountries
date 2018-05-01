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


Example project:
https://github.com/mihaelamj/TestVaporCountries
