import LIBC
import SwiftOpenGL.glfw

class GLFW {
    init(major: Int32, minor: Int32, profile: Int32) throws {
        if glfwInit() == GL_FALSE {
            throw Code.glfwInit
        }
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, major)
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, minor)
        glfwWindowHint(GLFW_OPENGL_PROFILE, profile)
    }

    func makeContextCurrent(window: Window) {
        glfwMakeContextCurrent(window.window)
    }

    deinit {
        glfwTerminate()
    }
}

extension GLFW {
    enum Code: Error {
        case glfwInit
    }
}