#version 330 core

in vec3 vertexColor;
in vec2 texCoord;

uniform float greenValue;
uniform sampler2D ourTexture;
uniform sampler2D ourTexture1;

out vec4 FragColor;

void main(){
    vec3 tmp = vec3(vertexColor.x, vertexColor.y + greenValue, vertexColor.z);
    FragColor = mix(vec4(tmp, 1.0f) * texture(ourTexture, texCoord), texture(ourTexture1, texCoord), 0.2);
};