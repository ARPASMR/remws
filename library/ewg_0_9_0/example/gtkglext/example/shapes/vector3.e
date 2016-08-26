indexing

	description: "3D cartesian vectors."
	names: "3d", "cartesian", "vector", "line", "ray"
	representation: "DOUBLE"
	access: "fixed"
	size: "fixed"
	contents: "DOUBLE"
	date: "$Date: 2004/07/23 18:51:02 $"
	revision: "$Revision: 1.1 $"
	author: "Todd Plessel, US EPA/LM, plessel.todd@epa.gov"
	status: "reviewed", "tested"

class

	VECTOR3

inherit

	BASIC_NUMERIC
		undefine
			default_create, is_equal
		end
	
creation
	make, default_create, make_from_array
	
feature -- Initialization
	
	default_create is
			-- Create a zero vector
		do
			fill (0.0)
		end 

	make (initial_x, initial_y, initial_z: DOUBLE) is
			-- Initial cartesian component coordinates.
		do
			x := initial_x
			y := initial_y
			z := initial_z
		ensure
			x_set: x = initial_x
			y_set: y = initial_y
			z_set: z = initial_z
		end

	fill (initial_value: DOUBLE) is
			-- Set each `item' to `initial_value'.
		do
			x := initial_value
			y := initial_value
			z := initial_value
		ensure then
			x_is_initial_value: x = initial_value
			y_is_initial_value: y = initial_value
			z_is_initial_value: z = initial_value
		end

	make_from_array (values: ARRAY [DOUBLE]) is
			-- Make with these component values.
		do
			fill (0.0)

			if values.count >= 1 then
				x := values.item (1)
			end

			if values.count >= 2 then
				y := values.item (2)
			end

			if values.count >= 3 then
				z := values.item (3)
			end
		end

feature -- Access

	x: DOUBLE
			-- X-coordinate.

	y: DOUBLE
			-- Y-coordinate.

	z: DOUBLE
			-- Z-coordinate.

	item (index: INTEGER): DOUBLE is
			-- Coordinate/component at `index'.
		do
			inspect
				index
			when 1 then
				Result := x
			when 2 then
				Result := y
			else
				Result := z
			end
		ensure then
			index_one_implies_x: index = 1 implies Result = x
			index_two_implies_y: index = 2 implies Result = y
			index_three_implies_z: index = 3 implies Result = z
		end

	zero: VECTOR3 is
			-- Neutral element for "+" and "-".
		once
			create Result
		end

	one: VECTOR3 is
			-- Neutral element for "*".
		once
			create Result
			Result.fill (1.0)
		end

	unit: VECTOR3 is
			-- Unit-length (normalized) `Current'.
		do
			create Result.make (x, y, z)
			Result.normalize
		end

