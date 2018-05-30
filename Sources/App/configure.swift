import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentMySQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    
    let password = "password"
    let mysqlConfig = MySQLDatabaseConfig(hostname: "localhost", port: 3306, username: "att", password: password, database: "vapor")
    services.register(mysqlConfig)
    
    // Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    let database = MySQLDatabase(config: mysqlConfig)
    databases.add(database: database, as: .mysql)
    services.register(databases)

    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Course.self, database: .mysql)
    migrations.add(model: Student.self, database: .mysql)
    services.register(migrations)

}
