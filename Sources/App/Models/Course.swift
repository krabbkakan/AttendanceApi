import FluentSQLite
import Vapor
final class Course: Codable {
    var id: Int?
    var name: String
    var numberOfLessons: Int

    init(name: String, numberOfLessons: Int) {
        self.name = name
        self.numberOfLessons = numberOfLessons
    }
}

extension Course: SQLiteModel {}
extension Course: Content {}
extension Course: Migration {}


