shader_type canvas_item;

uniform bool blur = true;

vec3 tap(sampler2D tex0, vec2 uv) {
	uv = clamp(uv, vec2(0.0, 0.0), vec2(1.0, 1.0));
	return texture(tex0, uv).rgb;
}
#define GAUSS_5_0 0.2270270270
#define GAUSS_5_1 0.3162162162
#define GAUSS_5_2 0.0702702703
vec3 sample_blur_5(sampler2D tex0, vec2 uv, vec2 tex0Size) {
	vec2 off1 = vec2(1.3846, 0.0) / tex0Size;
	vec2 off2 = vec2(3.2308, 0.0) / tex0Size;
	vec3 color = tap(tex0, uv) * GAUSS_5_0;
	color += tap(tex0, uv - off1) * GAUSS_5_1;
	color += tap(tex0, uv + off1) * GAUSS_5_1;
	color += tap(tex0, uv - off2) * GAUSS_5_2;
	color += tap(tex0, uv + off2) * GAUSS_5_2;
	return color;
}
#define GAUSS_3_0 0.29411764705882354
#define GAUSS_3_1 0.35294117647058826
vec3 sample_blur_3(sampler2D tex0, vec2 uv, vec2 tex0Size) {
	vec2 off1 = vec2(1.3333, 0.0) / tex0Size;
	vec3 color = tap(tex0, uv) * GAUSS_3_0;
	color += tap(tex0, uv - off1) * GAUSS_3_1;
	color += tap(tex0, uv + off1) * GAUSS_3_1;
	return color;
}
vec3 sample_badblur_3(sampler2D tex0, vec2 uv, vec2 tex0Size) {
	vec2 off1 = vec2(1.0, 0.0) / tex0Size;
	vec3 color = tap(tex0, uv) * 0.5;
	color += tap(tex0, uv - off1) * 0.25;
	color += tap(tex0, uv + off1) * 0.25;
	return color;
}
vec3 sample_badblur_5(sampler2D tex0, vec2 uv, vec2 tex0Size) {
	vec2 off1 = vec2(1.0, 0.0) / tex0Size;
	vec2 off2 = vec2(2.0, 0.0) / tex0Size;
	vec3 color = tap(tex0, uv) * 0.5;
	color += tap(tex0, uv - off1) * 0.2;
	color += tap(tex0, uv + off1) * 0.2;
	color += tap(tex0, uv - off2) * 0.05;
	color += tap(tex0, uv + off2) * 0.05;
	return color;
}

vec3 blur_upscale(sampler2D tex0, vec2 uv, vec2 tex0Size) {
	vec2 tex = uv * tex0Size;
	vec2 pix = vec2(tex.x, floor(tex.y) + 0.5);
	vec2 realUv = pix / tex0Size;
	
	vec3 color = sample_badblur_5(tex0, realUv, tex0Size);
	vec3 scanline = vec3(0);
	float curve = (cos((tex.y + 0.5) * TAU) + 1.0) / 2.0;
	curve = pow(curve, 0.5);
	scanline = vec3(curve);
	color *= mix(vec3(0.75), vec3(1.0), scanline);
	return color;
}

vec3 sharp_upscale(sampler2D tex0, vec2 uv, vec2 tex0Size) {
	vec2 tex = uv * tex0Size;
	vec2 pix = floor(tex) + min(fract(tex) / fwidth(tex), 1.0) - 0.5;
	
	return tap(tex0, pix / tex0Size);
}

void fragment() {
	vec3 real;
	
	if(blur) {
		real = blur_upscale(TEXTURE, UV, 1.0 / TEXTURE_PIXEL_SIZE);
	} else {
		real = sharp_upscale(TEXTURE, UV, 1.0 / TEXTURE_PIXEL_SIZE);
	}
	
	COLOR = vec4(real, 1.0);
}
