#version 330

//Cook Torrance following explanation on Wikipedia, based and modified from example below
//https://github.com/kamil-kolaczynski/synthclipse-demos/blob/master/src/jsx-demos/lighting-models/shaders/model/cook-torrance.glsl

in vec3 surfacePosition,surfaceNormal;

uniform mat4 view;

float roughness = 0.5; //0 roughtest

float RefAtNormIncidence = 1.0; //!

 vec3 CookSpecularColor = vec3(0.7, 0.7, 0.7); //! color[0.7, 0.7, 0.7]

// fixed point light properties

vec3 lightPosition  = vec3 (0.0, 5.0, 20.0);

vec3 Ls = vec3 (0.4, 0.4, 0.4); // specular colour: light reflects of surface, directly in eye

vec3 Ld = vec3 (0.2, 0.2, 0.2); // dull diffuse light colour:roughness of surface

  

// surface reflectance

vec3 Ks = vec3 (1.0, 1.0, 1.0); // fully reflect specular light; if rough surface this value be low 

vec3 Kd = vec3 (0.0, 0.0, 1.0); // blue diffuse surface reflectance, unique base colour





out vec4 fragment_colour; // final colour of surface



void main () {

       

        //diffuse

        vec3 Id = Ld * Kd;

        
        //specular
        //raise to eye space
        lightPosition =vec3 (view * vec4 (lightPosition, 1.0));

	vec3 lightDir = normalize (lightPosition - surfacePosition);
        

        //surfaceNormal is normalized?
        //cannot normlize it ???

	float LdotN = max (dot (lightDir, surfaceNormal), 0.0);// cos between to light and surface normal
        vec3 viewDir = normalize(- surfacePosition);

        float VdotN = max(dot (viewDir, surfaceNormal), 0.0);

        //half angle
        vec3 H = normalize (lightDir + viewDir);

        float NdotL = clamp(dot(surfaceNormal, lightDir), 0.0, 1.0);
        float NdotH = clamp(dot(surfaceNormal, H), 0.0, 1.0);
	float NdotV = clamp(dot(surfaceNormal, viewDir), 0.0, 1.0);
	float VdotH = clamp(dot(viewDir, H), 0.0, 1.0);
	float r_sq = roughness * roughness;

        // Evaluate the geometric term
	// --------------------------------
	float geo_numerator = 2.0 * NdotH;
	float geo_denominator = VdotH;

	float geo_b = (geo_numerator * NdotV) / geo_denominator;
	float geo_c = (geo_numerator * NdotL) / geo_denominator;
	float geo = min(1.0, min(geo_b, geo_c));

        // Now evaluate the roughness term
	// -------------------------------
        float roughness_a = 1.0 / (3.14 * r_sq * pow(NdotH, 4));
	float roughness_b = NdotH * NdotH - 1.0;
	float roughness_c = r_sq * NdotH * NdotH;

	roughness = roughness_a * exp(roughness_b / roughness_c);

        // Next evaluate the Fresnel value
	// -------------------------------
	float fresnel = pow(1.0 - VdotH, 5.0);
	fresnel *= (1.0 - RefAtNormIncidence);
	fresnel += RefAtNormIncidence;

        // Put all the terms together to compute
	// the specular term in the equation
	// -------------------------------------
	vec3 Rs_numerator = vec3(fresnel * geo * roughness);
	float Rs_denominator = 4 * NdotV * NdotL;
	vec3 Rs = Rs_numerator / Rs_denominator;

      
        // Put all the parts together to generate
	// the final colour
	// --------------------------------------
	vec3 Is = CookSpecularColor * Rs;

        

	// final colour

	fragment_colour = vec4 ( Is + Id, 1.0);

}