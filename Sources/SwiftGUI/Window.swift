import LIBC
import SwiftOpenGL.glfw
import SwiftOpenGL.gl

class Window {
    let window: OpaquePointer?

    init(width: UInt32, height: UInt32, name: String) throws {
        self.window = glfwCreateWindow(Int32(width), Int32(height), name, nil, nil)
        if self.window == nil {
            throw WindowError.createWindow
        }
        glfwMakeContextCurrent(self.window)
    }

    func setSizeCallback(callback: GLFWframebuffersizefun?) {
        glfwSetFramebufferSizeCallback(self.window, callback)
    }

    func shouldClose() -> Bool {
        return glfwWindowShouldClose(self.window) == 0
    }

    func close() {
        glfwSetWindowShouldClose(self.window, Int32(1))
    }

    func isKeyPress(key: Int32) -> Bool {
        return glfwGetKey(self.window, key) == GLFW_PRESS
    }

    func swapBuffer() {
        glfwSwapBuffers(self.window)
    }
}

extension Window {
    enum WindowError: Error {
        case createWindow
    }
}