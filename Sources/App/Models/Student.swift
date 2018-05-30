import FluentMySQL
import Vapor
final class Student: Codable {
    var id: Int?
    var firstName: String
    var lastName: String
    var attendedLessons: Int?
//    var didPass: Bool
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.attendedLessons = 0
//        self.didPass = false
    }
}

extension Student: MySQLModel {}
extension Student: Content {}
extension Student: Migration {}

