import Vapor

extension Droplet {
  func setupRoutes() throws {
    
    let userController = UserController(drop: self)
    get("user", handler: userController.list)
    post("user", handler: userController.create)
    post("user", ":id", "update", handler: userController.update)
    post("user", ":id", "delete", handler: userController.delete)
    
    let pokemonController = PokemonController()
    post("pokemon", handler: pokemonController.create)
  }
}
