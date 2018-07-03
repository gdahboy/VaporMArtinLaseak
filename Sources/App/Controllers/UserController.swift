import Vapor

final class UserController {

    func list(_ req: Request) throws -> Future<View> {
        let allUsers = User.query(on: req).all()
        return allUsers.flatMap { users in
            let userViewList = try users.map { user in
                return UserView(
                    user: user,
                    pokemons: try user.pokemons.query(on: req).all()
                )
            }
            let data = ["userViewlist": userViewList]
            return try req.view().render("crud", data)
        }
    }

    func create(_ req: Request) throws -> Future<Response> {
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req).map { _ in
                return req.redirect(to: "/users")
            }
        }
    }

    func update(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(User.self).flatMap { user in
            return try req.content.decode(UserForm.self).flatMap { userForm in
                user.username = userForm.username
                return user.save(on: req).map { _ in
                    return req.redirect(to: "/users")
                }
            }
        }
    }

    func delete(_ req: Request) throws -> Future<Response> {
        return try req.parameters.next(User.self).flatMap { user in
            return try user.pokemons.query(on: req).delete().flatMap { _ in
                return user.delete(on: req).map { _ in
                    return req.redirect(to: "/users")
                }
            }
        }
    }
}

struct UserForm: Content {
    var username: String
}

struct UserView: Encodable {
    var user: User
    var pokemons: Future<[Pokemon]>
}
