import Vapor
import FluentMySQL

struct CourseController: RouteCollection {
    func boot(router: Router) throws {
        let courseRoute = router.grouped("api", "courses")
        courseRoute.get(use: getAllHandler)
        courseRoute.post(use: createHandler)
        courseRoute.get(Course.parameter, use: getHandler)
        courseRoute.delete(Course.parameter, use: deleteHandler)
        courseRoute.put(Course.parameter, use: updateHandler)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Course]> {
        return Course.query(on: req).all()
    }
    
    func createHandler(_ req: Request) throws -> Future<Course> {
        let course = try req.content.decode(Course.self)
        return course.save(on: req)
    }
    
    func getHandler(_ req: Request) throws -> Future<Course> {
        return try req.parameters.next(Course.self)
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(Course.self).flatMap(to: HTTPStatus.self) { course in
            return course.delete(on: req).transform(to: .noContent)
        }
    }
    
    func updateHandler(_ req: Request) throws -> Future<Course> {
        return try flatMap(to: Course.self, req.parameters.next(Course.self), req.content.decode(Course.self)) { course, updatedCourse in
            course.name = updatedCourse.name
            course.numberOfLessons = updatedCourse.numberOfLessons
            return course.save(on: req)
        }
    }
    

}

extension Course: Parameter {}
