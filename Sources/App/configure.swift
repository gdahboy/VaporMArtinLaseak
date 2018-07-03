import Vapor
import Leaf
import FluentSQLite

public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    let myService = NIOServerConfig.default(port: 8010)
    services.register(myService)

    try services.register(LeafProvider())
    try services.register(FluentSQLiteProvider())

    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    var databases = DatabasesConfig()
    try databases.add(database: SQLiteDatabase(storage: .memory), as: .sqlite)
    services.register(databases)

    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .sqlite)
    migrations.add(model: Pokemon.self, database: .sqlite)
    services.register(migrations)
}
