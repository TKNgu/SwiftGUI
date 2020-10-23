#ifndef __WRAP__
#define __WRAP__
#include "glad/glad.h"
// #include "GLFW/glfw3.h"

int GladLoadGLLoader();

// void framebuffer_size_callback(GLFWwindow* window, int width, int height);
// void processInput(GLFWwindow *window);

typedef struct Haha {
    int* array;
    int count;
} Haha;

int GlfwInit();

int* TestPoint();

void ShowPoint(int*);

void* WrapPoint();

void Init(void*);

void WrapShow(void*);

Haha CreateValue(int);

#endif