import Vapor

struct StudentController: RouteCollection {
    var courseEnrolled = Course(name: "Api:er", numberOfLessons: 10)
    
    func boot(router: Router) throws {
        
        let studentRoute = router.grouped("api", "students")
        studentRoute.get(use: getAllHandler)
        studentRoute.post(use: createHandler)
        studentRoute.get(Student.parameter, use: getHandler)
        studentRoute.delete(Student.parameter, use: deleteHandler)
        studentRoute.put("name", Student.parameter, use: updateNameHandler)
        studentRoute.put("attendance", Student.parameter, use: updateAttendedLessonsHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Student]> {
        return Student.query(on: req).all()
    }
    
    func createHandler(_ req: Request) throws -> Future<Student> {
        let student = try req.content.decode(Student.self)
        return student.save(on: req)
    }
    
    func getHandler(_ req: Request) throws -> Future<Student> {
        return try req.parameters.next(Student.self)
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Student.self).flatMap(to: HTTPStatus.self) { student in
            return student.delete(on: req).transform(to: .noContent)
        }
    }
    
    func updateNameHandler(_ req: Request) throws -> Future<Student> {
        return try flatMap(to: Student.self, req.parameters.next(Student.self), req.content.decode(Student.self)) { student, updatedStudent in
            student.firstName = updatedStudent.firstName
            student.lastName = updatedStudent.lastName
            return student.save(on: req)
        }
    }
    
    func updateAttendedLessonsHandler(_ req: Request) throws -> Future<Student> {
        return try flatMap(to: Student.self, req.parameters.next(Student.self), req.content.decode(Student.self)) { student, updatedStudent in
            student.attendedLessons = updatedStudent.attendedLessons
            return student.save(on: req)
        }
    }
    
    func updateDidPassLessonsHandler(_ req: Request) throws -> Future<Student> {
        return try flatMap(to: Student.self, req.parameters.next(Student.self), req.content.decode(Student.self)) { student, updatedStudent in
            
            student.didPass = updatedStudent.didPass
            return student.save(on: req)
        }
    }
    
    
}

extension Student: Parameter {}


