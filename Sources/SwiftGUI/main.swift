import SwiftOpenGL
import Wrap

typealias CustomType = String

print("Hello, world!")
glfwInit();
glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
let SCR_WIDTH: Int32 = 800
let SCR_HEIGHT: Int32 = 600
var window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "LearnOpenGL", nil, nil);
if (window == nil)
{
    print("Failed to create GLFW window");
    glfwTerminate();
}
glfwMakeContextCurrent(window);
print(type(of: window))

func framebuffer_size_callback(window: OpaquePointer?, width: Int32, height: Int32) {
    print(width)
    print(height)
    wrapGlViewport(0, 0, width, height);
}
glfwSetFramebufferSizeCallback(window, framebuffer_size_callback)


show()