shader_type canvas_item;

uniform float TAU = 6.28318530718;
uniform vec3 BackColor = vec3(0.1, 0.3, 0.6);
uniform vec3 CloudColor = vec3(0.8,0.7,0.8);


float Func(float pX)
{
	return 0.6*(0.5/sin(1.1*pX) + 1.5/sin(0.553*pX) - 0.7/sin(1.2*pX));
}


float FuncR(float pX)
{
	return 0.5 + 0.25*(1.0 + sin(mod(140.0*pX, TAU)));
}


float Layer(vec2 pQ, float pT)
{
	vec2 Qt = 3.5*pQ;
	pT *= 1.5;
	Qt.x -= pT;

	float Xi = floor(Qt.x);
	float Xf = Qt.x - Xi -0.5;

	vec2 C;
	float Yi;
	float D = 1.0 - step(Qt.y,  Func(Qt.x));

	// Disk:
	Yi = Func(Xi + 0.5);
	C = vec2(Xf, Qt.y - Yi ); 
	D =  min(D, length(C) - FuncR(Xi+ pT/80.0));

	// Previous disk:
	Yi = Func(Xi+1.0 + 0.5);
	C = vec2(Xf-1.0, Qt.y - Yi ); 
	D =  min(D, length(C) - FuncR(Xi+1.0+ pT/80.0));

	// Next Disk:
	Yi = Func(Xi-1.0 + 0.5);
	C = vec2(Xf+1.0, Qt.y - Yi ); 
	D =  min(D, length(C) - FuncR(Xi-1.0 + pT/80.0));

	return min(1.0, D);
}



void fragment(){
	// Setup:
	vec2 uvuv = 2.0*(FRAGCOORD.xy - (0.5 / SCREEN_PIXEL_SIZE).xy/1.3) / min((0.3 / SCREEN_PIXEL_SIZE).x, (0.8 / SCREEN_PIXEL_SIZE).y);	
	
	// Render:
	vec3 Color= BackColor;

	for(float J=0.0; J<=1.0; J+=0.2)
	{
		// Cloud Layer: 
		float Lt =  TIME*(0.2  + 1.6*J)*(1.2 - 1.1*sin(66.0*J)) - 17.0*J;
		vec2 Lp = vec2(0.0, 0.3+1.5*( J - 0.5));
		float L = Layer(uvuv + Lp, Lt);

		// Blur and color:
		float Blur = 4.0*(0.5*abs(2.0 - 5.0*J))/(11.0 - 5.0*J);

		float V = mix( 0.0, 1.0, 1.0 - smoothstep( 0.0, 0.01 +0.2*Blur, L ) );
		vec3 Lc=  mix( CloudColor, vec3(1.0), J);

		Color =mix(Color, Lc,  V);
	}

	COLOR = vec4(Color, 1.0);
}
