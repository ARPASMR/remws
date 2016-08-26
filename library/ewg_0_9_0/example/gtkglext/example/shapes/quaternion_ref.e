indexing

	description: "Mathematical quaternion types."
	names: "math", "type", "quaternion"
	date: "$DateTime: 2002/02/07 12:59:28 $"
	revision: "$Revision: 1.1 $"
	author: "Mark Bolstad, US EPA/LM, bolstad.mark@epa.gov"
	status: "unreviewed", "untested"

class

	QUATERNION_REF

inherit

	BASIC_NUMERIC
		undefine
			default_create, is_equal
		end
	
creation

	default_create, make, make_from_axis, make_from_vectors,
	make_from_transformation

feature -- Initialization
	
        default_create is
                        -- Create a zero vector
                do
                        fill (0.0)
                end

        make (initial_x, initial_y, initial_z, initial_w: DOUBLE) is
                        -- Initial cartesian component coordinates.
                do
                        x := initial_x
                        y := initial_y
                        z := initial_z
                        w := initial_w
                ensure
                        x_set: x = initial_x
                        y_set: y = initial_y
                        z_set: z = initial_z
                        w_set: w = initial_w
                end

        fill (initial_value: DOUBLE) is
                        -- Set each `item' to `initial_value'.
                do
                        x := initial_value
                        y := initial_value
                        z := initial_value
                        w := initial_value
                ensure then
                        x_is_initial_value: x = initial_value
                        y_is_initial_value: y = initial_value
                        z_is_initial_value: z = initial_value
                        w_is_initial_value: w = initial_value
                end

	make_from_axis (the_axis: VECTOR3; the_angle: DOUBLE) is
			-- 
		require 
			axis_not_void: the_axis /= Void
		local
			scale_factor: DOUBLE
		do
			the_axis.normalize
			
			scale_factor := sine (the_angle/2)
			x := the_axis.x * scale_factor
			y := the_axis.y * scale_factor
			z := the_axis.z * scale_factor
			w := cosine (the_angle/2)
			
			update_axis := true
			
		ensure
			axis_is_correct_for_positive_angle:
							the_angle > Tolerance implies equal (axis, the_axis)
			axis_is_correct_for_zero_angle:
							about_equal (the_angle, 0) implies 
								about_equal (axis.x, 0) and 
								about_equal (axis.y, 0) and 
								about_equal (axis.z, 1)
			axis_is_correct_for_negative_angle: 
							the_angle < -Tolerance implies equal (axis,-the_axis)
			-- Cosine computation is to force normalization of the angle
			angle_is_correct: about_equal (angle, arc_cosine (cosine (the_angle)))
		end 
	
	make_from_vectors (rotate_from, rotate_to: VECTOR3) is
			-- Create a quaterion that is the equivilent of rotating 
			-- `rotate_from' into `rotate_to'
		local
			cost: DOUBLE
			tmp, tmp_axis: VECTOR3
		do
			rotate_from.normalize
			rotate_to.normalize
			cost := rotate_from # rotate_to
			
			if about_equal (cost, 1.0) then
				x := 0
				y := 0
				z := 0
				w := 1
				-- Find an axis to rotate about through the cross product
			elseif about_equal (cost, -1.0) then
				tmp.make (1, 0, 0)
				tmp := rotate_from * tmp
				if about_equal (tmp.magnitude, 0.0) then
					tmp.make (0, 1, 0)
					tmp := rotate_from * tmp
				end
				
				tmp.normalize
				make (tmp.x, tmp.y, tmp.z, 0)
			else
				tmp_axis := rotate_from * rotate_to
				tmp_axis.normalize
				
				tmp_axis := tmp_axis.scale (sqrt (0.5 * (1.0 - cost)))
				
				make (tmp_axis.x, tmp_axis.y, tmp_axis.z, sqrt (0.5 * (1.0 + cost)))
			end
			
			update_axis := true
		ensure
			rotation_correct: equal (rotate_to, rotation_matrix.apply_as_direction (rotate_from))
		end
	
	make_from_transformation (xform: TRANSFORM) is
			-- Create a quaternion from a rotation matrix
		require 
			is_pure_rotation_matrix: xform.is_pure_rotation
		local
			i, j, k: INTEGER
		do
			if xform.a11 > xform.a22 then
				if xform.a11 > xform.a33 then
					i := 1
				else
					i := 3
				end
			else
				if xform.a22 > xform.a33 then
					i := 2
				else
					i := 3
				end
			end
			
			if xform.a11 + xform.a22 + xform.a33 > xform.item (i, i) then
				w := sqrt (xform.a11 + xform.a22 + xform.a33 + xform.a44)/2
				
				x := (xform.a32 - xform.a23)/ (4 * w)
				y := (xform.a13 - xform.a31)/ (4 * w)
				z := (xform.a21 - xform.a12)/ (4 * w)
			else
				-- i, j, k are mutually exclusive in [1..3]
				j := i \\ 3 + 1
				k := (i + 1) \\ 3 + 1
				
				put (sqrt (xform.item (i, i) - xform.item (j, j) - 
						   xform.item (k, k) + xform.a44)/2, i)
				
				put ((xform.item (j, i) + xform.item (i, j)) / (4 * item (i)), j)
				put ((xform.item (k, i) + xform.item (i, k)) / (4 * item (i)), k)
				put ((xform.item (k, j) - xform.item (j, k)) / (4 * item (i)), 4)
			end

			update_axis := true
		ensure 
			quaterion_is_correct: equal (xform, rotation_matrix)
		end 

