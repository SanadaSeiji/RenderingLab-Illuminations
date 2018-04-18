#version 330

//Phong following Anton's example
//https://github.com/capnramses/antons_opengl_tutorials_book/tree/master/08_phong

in vec3 position_eye, normal_eye;

uniform mat4 view;

// fixed point light properties

vec3 light_position_world  = vec3 (0.0, 5.0, 20.0);

vec3 Ls = vec3 (0.4, 0.4, 0.4); // specular colour: light reflects of surface, directly in eye

vec3 Ld = vec3 (0.2, 0.2, 0.2); // dull diffuse light colour:roughness of surface

vec3 La = vec3 (0.2, 0.2, 0.2); //  ambient colour:background light, reflections hitting from other objs

  

// surface reflectance

vec3 Ks = vec3 (1.0, 1.0, 1.0); // fully reflect specular light; if rough surface this value be low 

vec3 Kd = vec3 (0.0, 1.0, 0.0); // green diffuse surface reflectance, unique base colour

vec3 Ka = vec3 (1.0, 1.0, 1.0); // fully reflect ambient light, later would be complicated

float specular_exponent = 40.0; // specular 'power', size of highlight spot larger if this value is 100.0



out vec4 fragment_colour; // final colour of surface



void main () {

	// ambient intensity, unchanged

	vec3 Ia = La * Ka;



	// diffuse intensity

	// raise light position to eye space

	vec3 light_position_eye = vec3 (view * vec4 (light_position_world, 1.0));

	vec3 distance_to_light_eye = light_position_eye - position_eye;

	vec3 direction_to_light_eye = normalize (distance_to_light_eye);

	float dot_prod = dot (direction_to_light_eye, normal_eye); //give surface a direction from surface to light, compare and produce the factor needed

	dot_prod = max (dot_prod, 0.0);//0.0 to avoid negative dot

	vec3 Id = Ld * Kd * dot_prod; // final diffuse intensity

	

	// specular intensity
        // again, compare angle between viewer and surface

	vec3 surface_to_viewer_eye = normalize (-position_eye); //camera at origin,everything raised to eye_space



	// blinn

	vec3 half_way_eye = normalize (surface_to_viewer_eye + direction_to_light_eye); //halfway!=reflection_eye...

	float dot_prod_specular = max (dot (half_way_eye, normal_eye), 0.0);

	float specular_factor = pow (dot_prod_specular, specular_exponent);//power, size of highlight

	

	vec3 Is = Ls * Ks * specular_factor; // final specular intensity

	

	// final colour

	fragment_colour = vec4 (Is + Id + Ia, 1.0);

}