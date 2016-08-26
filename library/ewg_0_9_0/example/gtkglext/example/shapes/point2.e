indexing

	description: "2D cartesian points."
	names: "2d", "cartesian", "point", "vertex"
	representation: "expanded", "DOUBLE"
	access: "fixed"
	size: "fixed"
	contents: "DOUBLE"
	date: "$Date: 2004/07/23 18:51:02 $"
	revision: "$Revision: 1.1 $"
	author: "Todd Plessel, US EPA/LM, plessel.todd@epa.gov"
	status: "reviewed", "tested"

class

	POINT2
	
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

        make (initial_x, initial_y: DOUBLE) is
                        -- Initial cartesian component coordinates.
                do
                        x := initial_x
                        y := initial_y
                ensure
                        x_set: x = initial_x
                        y_set: y = initial_y
                end

        fill (initial_value: DOUBLE) is
                        -- Set each `item' to `initial_value'.
                do
                        x := initial_value
                        y := initial_value
                ensure then
                        x_is_initial_value: x = initial_value
                        y_is_initial_value: y = initial_value
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
                end

feature -- Access

        x: DOUBLE
                        -- X-coordinate.

        y: DOUBLE
                        -- Y-coordinate.

	zero: POINT2 is
			-- Neutral element for "+" and "-".
		once
			create Result
		end

	one: POINT2 is
			-- Neutral element for "*".
		once
			create Result
			fill (1.0)
		end

        two_norm, magnitude, to_real: DOUBLE is
                        -- Euclidean magnitude (square-root of the sum of the squares of
                        -- the components).
                do
                        Result := square_root (magnitude_squared)
                end

        magnitude_squared: DOUBLE is
                        -- Project down to a real by sum of squares.
                do
                        Result := x * x + y * y
                end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN is
			-- Is each corresponding `item' within `Tolerance'?
		do
			Result := about_equal (x, other.x) and then
						about_equal (y, other.y)
		ensure then
			result_correct:
				Result = (about_equal (x, other.x) and about_equal (y, other.y))
		end

	infix "<" (other: POINT2): BOOLEAN is
			-- Is to_real < other.to_real?
		do
			Result := to_real <	other.to_real
		end

feature -- Basic operations

	prefix "-": POINT2 is
			-- Negative of `Current'.
		do
			create Result.make (-x, -y)
		ensure
			result_x_is_x_negated: Result.x = -x
			result_y_is_y_negated: Result.y = -y
		end

	prefix "+": POINT2 is
			-- Positive of `Current'.
		do
			create Result.make (x, y)
		ensure
			result_x_is_x: Result.x = x
			result_y_is_y: Result.y = y
		end

	infix "*" (scalar: DOUBLE): POINT2 is
			-- `Current' scaled by a real.
		local
			result_x, result_y: DOUBLE
		do
			if scalar /= 0.0 then

				if x /= 0.0 then
					result_x := x * scalar
				end

				if y /= 0.0 then
					result_y := y * scalar
				end

				create Result.make (result_x, result_y)
			end
		ensure then
			result_x_correct: Result.x = x * scalar
			result_y_correct: Result.y = y * scalar
		end

	distance_squared (other: POINT2): DOUBLE is
			-- Square of Euclidean distance to `other'.
		local
			left, right: DOUBLE
		do
			left := other.x
			right := x

			if left /= right then
					-- Avoid nan (e.g., 0.0 * -inf).
				Result := square (left - right)
			end

			left := other.y
			right := y

			if left /= right then
					-- Avoid nan (e.g., 0.0 * -inf).
				Result := Result + square (left - right)
			end
		ensure
			result_correct: Result = square (x - other.x) +
									square (y - other.y)
		end

end -- class POINT2