feature -- Access
	
        x: DOUBLE
                        -- X-coordinate.

        y: DOUBLE
                        -- Y-coordinate.

        z: DOUBLE
                        -- Z-coordinate.

        w: DOUBLE
                        -- W-coordinate.

        item (index: INTEGER): DOUBLE is
                        -- Coordinate/component at `index'.
                do
                        inspect
                                index
                        when 1 then
                                Result := x
                        when 2 then
                                Result := y
                        when 3 then
                                Result := z
                        else
                                Result := w
                        end
                ensure then
                        index_one_implies_x: index = 1 implies Result = x
                        index_two_implies_y: index = 2 implies Result = y
                        index_three_implies_z: index = 3 implies Result = z
                        index_four_implies_w: index = 4 implies Result = w
                end

	axis: VECTOR3 is
			-- The rotation axis.
		do
			if update_axis then
				compute_cached_axis
			end
			
			Result := cached_axis
		ensure 
			result_is_normalized: Result.is_unit
		end 
	
	angle: DOUBLE is
			-- The rotation angle about `axis' (in radians).
		do
			if update_axis then
				compute_cached_axis
			end
			
			Result := cached_angle
		ensure 
			angle_in_range: angle >= 0 and angle <= pi + Tolerance
		end 

	rotation_matrix: TRANSFORM is
			-- Build a rotation matrix from the quaternion
		do
			create Result.make_with_elements (1.0 - (2.0 * (y * y + z * z)),
											  2.0 * (x * y - z * w),
											  2.0 * (z * x + y * w),
											  0.0,
											  
											  2.0 * (x * y + z * w),
											  1.0 - (2.0 * (z * z + x * x)),
											  2.0 * (y * z - x * w),
											  0.0,
											  
											  2.0 * (z * x - y * w),
											  2.0 * (y * z + x * w),
											  1.0 - (2.0 * (y * y + x * x)),
											  0.0,
											  
											  0.0,
											  0.0,
											  0.0,
											  1.0)
		end
	
	zero: like Current is
			-- Neutral element for `+' and `-'
		do
			create Result
		end 

feature -- Measurement
	
        two_norm, magnitude, to_real: DOUBLE is
                        -- Euclidean magnitude (square-root of the sum of the squares of
                        -- the components).
                do
                        Result := square_root (magnitude_squared)
                end

        magnitude_squared: DOUBLE is
                        -- Project down to a real by sum of squares.
                do
                        Result := x * x + y * y + z * z + w * w
                end

