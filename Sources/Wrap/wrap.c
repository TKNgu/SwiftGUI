#include "wrap.h"
#include <stdio.h>
#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <stdlib.h>
#include <stdio.h>
// #include <GLFW/glfw3.h>

// struct Haha {
//     int* array;
//     int count;
// };

int GladLoadGLLoader() {
    return gladLoadGLLoader((GLADloadproc) glfwGetProcAddress);
}

Haha CreateValue(int leng) {
    struct Haha haha;
    haha.count = leng;
    haha.array = (int*) malloc(haha.count * sizeof(int));
    return haha;
}

// void processInput(GLFWwindow *window)
// {
//     if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
//         glfwSetWindowShouldClose(window, 1);
// }

// glfw: whenever the window size changed (by OS or user resize) this callback function executes
// ---------------------------------------------------------------------------------------------
// void framebuffer_size_callback(GLFWwindow* window, int width, int height)
// {
//     // make sure the viewport matches the new window dimensions; note that width and 
//     // height will be significantly larger than specified on retina displays.
//     glViewport(0, 0, width, height);
// }

int GlfwInit() {
    if(glfwInit() != GLFW_TRUE) {
        return 1;
    }
    glfwWindowHint(GLFW_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

if (gladLoadGLLoader((GLADloadproc)glfwGetProcAddress) != 0)
{
    printf("Failed to initialize GLAD");
}  

    GLFWwindow* window = glfwCreateWindow(800, 600, "LearnOpenGL", NULL, NULL);

    return 0;
}

int* TestPoint() {
    int* value = (int*) malloc(sizeof(int));
    printf("%p\n", value);
    return value;
}

void ShowPoint(int* point) {
    printf("%p\n", point);
}

void* WrapPoint() {
    int* array = (int*) malloc(10 * sizeof(int));
    return (void*) array;
}

void Init(void* point) {
    int* value = (int*) point;
    for(int index = 0; index < 10; index++) {
        value[index] = index;
    }
}

void WrapShow(void* point) {
    printf("%p\n", point);
    int* value = (int*) point;
    for(int index = 0; index < 10; index++) {
        printf("Value %d\n", value[index]);
    }
}