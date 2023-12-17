shader_type spatial;
render_mode cull_disabled, diffuse_lambert, shadows_disabled, vertex_lighting, skip_vertex_transform;

uniform vec3 color_value : source_color = vec3(1.0, 1.0, 1.0);
uniform sampler2D color_texture : hint_default_white, filter_nearest;

void vertex() {
	vec4 v = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	v.xy = round(v.xy * VIEWPORT_SIZE.xy);
	v.xy /= VIEWPORT_SIZE.xy;
	
	VERTEX = v.xyz;
	NORMAL = MODELVIEW_NORMAL_MATRIX * NORMAL;
}

void fragment() {
	vec3 color = color_value;
	color *= texture(color_texture, UV).rgb;
	
	ALBEDO = color;
	ROUGHNESS = 1.0;
}
