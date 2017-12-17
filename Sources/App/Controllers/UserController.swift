final class UserController {
  let drop: Droplet
  
  init(drop: Droplet) {
    self.drop = drop
  }
  
  func list(_ req: Request) throws -> ResponseRepresentable {
    let list = try User.all()
    return try drop.view.make("crud", ["userlist": list.makeNode(in: nil)])
  }
  
  func create(_ req: Request) throws -> ResponseRepresentable {
    guard let username = req.data["username"]?.string else {
      return Response(status: .badRequest)
    }
    
    let user = User(username: username)
    try user.save()
    return Response(redirect: "/user")
  }
  
  func update(_ req: Request) throws -> ResponseRepresentable {
    guard let userId = req.parameters["id"]?.int else {
      return Response(status: .badRequest)
    }
    
    guard let username = req.data["username"]?.string else {
      return Response(status: .badRequest)
    }
    
    guard let user = try User.find(userId) else {
      return Response(status: .badRequest)
    }
    
    user.username = username
    try user.save()
    return Response(redirect: "/user")
  }
  
  func delete(_ req: Request) throws -> ResponseRepresentable {
    guard let userId = req.parameters["id"]?.int else {
      return Response(status: .badRequest)
    }
    
    guard let user = try User.find(userId) else {
      return Response(status: .badRequest)
    }
    
    try user.delete()
    return Response(redirect: "/user")
  }
}
