import FluentSQLite
import Vapor

final class Pokemon: SQLiteModel {
    var id: Int?
    var name: String
    var level: Int
    var userID: User.ID
    init(
        id: Int? = nil,
        name: String,
        level: Int,
        userID: User.ID
    ) {
        self.id = id
        self.name = name
        self.level = level
        self.userID = userID
    }

    struct PokemonForm: Content {
        var name: String
        var level: Int
        var userId: Int
    }
}

extension Pokemon: Migration {}

extension Pokemon {
    var user: Parent<Pokemon, User> {
        return parent(\.userID)
    }
}
