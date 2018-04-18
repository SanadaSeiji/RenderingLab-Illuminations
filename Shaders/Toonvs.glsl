#version 330



layout (location = 0) in vec3 vertex_position;

layout (location = 1) in vec3 vertex_normals;

//light need to be able to move/change colour
uniform mat4 view;
uniform mat4 proj;
uniform mat4 model;

out vec3 surfacePosition, surfaceNormal; //will load from mesh.obj into Model mesh



void main () {

//raise to eye space
//to go around the fact that there is no vec for eyePosition

	surfacePosition = vec3 (view * model * vec4 (vertex_position, 1.0));

	surfaceNormal = vec3 (view * model * vec4 (vertex_normals, 0.0));

	gl_Position = proj * vec4 (surfacePosition, 1.0);

}