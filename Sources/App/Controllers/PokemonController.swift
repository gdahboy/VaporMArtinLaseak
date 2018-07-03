import Vapor

final class PokemonController {
    func create(_ req: Request) throws -> Future<Response> {
        return try req.content
            .decode(Pokemon.PokemonForm.self)
            .flatMap { pokemonForm in
                return User
                    .find(pokemonForm.userId, on: req)
                    .flatMap { user in
                        guard let userId = try user?.requireID() else {
                            throw Abort(.badRequest)
                        }
                        let pokemon = Pokemon(
                            name: pokemonForm.name,
                            level: pokemonForm.level,
                            userID: userId
                        )
                        return pokemon.save(on: req).map { _ in
                            return req.redirect(to: "/users")
                        }
                }
        }
    }
}
