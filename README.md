# VaporCountries

Vapor package to add Country and Continent data to any database.

Import it into your project:
```
let package = Package(
    name: "TestVaporCountries",
    dependencies: [      
      //VaporCountries
        .package(url: "https://github.com/mihaelamj/VaporCountries.git", from: "0.1.0")
  ],
    targets: [
      .target(name: "App", dependencies: ["FluentSQLite", "FluentMySQL", "FluentPostgreSQL", "VaporCountries"]),
  ]
)

```

Usage (for MySQL) :

```swift
import VaporCountries

// in configure.swift
migrations.addVaporCountries(for: .mysql)

//in routes.swift
try addVaporCountriesRoutes(for: .mysql, router: router)
  ```

 Usage (for PostgreSQL) : 

```swift
import VaporCountries

// in configure.swift
migrations.addVaporCountries(for: .psql)

//in routes.swift
try addVaporCountriesRoutes(for: .psql, router: router)
  ```
 Usage (for SQLite) : 
 ```swift
import VaporCountries

// in configure.swift
migrations.addVaporCountries(for: .sqlite)

//in routes.swift
try addVaporCountriesRoutes(for: .sqlite, router: router)
 ```

Example project:
https://github.com/mihaelamj/TestVaporCountries

Tutorial article on making a new Vapor Package
https://mihaelamj.github.io/Making%20a%20New%20Vapor%20Package/
