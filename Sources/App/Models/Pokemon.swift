import Vapor
import FluentProvider

final class Pokemon: Model {
  let storage = Storage()
  let name: String
  let level: Int
  let userId: Int
  
  init(name: String, level: Int, userId: Int) {
    self.name = name
    self.level = level
    self.userId = userId
  }
  
  init(row: Row) throws {
    name = try row.get("name")
    level = try row.get("level")
    userId = try row.get(User.foreignIdKey)
  }
  
  func makeRow() throws -> Row {
    var row = Row()
    try row.set("name", name)
    try row.set("level", level)
    try row.set(User.foreignIdKey, userId)
    return row
  }
}

// MARK: Preparation

extension Pokemon: Preparation {
  
  static func prepare(_ database: Database) throws {
    try database.create(self) { builder in
      builder.id()
      builder.string("name")
      builder.string("level")
      builder.foreignId(for: User.self)
    }
  }
  
  static func revert(_ database: Database) throws {
    try database.delete(self)
  }
}

// MARK: NodeRepresentable

extension Pokemon: NodeRepresentable {
  
  func makeNode(in context: Context?) throws -> Node {
    var node = Node(context)
    try node.set("name", name)
    try node.set("level", level)
    try node.set("user_id", userId)
    return node
  }
}
