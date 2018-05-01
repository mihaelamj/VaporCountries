# VaporCountries

Vapor package to add Country and Continent data to any database.

Usage (for MySQL) :

```swift
  migrations.add(migration: ContinentMigration<MySQLDatabase>.self, database: .mysql)
  migrations.add(migration: CountryMigration<MySQLDatabase>.self, database: .mysql)
  ```


Example project:
https://github.com/mihaelamj/TestVaporCountries
