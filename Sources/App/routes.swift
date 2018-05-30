import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let courseController = CourseController()
    try router.register(collection: courseController)
   
    let studentController = StudentController()
    try router.register(collection: studentController)

}
