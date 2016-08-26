indexing

	description: "Mixin constants and routines for basic numeric types."
	names: "type", "integer", "float", "real", "double", "math"
	patterns: "mixin"
	date: "$DateTime: 2002/08/14 16:17:40 $"
	revision: "$Revision: 1.1 $"
	author: "$Author: renderdude $"
	status: "reviewed", "tested", "partial", "unimplemented: Maximum_integer"
	"unimplemented: Minimum_integer",
	"unimplemented: next_strictly_positive_integer"

expanded class

	BASIC_NUMERIC

feature {NONE} -- Access

	Pi: DOUBLE is
			-- Pi.
		external
			"C macro use <math.h>"
		alias
			"M_PI"
		end

	Pi_over_two: DOUBLE is
			-- Pi / 2.
		external
			"C macro use <math.h>"
		alias
			"M_PI_2"
		end

	Pi_over_four: DOUBLE is
			-- Pi / 4.
		external
			"C macro use <math.h>"
		alias
			"M_PI_4"
		end

	Tolerance: DOUBLE is 1.0e-6
			-- Basic recommended tolerance for numerical round-off error.

feature {NONE} -- Comparison

	about_equal (a, b: DOUBLE): BOOLEAN is
			-- Do `a' and `b' differ by not more than `Tolerance'?
		do
			Result := (a - b).abs <= Tolerance
		end

	within_range (x, lower, upper: DOUBLE): BOOLEAN is
			-- Is `x' within [`lower', `upper']?
		require
			ordered: lower <= upper
		do
			Result := x >= lower and then x <= upper
		ensure
			result_correct: Result = (x >= lower and x <= upper)
		end

