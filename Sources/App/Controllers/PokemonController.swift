final class PokemonController {
  
  func create(_ req: Request) throws -> ResponseRepresentable {
    
    /// check userId is provided and of type int
    guard let userId = req.data["userId"]?.int else {
      return Response(status: .badRequest)
    }
    
    /// try to find user with given id (just an existence check)
    guard try User.find(userId) != nil else {
      return Response(status: .badRequest)
    }
    
    /// check name is given and of type String
    guard let pokemonName = req.data["name"]?.string else {
      return Response(status: .badRequest)
    }
    
    /// check level is given and of type Int
    guard let level = req.data["level"]?.int else {
      return Response(status: .badRequest)
    }
    
    /// initiate new pokemon
    let pokemon = Pokemon(name: pokemonName, level: level, userId: userId)
    
    /// save new pokemon to database
    try pokemon.save()
    
    return Response(redirect: "/user")
  }
}
