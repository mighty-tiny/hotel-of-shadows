shader_type canvas_item;

/*
 * Implements PSX-style dithering:
 * Take the 8bpc raw rendered result, then find this pixel's relative position within the 4x4 dither
 * matrix. Take the matrix value and add it to each channel individually, then clamp them to 0xFF.
 * Finally divide by eight to remove the lowest three bits of precision to get your dithered, 5bpc,
 * output.
 */
const float DITHER_PATTERN[16] = float[](
	-4.0, +0.0, -3.0, +1.0,
	+2.0, -2.0, +3.0, -1.0,
	-3.0, +1.0, -4.0, +0.0,
	+3.0, -1.0, +2.0, -2.0
);
float dither_channel(float original, float offset) {
	float c = (clamp(original, 0.0, 1.0) * float(0xFF));
	c += offset;
	c = clamp(c, 0, 0xFF);
	
	return float(int(c) / 8) / float(0x1F);
}
float dither_sample(vec2 pix) {
	return DITHER_PATTERN[(int(pix.x) % 4) * 4 + (int(pix.y) % 4)];
}
vec3 dither(vec3 original, vec2 pix, float multiplier) {
	float offset = dither_sample(pix * multiplier);
	
	return vec3(
		dither_channel(original.r, offset),
		dither_channel(original.g, offset),
		dither_channel(original.b, offset)
	);
}

void fragment() {
	vec2 texSize = 1.0 / TEXTURE_PIXEL_SIZE;
	
	vec3 color = texture(TEXTURE, UV).rgb;
	
	color = dither(color, UV * texSize, 1.0);
	
	COLOR = vec4(color, 1.0);
}
