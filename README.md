# VaporCountries

Vapor package to add Country and Continent data to any database.

Usage :

```swift
  migrations.add(migration: ContinentMigration<MySQLDatabase>.self, database: .mysql)
  migrations.add(migration: CountryMigration<MySQLDatabase>.self, database: .mysql)
  ```

