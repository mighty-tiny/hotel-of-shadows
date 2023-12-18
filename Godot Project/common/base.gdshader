shader_type spatial;
render_mode cull_disabled, diffuse_lambert, shadows_disabled, vertex_lighting, skip_vertex_transform;

global uniform float fog_start;
global uniform float fog_end;
global uniform vec4 fog_color;

uniform vec3 color_value : source_color = vec3(1.0, 1.0, 1.0);
uniform sampler2D color_texture : hint_default_white, filter_nearest;

varying float v_fog_alpha;

void vertex() {
	vec4 v = (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	
	vec2 snapSize = VIEWPORT_SIZE.xy / 2.0;
	v.xy = round(v.xy / v.w * snapSize.xy) / snapSize * v.w;
	
	VERTEX = v.xyz;
	NORMAL = MODELVIEW_NORMAL_MATRIX * NORMAL;
	
	v_fog_alpha = clamp((length(VERTEX) - fog_start) / fog_end, 0.0, 1.0);
}

void fragment() {
	vec3 color = color_value;
	color *= texture(color_texture, UV).rgb;
	
	/*
	 * The compatibility renderer doesn't support the FOG attribute, so we have to implement it
	 * ourselves using a combination of lerping the color to fog and emission.
	 */
	vec4 fogColor = vec4(fog_color.rgb, v_fog_alpha);
	//fogColor = vec4(v_fog_alpha, v_fog_alpha, v_fog_alpha, 1.0);
	
	ALBEDO = mix(color, fogColor.rgb, fogColor.a);
	ROUGHNESS = 1.0;
	
	EMISSION = mix(vec3(0.0, 0.0, 0.0), fogColor.rgb, fogColor.a);
	FOG = fogColor;
}