feature {NONE} -- Conversion

	truncate (x: DOUBLE): INTEGER is
			-- Truncate `x' to its integer part.
		external
			"C macro use <stddef.h>"
		alias
			" "
		end

	radians (the_degrees: DOUBLE): DOUBLE is
			-- Convert degrees to radians.
		do
			Result := the_degrees * (Pi / 180.0)
		ensure
			result_is_same_sign_or_zero:
				Result.sign = the_degrees.sign or else Result = 0.0
		end

	degrees (the_radians: DOUBLE): DOUBLE is
			-- Convert radians to degrees.
		do
			Result := the_radians * (180.0 / Pi)
		ensure
			result_is_same_sign_or_zero:
				Result.sign = the_radians.sign or else Result = 0.0
		end

	clamp_to_range (x, lower, upper: DOUBLE): DOUBLE is
			-- Value within range or nearest endpoint.
		require
			ordered: lower <= upper
		do
			if x < lower then
				Result := lower
			elseif x > upper then
				Result := upper
			else
				Result := x
			end
		ensure
			result_in_range: lower <= Result and Result <= upper
		end

feature {NONE} -- Basic operations

	square_root (x: DOUBLE): DOUBLE is
			-- Square-root of `x'.
		require
			non_negative_argument: x >= 0.0
		external
			"C use <math.h>"
		alias
			"sqrt"
		end

	square (x: DOUBLE): DOUBLE is
			-- `x' * `x'.
		do
			Result := x * x
		end

	cube (x: DOUBLE): DOUBLE is
			-- `x' * `x' * `x'.
		do
			Result := x * x * x
		end

	power_of_two (exponent: INTEGER): INTEGER is
			-- 2^exponent.
		require
			exponent_non_negative: exponent >= 0
			exponent_small_enough: exponent <= 31
		local
			iteration: INTEGER
		do
			from
				iteration := 1
				Result := 1
			until
				iteration > exponent
			loop
				Result := Result + Result
				iteration := iteration + 1
			end
		ensure
			result_is_strictly_positive: Result >= 1
			result_is_correct:
				(exponent = 0 and Result = 1) or
				(exponent > 0 and Result \\ 2 = 0)
				-- log2 (Result) = exponent.
		end

	sign (x: DOUBLE): DOUBLE is
			-- -1.0 if x < 0.0 else 1.0.
		do
			if x < 0.0 then
				Result := -1.0
			else
				Result := 1.0
			end
		end

	absolute_value (x: DOUBLE): DOUBLE is
			-- |`x'|.
		external
			"C use <math.h>"
		alias
			"fabs"
		end

	integer_absolute_value (x: INTEGER): INTEGER is
			-- |`x'|.
		do
			if x >= 0 then
				Result := x
			else
				Result := -x
			end

			if Result < 0 then
					-- Convert maximum magnitude negative integer to
					-- maximum positive integer.
				Result := -(Result + 1)
			end
		ensure
			non_negative: Result >= 0
		end

	hypotenuse (x, y: DOUBLE): DOUBLE is
			-- Length of hypotenuse of right triangle with sides `x' and `y'.
		require
			positive_x: x > 0.0
			positive_y: y > 0.0
		external
			"C use <math.h>"
		alias
			"hypot"
		end

	arc_tangent2 (y, x: DOUBLE): DOUBLE is
			-- Inverse tangent of `y' / `x'.
		require
			non_zero_x: x /= 0.0
		external
			"C use <math.h>"
		alias
			"atan2"
		end

	power (x, y: DOUBLE): DOUBLE is
			-- x^y
		require
			non_zero_y: y /= 0.0
		external
			"C use <math.h>"
		alias
			"pow"
		end

	sinh (x: DOUBLE): DOUBLE is
			-- Hyperbolic sine of `x'.
		external
			"C use <math.h>"
		end

	cosh (x: DOUBLE): DOUBLE is
			-- Hyperbolic cosine of `x'.
		external
			"C use <math.h>"
		end

	tanh (x: DOUBLE): DOUBLE is
			-- Hyperbolic tangent of `x'.
		external
			"C use <math.h>"
		end

	memory_copy (destination, source: POINTER; byte_count: INTEGER) is
			-- Copy `byte_count' bytes from `source' to `destination'.
		require
			destination_exists: destination /= destination.default
			source_exists: source /= source.default
			byte_count_strictly_positive: byte_count >= 1
		external
			"C use <string.h>"
		alias
			"memcpy"
		end

	uniform_random_value: DOUBLE is
			-- Yield a (48-bit) number in [0, 1] that is from a pseudo-random,
			-- uniformly distributed sequence.
		external
			"C use <stdlib.h>"
		alias
			"drand48"
		ensure
			result_at_least_zero: Result >= 0.0
			result_at_most_one: Result <= 1.0
		end

feature {NONE} -- Implementation

	exp (x: DOUBLE): DOUBLE is
			-- Exponential of `v'.
		external
			"C use <math.h>"
		end

	cosine (v: DOUBLE): DOUBLE is
			-- Trigonometric cosine of radian `v' approximated
			-- in the range [-pi/4, +pi/4]
		external
			"C use <math.h>"
		alias
			"cos"
		end

	arc_cosine (v: DOUBLE): DOUBLE is
			-- Trigonometric arccosine of radian `v'
			-- in the range [0, pi]
		external
			"C use <math.h>"
		alias
			"acos"
		end

	sine (v: DOUBLE): DOUBLE is
			-- Trigonometric sine of radian `v' approximated
			-- in range [-pi/4, +pi/4]
		external
			"C use <math.h>"
		alias
			"sin"
		end

	arc_sine (v: DOUBLE): DOUBLE is
			-- Trigonometric arcsine of radian `v'
			-- in the range [-pi/2, +pi/2]
		external
			"C use <math.h>"
		alias
			"asin"
		end

	tangent (v: DOUBLE): DOUBLE is
			-- Trigonometric tangent of radian `v' approximated
			-- in range [-pi/4, +pi/4]
		external
			"C use <math.h>"
		alias
			"tan"
		end

	arc_tangent (v: DOUBLE): DOUBLE is
			-- Trigonometric arctangent of radian `v'
			-- in the range [-pi/2, +pi/2]
		external
			"C use <math.h>"
		alias
			"atan"
		end

	sqrt (v: DOUBLE): DOUBLE is
			-- Square root of `v'
		external
			"C use <math.h>"
		end

invariant

	tolerance_small_enough: Tolerance < 1.0

end -- class BASIC_NUMERIC