feature -- Comparison
	
	is_equal (other: like Current): BOOLEAN is
			-- Is each corresponding `item' within `Tolerance'?
		do
			Result := about_equal (x, other.x) and then
			about_equal (y, other.y) and then
			about_equal (z, other.z) and then
			about_equal (w, other.w)
		end

feature -- Status report
feature -- Status setting
feature -- Cursor movement
feature -- Element change

	put (value: DOUBLE; index: INTEGER) is
                        -- Assign `value' to component at `index'.
                do
                        inspect
                                index
                        when 1 then
                                x := value
                        when 2 then
                                y := value
                        when 3 then
                                z := value
                        else
                                w := value
                        end
                ensure then
                        index_one_implies_x: index = 1 implies x = value
                        index_two_implies_y: index = 2 implies y = value
                        index_three_implies_z: index = 3 implies z = value
                        index_four_implies_w: index = 4 implies w = value
                end

	normalize is
			-- Make unit length.
		local
			scaled_x, scaled_y, scaled_z, scaled_w: DOUBLE
                        magnitude_of_x, magnitude_of_y, magnitude_of_z: DOUBLE
                        magnitude_of_w: DOUBLE
                        scalar, recipricol_of_magnitude, largest_magnitude: DOUBLE
		do
			magnitude_of_x := absolute_value (x)
			magnitude_of_y := absolute_value (y)
			magnitude_of_z := absolute_value (z)
			magnitude_of_w := absolute_value (w)
			
			largest_magnitude := magnitude_of_x.max (magnitude_of_y)
			largest_magnitude := largest_magnitude.max (magnitude_of_z)
			largest_magnitude := largest_magnitude.max (magnitude_of_w)
			scalar := 1.0 / largest_magnitude
			check
				scalar_is_positive: scalar > 0.0
			end
			scaled_x := x * scalar
			scaled_y := y * scalar
			scaled_z := z * scalar
			scaled_w := w * scalar
			recipricol_of_magnitude := 1.0 /
				square_root (scaled_x * scaled_x + scaled_y * scaled_y +
							 scaled_z * scaled_z + scaled_w * scaled_w)
			check
				recipricol_of_magnitude_is_positive:
				recipricol_of_magnitude > 0.0
			end
			x := scaled_x * recipricol_of_magnitude
			y := scaled_y * recipricol_of_magnitude
			z := scaled_z * recipricol_of_magnitude
			w := scaled_w * recipricol_of_magnitude
			check
				scaling_successful: about_equal (square (x) + square (y) + square (z) + square (w), 1.0)
			end
                end