feature -- Status report

	is_unit: BOOLEAN is
                        -- Is this vector of unit length (within 1 +/- `Tolerance')?
		do
			Result := within_range (magnitude, 1.0 - Tolerance, 1.0 + Tolerance)
		end

feature -- Measurement

	count: INTEGER is 3
			-- The number of coordinates/components.

	two_norm, magnitude, to_real: DOUBLE is
			-- Euclidean magnitude (square-root of the sum of the squares of
			-- the components).
		do
			Result := square_root (magnitude_squared)
		end

	magnitude_squared: DOUBLE is
			-- Project down to a real by sum of squares.
		do
			Result := x * x + y * y + z * z
		end

	one_norm: DOUBLE is
			-- Project down to a real by sum of absolute values.
		do
			Result := absolute_value (x) + absolute_value (y) +
						absolute_value (z)
		end

	max_norm: DOUBLE is
			-- Project down to a real by selecting the largest absolute value.
		do
			Result := (absolute_value (x).max (absolute_value (y))).max
						(absolute_value (z))
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Is each corresponding `item' within `Tolerance'?
		do
			Result := about_equal (x, other.x) and then
						about_equal (y, other.y) and then
						about_equal (z, other.z)
		ensure then
			result_correct:
				Result = (about_equal (x, other.x) and about_equal (y, other.y)
						and about_equal (z, other.z))
		end

	infix "<" (other: VECTOR3): BOOLEAN is
			-- Is to_real < other.to_real?
		do
			Result := to_real <	other.to_real
		end

	is_zero: BOOLEAN is
			-- Are all coordinates/components exactly zero?
		do
			Result := x = 0.0 and then y = 0.0 and then z = 0.0
		ensure then
			result_correct: Result = (x = 0.0 and y = 0.0 and z = 0.0)
		end

feature -- Element change

	put_x (new_x: DOUBLE) is
			-- Set the x-coordinate.
		do
			x := new_x
		ensure
			x_set: x = new_x
		end

	put_y (new_y: DOUBLE) is
			-- Set the y-coordinate.
		do
			y := new_y
		ensure
			y_set: y = new_y
		end

	put_z (new_z: DOUBLE) is
			-- Set the z-coordinate.
		do
			z := new_z
		ensure
			z_set: z = new_z
		end

	put (value: DOUBLE; index: INTEGER) is
			-- Assign `value' to component at `index'.
		do
			inspect
				index
			when 1 then
				x := value
			when 2 then
				y := value
			else
				z := value
			end
		ensure then
			index_three_implies_z: index = 3 implies z = value
		end

	normalize is
			-- Make unit length.
		local
			scaled_x, scaled_y, scaled_z: DOUBLE
			magnitude_of_x, magnitude_of_y, magnitude_of_z: DOUBLE
			scalar, recipricol_of_magnitude, largest_magnitude: DOUBLE
		do
			magnitude_of_x := absolute_value (x)
			magnitude_of_y := absolute_value (y)
			magnitude_of_z := absolute_value (z)
			
			-- All components have non-infinite magnitude but may
			-- still be quite large so scale the components by the
			-- recipricol of the magnitude of the largest component
			-- to avoid overflow.
			largest_magnitude := magnitude_of_x.max (magnitude_of_y)
			largest_magnitude := largest_magnitude.max (magnitude_of_z)
			scalar := 1.0 / largest_magnitude
			check
				scalar_is_positive: scalar > 0.0
			end
			scaled_x := x * scalar
			scaled_y := y * scalar
			scaled_z := z * scalar
			recipricol_of_magnitude := 1.0 /
				square_root (scaled_x * scaled_x + scaled_y * scaled_y +
							 scaled_z * scaled_z)
			check
				recipricol_of_magnitude_is_positive:
				recipricol_of_magnitude > 0.0
			end
			x := scaled_x * recipricol_of_magnitude
			y := scaled_y * recipricol_of_magnitude
			z := scaled_z * recipricol_of_magnitude
			check
				scaling_successful:
				(square (x) + square (y) + square (z)) >=
				square (1.0 - Tolerance)
			end
		end

feature -- Basic operations

	transform (xform: TRANSFORM): VECTOR3 is
			-- Transform the point by `xform'
		require 
			xform_not_void: xform /= Void
		do
			Result := clone (Current)
			Result.apply (xform)
		ensure 
			Result_not_void: Result /= Void
--			Transformed: Result.transform (xform.inverse).is_equal (Current)
		end
	
	apply (xform: TRANSFORM) is
			-- Transform the point by `xform'
		require 
			xform_not_void: xform /= Void
		local
			sx, sy, sz, sw: DOUBLE
		do
			sx := xform.a11 * x + xform.a12 * y + xform.a13 * z
			sy := xform.a21 * x + xform.a22 * y + xform.a23 * z
			sz := xform.a31 * x + xform.a32 * y + xform.a33 * z

				-- For perspective and uniform scaling
			
			sw := xform.a41 * x + xform.a42 * y + xform.a43 * z

			if sw /= 1.0 and then sw /= 0.0 then
				sw := 1.0 / sw
				sx := sx * sw
				sy := sy * sw
				sz := sz * sw
			end

			make (sx, sy, sz)
		ensure 
--			Transformed: transform (xform.inverse).is_equal (old Current)
		end 

	prefix "+": VECTOR3 is
			-- Positive of `Current'.
		do
			create Result.make (x, y, z)
		ensure
			result_equals_current: Result.is_equal (Current)
		end

	prefix "-": VECTOR3 is
			-- Negative of `Current'.
		do
			create Result.make (-x, -y, -z)
		ensure
			result_x_equals_negative_current_x: Result.x = -x
			result_y_equals_negative_current_y: Result.y = -y
			result_z_equals_negative_current_z: Result.z = -z
		end

	infix "-" (other: VECTOR3): VECTOR3 is
			-- Difference with `other'.
		local
			result_x, result_y, result_z: DOUBLE
		do
			if x /= other.x then
				result_x := x - other.x
			end

			if y /= other.y then
				result_y := y - other.y
			end

			if z /= other.z then
				result_z := z - other.z
			end

			create Result.make (result_x, result_y, result_z)
		ensure
			result_x_is_x_difference: about_equal (Result.x, x - other.x)
			result_y_is_y_difference: about_equal (Result.y,  y - other.y)
			result_z_is_z_difference: about_equal (Result.z,  z - other.z)
		end

	infix "+" (other: VECTOR3): VECTOR3 is
			-- Sum with `other'.
		local
			result_x, result_y, result_z: DOUBLE
		do
			if x /= -other.x then
				result_x := x + other.x
			end

			if y /= -other.y then
				result_y := y + other.y
			end

			if z /= -other.z then
				result_z := z + other.z
			end

			create Result.make (result_x, result_y, result_z)
		ensure
			result_x_is_x_sum: about_equal (Result.x,  (x + other.x))
			result_y_is_y_sum: about_equal (Result.y,  (y + other.y))
			result_z_is_z_sum: about_equal (Result.z,  (z + other.z))
		end

	infix "#", dot (other: VECTOR3): DOUBLE is
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
		ensure
			result_correct:
				about_equal (Result,
							 (x * other.x) + (y * other.y) + (z * other.z))
		end

	infix "*", cross (other: VECTOR3): VECTOR3 is
			-- Outer-product with `other'.
		do
			create Result.make ((y * other.z) - (z * other.y),
								(z * other.x) - (x * other.z),
								(x * other.y) - (y * other.x))
		ensure
			result_x_correct:
				about_equal (Result.x, (y * other.z) - (z * other.y))
			result_y_correct:
				about_equal (Result.y, (z * other.x) - (x * other.z))
			result_z_correct:
				about_equal (Result.z, (x * other.y) - (y * other.x))
		end

	scale (scalar: DOUBLE): VECTOR3 is
			-- Scale by the real `scalar'.
		local
			result_x, result_y, result_z: DOUBLE
		do
			create Result
			
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

				Result.make (result_x, result_y, result_z)
			end
		ensure then
			result_x_correct: about_equal (Result.x, (x * scalar))
			result_y_correct: about_equal (Result.y, (y * scalar))
			result_z_correct: about_equal (Result.z, (z * scalar))
		end

feature -- Conversion

	to_array: EWG_DOUBLE_ARRAY is
			-- Create a row-major 1-d array from the elements of `Current'.
		do
			create Result.make_new_unshared (3)
			to_array_argument (Result)
		ensure
			Result_not_void: Result /= Void
			correct_count: Result.count = 3
			x_stored: about_equal (x, Result.item (0))
			y_stored: about_equal (y, Result.item (1))
			z_stored: about_equal (z, Result.item (2))
		end

	to_array_argument (a: EWG_DOUBLE_ARRAY) is
			-- Replace the items of `a' with the row-major elements of `Current'.
		require
			a_not_void: a /= Void
			a_correct_size: a.count = 4
		do
			a.put (x, 0)
			a.put (y, 1)
			a.put (z, 2)
			
		ensure
			x_stored: about_equal (x, a.item (0))
			y_stored: about_equal (y, a.item (1))
			z_stored: about_equal (z, a.item (2))
		end

	to_c: POINTER is
			-- Area of 4 row-major doubles for passing to C routines.
		do
			Result := to_array.array_address
		end

invariant

	count_is_three: count = 3
	magnitude_squared_is_sum_of_squares_of_components:
		about_equal (magnitude_squared, square (x) + square (y) + square (z))
	one_norm_is_sum_of_absolute_values_of_components:
		about_equal (one_norm, absolute_value (x) + absolute_value (y) + absolute_value (z))
	one_norm_is_sum_of_absolute_values_of_components:
		about_equal (one_norm, absolute_value (x) + absolute_value (y) + absolute_value (z))
	max_norm_is_max_of_absolute_values_of_components:
		about_equal (max_norm, (absolute_value (x).max (absolute_value (y))).max
					(absolute_value (z)))

end -- class VECTOR3
