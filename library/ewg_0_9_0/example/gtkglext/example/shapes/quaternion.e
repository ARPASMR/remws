indexing

	description: "Mathematical quaternion types."
	names: "math", "type", "quaternion"
	date: "$Date: 2004/07/23 18:51:02 $"
	revision: "$Revision: 1.1 $"
	author: "Mark Bolstad, US EPA/LM, bolstad.mark@epa.gov"
	status: "unreviewed", "untested"

--- See /home/plessel/lib/internal/c++/src/libs/Math/Complex/Complex.[hC]
--- for suggested possible additional features.

class

QUATERNION

inherit

	QUATERNION_REF
		rename
			zero as quaternion_ref_zero, 
			infix "+" as quaternion_ref_infix_plus,
			infix "-" as quaternion_ref_infix_minus,
			infix "*" as quaternion_ref_infix_star,
			prefix "+" as quaternion_ref_prefix_plus,
			prefix "-" as quaternion_ref_prefix_minus,
			scale as quaternion_ref_scale,
			inverse as quaternion_ref_inverse
		export
			{NONE}
			quaternion_ref_zero, quaternion_ref_infix_plus, 
			quaternion_ref_infix_minus, quaternion_ref_infix_star,
			quaternion_ref_prefix_plus, quaternion_ref_prefix_minus, 
			quaternion_ref_scale, quaternion_ref_inverse
		end
	
creation

	default_create, make, make_from_axis, make_from_vectors,
	make_from_transformation

feature -- Access
	
	zero: QUATERNION is
			-- Neutral element for `+' and `-'
		once
			create Result
		end 

feature -- Measurement
feature -- Comparison
	
feature -- Status report
feature -- Status setting
feature -- Cursor movement
feature -- Element change
feature -- Removal
feature -- Resizing
feature -- Transformation
feature -- Conversion
feature -- Duplication
feature -- Basic operations
	
	infix "+" (other: QUATERNION): QUATERNION is
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

	infix "-" (other: QUATERNION): QUATERNION is
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

	infix "*" (other: QUATERNION): QUATERNION is
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
	
	prefix "+": QUATERNION is
			-- Positve of `Current'.
		do
			create Result.make (+x, +y, +z, +w)
		end
	
	prefix "-": QUATERNION is
			-- Negative of `Current'.
		do
			create Result.make (-x, -y, -z, -w)
		ensure
			result_x_equals_negative_current_x: Result.x = -x
			result_y_equals_negative_current_y: Result.y = -y
			result_z_equals_negative_current_z: Result.z = -z
			result_w_equals_negative_current_w: Result.w = -w
		end
	
	scale (scalar: DOUBLE): QUATERNION is
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

	inverse: QUATERNION is
			-- invert `Current'.
		do
			Result := clone (Current)
			Result.invert
		ensure
			result_is_inverse: (Result + Current).rotation_matrix.is_identity
		end
	
end -- class QUATERNION

