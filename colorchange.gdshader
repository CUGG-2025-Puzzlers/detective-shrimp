shader_type canvas_item;
uniform float strength : hint_range(0, 1);

uniform vec4 target_color : source_color;
uniform vec4 replace_color : source_color; 
uniform float tolerance : hint_range(0, 1); 
 
void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
 	if (strength > 0.5) {
		float dist = distance(tex_color.rgb, target_color.rgb);
	    if (dist < tolerance) {
	        tex_color.rgb = replace_color.rgb;
	    }
	    COLOR = tex_color;
	} 
}
