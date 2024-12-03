// Per Pixel Lighting GL4
#version 400 core

//  Transformation matrices
uniform mat4 ModelViewMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ProjectionMatrix;
uniform mat3 NormalMatrix;
//  Light properties
uniform vec4 Position;

//  Vertex attributes
in vec4 Vertex;
in vec3 Normal;
in vec4 Color;
in vec3 Offset;

//  Output to next shader
out vec3 View;
out vec3 Light;
out vec3 Norm;
out vec4 Kd;

mat4 rotateY( in float angle ) {
	return mat4(
      cos(angle), 0,      sin(angle),	0,    
      0,		     1.0,	  0,	        0,
		-sin(angle),	0,		  cos(angle),	0,
      0, 		      0,			0,	        1
   );
}
mat4 rotateX( in float angle ) {
	return mat4(
      1,          0,      0,	      0,    
      0,  cos(angle), -sin(angle),	0,
		0,	 sin(angle), cos(angle),	0,
      0, 		      0,			0,	   1
   );
}
float random (vec3 st) {
    return fract(sin(dot(st.xz,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

void main()
{
   //  Vertex location in modelview coordinates
   mat4 rotationMatrixX = rotateX(-1.2 * random(Offset)*(Vertex.y/4.0));
   mat4 rotationMatrixY = rotateY(random(Offset)*360.0);
   vec4 localPosition = (Vertex *rotationMatrixX*rotationMatrixY) + vec4(Offset,0);
   //vec4 P = ModelViewMatrix * (Vertex + vec4(Offset,0));
   vec4 P = ModelViewMatrix * localPosition;
   // random rotation based on position

   //  Light direction
   Light = vec3(ViewMatrix * Position - P);
   //  Normal vector
   Norm = NormalMatrix * Normal * mat3(rotationMatrixX)*mat3(rotationMatrixY);
   //  Eye position
   View  = -P.xyz;
   //  Set diffuse to Color
   Kd = Color;
   //  Texture
   
   //  Set transformed vertex location
   gl_Position =  ProjectionMatrix * ModelViewMatrix * localPosition;
}