feature -- Removal
feature -- Resizing
feature -- Transformation
feature -- Conversion
feature -- Duplication
feature -- Basic operations
	
	infix "+" (other: like Current): like Current is
			-- Addition of two quaternions
		require 
			other_not_void: other /= Void
		do
			create Result.make (x + other.x,
								y + other.y,
								z + other.z,
								w + other.w)
			
			update_axis := true
		ensure 
			Result_not_void: Result /= Void
		end 

	infix "-" (other: like Current): like Current is
			-- Subtraction of two quaternions
		require 
			other_not_void: other /= Void
		do
			create Result.make (x - other.x,
								y - other.y,
								z - other.z,
								w - other.w)
			
			update_axis := true
		ensure 
			Result_not_void: Result /= Void
		end 

	infix "*" (other: like Current): like Current is
			-- Given two rotations, figure out the equivalent single rotation
		do
			create Result.make (w*other.x + x*other.w + y*other.z - z*other.y,
								w*other.y + y*other.w + z*other.x - x*other.z,
								w*other.z + z*other.w + x*other.y - y*other.x,
								w*other.w - x*other.x - y*other.y - z*other.z)
			
			Result.normalize			 
			update_axis := true
			
		ensure
			is_correct: equal (Result.rotation_matrix,
							   Current.rotation_matrix * other.rotation_matrix)
		end
	
        infix "#", dot (other: like Current): DOUBLE is
                        -- Inner-product with `other'.
                local
                        the_product: DOUBLE
                do
                        if x /= 0.0 and then other.x /= 0.0 then
                                        -- Avoid nan (e.g., 0.0 * inf).
                                Result := x * other.x
                        end

                        if y /= 0.0 and then other.y /= 0.0 then
                                the_product := y * other.y

                                if Result = -the_product then
                                                -- Avoid nan (e.g., inf + -inf).
                                        Result := 0.0
                                else
                                        Result := Result + the_product
                                end
                        end

                        if z /= 0.0 and then other.z /= 0.0 then
                                the_product := z * other.z

                                if Result = -the_product then
                                        Result := 0.0
                                else
                                        Result := Result + the_product
                                end
                        end

                        if w /= 0.0 and then other.w /= 0.0 then
                                the_product := w * other.w

                                if Result = -the_product then
                                        Result := 0.0
                                else
                                        Result := Result + the_product
                                end
                        end
                ensure
                        result_correct:
                                about_equal (Result, (x * other.x) + (y * other.y) + (z * other.z) + (w * other.w))
		end
					
	prefix "+": like Current is
			-- Positve of `Current'.
		do
			create Result.make (+x, +y, +z, +w)
		end
	
	prefix "-": like Current is
			-- Negative of `Current'.
		do
			create Result.make (-x, -y, -z, -w)
		ensure
			result_x_equals_negative_current_x: Result.x = -x
			result_y_equals_negative_current_y: Result.y = -y
			result_z_equals_negative_current_z: Result.z = -z
			result_w_equals_negative_current_w: Result.w = -w
		end
	
	scale (scalar: DOUBLE): like Current is
			-- Scale the quaternion by `scalar'
		local
			result_x, result_y, result_z, result_w: DOUBLE
		do
			if scalar /= 0.0 then
				
				if x /= 0.0 then
					result_x := x * scalar
				end
				
				if y /= 0.0 then
					result_y := y * scalar
				end
				
				if z /= 0.0 then
					result_z := z * scalar
				end
				
				if w /= 0.0 then
					result_w := w * scalar
				end
				
				create Result.make (result_x, result_y, result_z, result_w)
				update_axis := true
			end
		ensure then
			result_x_correct: Result.x =  (x * scalar)
			result_y_correct: Result.y =  (y * scalar)
			result_z_correct: Result.z =  (z * scalar)
			result_w_correct: Result.w =  (w * scalar)
		end

	inverse: like Current is
			-- invert `Current'.
		do
			Result := clone (Current)
			Result.invert
		ensure
			result_is_inverse: (Result + Current).rotation_matrix.is_identity
		end
	
	invert is
			-- invert `Current'.
		local
			inverse_norm: DOUBLE
		do
			inverse_norm := 1.0 / magnitude_squared
			make (-x * inverse_norm, -y * inverse_norm,
				  -z * inverse_norm, w * inverse_norm)
			update_axis := true
		end
	
feature -- Miscellaneous
feature -- Obsolete
feature -- Inapplicable
feature {NONE} -- Implementation
	
	cached_angle: DOUBLE
			-- The rotation angle about `axis' (in radians).
	
	cached_axis: VECTOR3
			-- The rotation axis
	
	update_axis: BOOLEAN
			-- Flag used to indicate if the axis needs to be computed
	
	compute_cached_axis is
			-- The rotation axis
		do
			cached_axis.make (x, y, z)
			if cached_axis.magnitude < Tolerance then
				cached_axis.make (0, 0, 1)
				cached_angle := 0
			else
				cached_axis.normalize
				cached_angle := 2 * arc_cosine (w)
			end
			
			update_axis := false
		end
	
end -- class QUATERNION_REF


