#version 330
//-Shaders code following:
//http://www.lighthouse3d.com/tutorials/glsl-12-tutorial/toon-shading-version-i/


in vec3 surfacePosition,surfaceNormal;

uniform mat4 view;

// fixed point light properties

vec3 lightPosition  = vec3 (0.0, 5.0, 20.0);


out vec4 fragment_colour; // final colour of surface



void main () {

 
       //raise to eye space
        lightPosition =vec3 (view * vec4 (lightPosition, 1.0));

	vec3 lightDir = normalize (lightPosition - surfacePosition);

	float LdotN = max (dot (lightDir, surfaceNormal), 0.0);// intensity
 
        vec4 color;

        if ( LdotN > 0.95)

		color = vec4(1.0,0.5,0.5,1.0);

	else if ( LdotN > 0.5)
		color = vec4(0.6,0.3,0.3,1.0);

	else if ( LdotN > 0.25)
		color = vec4(0.4,0.2,0.2,1.0);

	else
		color = vec4(0.2,0.1,0.1,1.0);

       

	fragment_colour = color;

}