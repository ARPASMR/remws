indexing

	description: "Graphical transforms implemented as a 4 x 4 real matrix."
	names: "matrix", "transform"
	representation: "expanded", "DOUBLE"
	access: "fixed"
	size: "fixed"
	contents: "DOUBLE"
	date: "$Date: 2004/12/07 13:05:35 $"
	revision: "$Revision: 1.2 $"
	author: "Mark Bolstad, US EPA/LM, bolstad.mark@epa.gov"
	status: "unreviewed", "untested"

class

	TRANSFORM

inherit

	BASIC_NUMERIC
		undefine
			default_create, is_equal
		end
	
creation
	make, default_create, make_identity, make_with_elements
	
feature -- Initialization

	make, default_create is
			-- 
		do
			update_required := true
			make_identity
		end

        make_identity is
                        -- Make `Current' the neutral element for "*".
		do
			update_required := true
                        fill (0.0)
                        a11 := 1.0
                        a22 := 1.0
                        a33 := 1.0
                        a44 := 1.0
                ensure then
                        diagonals_are_one:
                                a11 = 1.0 and a22 = 1.0 and a33 = 1.0 and a44 =
1.0
                        rest_are_zero:
                                a12 = 0.0 and a13 = 0.0 and a14 = 0.0 and
                                a21 = 0.0 and a23 = 0.0 and a24 = 0.0 and
                                a31 = 0.0 and a32 = 0.0 and a34 = 0.0 and
                                a41 = 0.0 and a42 = 0.0 and a43 = 0.0
                end

        make_with_elements (x1, y1, z1, w1,
                                                x2, y2, z2, w2,
                                                x3, y3, z3, w3,
                                                x4, y4, z4, w4: DOUBLE) is
                        -- Create with the given elements.
                do
                        update_required := true

                        a11 := x1
                        a12 := y1
                        a13 := z1
                        a14 := w1
                        a21 := x2
                        a22 := y2
                        a23 := z2
                        a24 := w2
                        a31 := x3
                        a32 := y3
                        a33 := z3
                        a34 := w3
                        a41 := x4
                        a42 := y4
                        a43 := z4
                        a44 := w4
                ensure
                        a11_is_x1: about_equal (a11, x1)
                        a12_is_y1: about_equal (a12, y1)
                        a13_is_z1: about_equal (a13, z1)
                        a14_is_w1: about_equal (a14, w1)
                        a21_is_x2: about_equal (a21, x2)
                        a22_is_y2: about_equal (a22, y2)
                        a23_is_z2: about_equal (a23, z2)
                        a24_is_w2: about_equal (a24, w2)
                        a31_is_x3: about_equal (a31, x3)
                        a32_is_y3: about_equal (a32, y3)
                        a33_is_z3: about_equal (a33, z3)
                        a34_is_w3: about_equal (a34, w3)
                        a41_is_x1: about_equal (a41, x4)
                        a42_is_y1: about_equal (a42, y4)
                        a43_is_z1: about_equal (a43, z4)
                        a44_is_w1: about_equal (a44, w4)
                end

        fill (initial_value: DOUBLE) is
                        -- Set each element equal to `value'.
                do
                        update_required := true

                        a11 := initial_value
                        a12 := initial_value
                        a13 := initial_value
                        a14 := initial_value
                        a21 := initial_value
                        a22 := initial_value
                        a23 := initial_value
                        a24 := initial_value
                        a31 := initial_value
                        a32 := initial_value
                        a33 := initial_value
                        a34 := initial_value
                        a41 := initial_value
                        a42 := initial_value
                        a43 := initial_value
                        a44 := initial_value
                ensure then
                        a11_is_value: about_equal (a11, initial_value)
                        a12_is_value: about_equal (a12, initial_value)
                        a13_is_value: about_equal (a13, initial_value)
                        a14_is_value: about_equal (a14, initial_value)
                        a21_is_value: about_equal (a21, initial_value)
                        a22_is_value: about_equal (a22, initial_value)
                        a23_is_value: about_equal (a23, initial_value)
                        a24_is_value: about_equal (a24, initial_value)
                        a31_is_value: about_equal (a31, initial_value)
                        a32_is_value: about_equal (a32, initial_value)
                        a33_is_value: about_equal (a33, initial_value)
                        a34_is_value: about_equal (a34, initial_value)
                        a41_is_value: about_equal (a41, initial_value)
                        a42_is_value: about_equal (a42, initial_value)
                        a43_is_value: about_equal (a43, initial_value)
                        a44_is_value: about_equal (a44, initial_value)
                end

feature -- Access

        a11, a12, a13, a14,
        a21, a22, a23, a24,
        a31, a32, a33, a34,
        a41, a42, a43, a44: DOUBLE
                        -- The matrix elements subscripted by (row, column).

        item (row, column: INTEGER): DOUBLE is
                        -- Element at coordinates (`row', `column').
                do
                        inspect
                                row
                        when 1 then
                                inspect
                                        column
                                when 1 then
                                        Result := a11
                                when 2 then
                                        Result := a12
                                when 3 then
                                        Result := a13
                                when 4 then
                                        Result := a14
                                end
                        when 2 then
                                inspect
                                        column
                                when 1 then
                                        Result := a21
                                when 2 then
                                        Result := a22
                                when 3 then
                                        Result := a23
                                when 4 then
                                        Result := a24
                                end
                        when 3 then
                                inspect
                                        column
                                when 1 then
                                        Result := a31
                                when 2 then
                                        Result := a32
                                when 3 then
                                        Result := a33
                                when 4 then
                                        Result := a34
                                end
                        when 4 then
                                inspect
                                        column
                                when 1 then
                                        Result := a41
                                when 2 then
                                        Result := a42
                                when 3 then
                                        Result := a43
                                when 4 then
                                        Result := a44
                                end
                        end
                end

	one: TRANSFORM is
			-- Neutral element for "*".
		once
			create Result.make_identity
		end

feature -- Measurement

        column_count: INTEGER is 4
                        -- Number of columns.

        row_count: INTEGER is 4
                        -- Number of rows.

        count: INTEGER is 16
                        -- Total number of elements

feature -- Comparison

	is_equal (other: TRANSFORM): BOOLEAN is
			-- Is each corresponding `item' within `Tolerance'?
		do
			Result := (about_equal (a11, other.a11) and then
						about_equal (a12, other.a12) and then
						about_equal (a13, other.a13) and then
						about_equal (a14, other.a14) and then

						about_equal (a21, other.a21) and then
						about_equal (a22, other.a22) and then
						about_equal (a23, other.a23) and then
						about_equal (a24, other.a24) and then

						about_equal (a31, other.a31) and then
						about_equal (a32, other.a32) and then
						about_equal (a33, other.a33) and then
						about_equal (a34, other.a34) and then

						about_equal (a41, other.a41) and then
						about_equal (a42, other.a42) and then
						about_equal (a43, other.a43) and then
						about_equal (a44, other.a44))
		end

feature -- Status report
	
	is_identity: BOOLEAN is
			-- Is this transform the identity?
		do
			Result := is_equal (one)
		end 
	
        is_pure_rotation: BOOLEAN is
                        -- Does `Current' consist of only rotations?
                local
                        tmp: TRANSFORM
		do
			if about_equal (a14, 0) and about_equal (a41, 0) and
				about_equal (a24, 0) and about_equal (a42, 0) and
				about_equal (a34, 0) and about_equal (a43, 0) and
				about_equal (a44, 1) then
				tmp := clone (Current)
				tmp.transpose
				if equal (tmp * Current, one) then
					check
						determinant_is_one: about_equal (determinant, 1)
					end
					Result := true
				end
			end
		end

feature -- Status setting

	reset is
			-- Reset transfom
		do
			make_identity
		ensure
			Identity: is_identity
		end

feature -- Cursor movement
feature -- Element change
	
    put (value: like item; row, column: INTEGER) is
            -- Make `item' (`row', `column') = `value'.
        do
            update_required := true

            inspect
                row
            when 1 then
                inspect
                    column
                when 1 then
                    a11 := value
                when 2 then
                    a12 := value
                when 3 then
                    a13 := value
                when 4 then
                    a14 := value
                end
            when 2 then
                inspect
                    column
                when 1 then
                    a21 := value
                when 2 then
                    a22 := value
                when 3 then
                    a23 := value
                when 4 then
                    a24 := value
                end
            when 3 then
                inspect
                    column
                when 1 then
                    a31 := value
                when 2 then
                    a32 := value
                when 3 then
                    a33 := value
                when 4 then
                    a34 := value
                end
            when 4 then
                inspect
                    column
                when 1 then
                    a41 := value
                when 2 then
                    a42 := value
                when 3 then
                    a43 := value
                when 4 then
                    a44 := value
				end
			end
		end
	
	rotate (angle: DOUBLE; axis: VECTOR3) is
			-- Apply the rotation, `angle' (in radians) to Current.
		require
			axis_normalized: axis.is_unit
		local
			xform: TRANSFORM
			sin_n, cos_n: DOUBLE
		do
			cos_n := cosine (angle)
			sin_n := sine (angle)
			create xform
			xform.create_rotation_matrix (angle, axis, sin_n, cos_n)

			xform := Current * xform
			Current.copy (xform)
			
			update_required := true
		end

	translate (x, y, z: DOUBLE) is
			-- Apply a translation to the current transformation.
		local
			xform: TRANSFORM
		do
			create xform
			xform.put (x, 1, 4)
			xform.put (y, 2, 4)
			xform.put (z, 3, 4)

			xform := Current * xform
			Current.copy (xform)
			
			update_required := true
		end

	scale (x, y, z: DOUBLE) is
			-- Apply a scale to the current transform.
		local
			xform: TRANSFORM
		do
			create xform
			xform.put (x, 1, 1)
			xform.put (y, 2, 2)
			xform.put (z, 3, 3)
			
			xform := Current * xform
			Current.copy (xform)
			
			update_required := true
		end
	
feature -- Removal
feature -- Resizing
feature -- Transformation
	
        transpose is
                        -- Transpose the current matrix.
                local
                        tmp: DOUBLE
                do
                        update_required := true

                        tmp := a12
                        a12 := a21
                        a21 := tmp

                        tmp := a13
                        a13 := a31
                        a31 := tmp

                        tmp := a14
                        a14 := a41
                        a41 := tmp

                        tmp := a23
                        a23 := a32
                        a32 := tmp

                        tmp := a24
                        a24 := a42
                        a42 := tmp

                        tmp := a34
                        a34 := a43
                        a43 := tmp
                ensure then
                        a11_is_correct: about_equal (a11, old a11)
                        a12_is_correct: about_equal (a12, old a21)
                        a13_is_correct: about_equal (a13, old a31)
                        a14_is_correct: about_equal (a14, old a41)
                        a21_is_correct: about_equal (a21, old a12)
                        a22_is_correct: about_equal (a22, old a22)
                        a23_is_correct: about_equal (a23, old a32)
                        a24_is_correct: about_equal (a24, old a42)
                        a31_is_correct: about_equal (a31, old a13)
                        a32_is_correct: about_equal (a32, old a23)
                        a33_is_correct: about_equal (a33, old a33)
                        a34_is_correct: about_equal (a34, old a43)
                        a41_is_correct: about_equal (a41, old a14)
                        a42_is_correct: about_equal (a42, old a24)
                        a43_is_correct: about_equal (a43, old a34)
                        a44_is_correct: about_equal (a44, old a44)
                end

feature -- Conversion
        to_array: EWG_DOUBLE_ARRAY is
                        -- Create a row-major 1-d array from the elements of `Current'.
		do
			create Result.make_new_unshared (16)
			to_array_argument (Result)
		ensure
			Result_not_void: Result /= Void
			correct_count: Result.count = 16
			a11_stored: about_equal (a11, Result.item (0))
			a12_stored: about_equal (a12, Result.item (1))
			a13_stored: about_equal (a13, Result.item (2))
			a14_stored: about_equal (a14, Result.item (3))
			a21_stored: about_equal (a21, Result.item (4))
			a22_stored: about_equal (a22, Result.item (5))
			a23_stored: about_equal (a23, Result.item (6))
			a24_stored: about_equal (a24, Result.item (7))
			a31_stored: about_equal (a31, Result.item (8))
			a32_stored: about_equal (a32, Result.item (9))
			a33_stored: about_equal (a33, Result.item (10))
			a34_stored: about_equal (a34, Result.item (11))
			a41_stored: about_equal (a41, Result.item (12))
			a42_stored: about_equal (a42, Result.item (13))
			a43_stored: about_equal (a43, Result.item (14))
			a44_stored: about_equal (a44, Result.item (15))
		end

        to_array_argument (a: EWG_DOUBLE_ARRAY) is
                        -- Replace the items of `a' with the row-major elementsof `Current'.
		require
			a_not_void: a /= Void
			a_correct_size: a.count = 16
		local
			index: INTEGER
		do
			index := 0
			a.put (a11, index)
			a.put (a12, index + 1)
			a.put (a13, index + 2)
			a.put (a14, index + 3)
			
			a.put (a21, index + 4)
			a.put (a22, index + 5)
			a.put (a23, index + 6)
			a.put (a24, index + 7)
			
			a.put (a31, index + 8)
			a.put (a32, index + 9)
			a.put (a33, index + 10)
			a.put (a34, index + 11)
			
			a.put (a41, index + 12)
			a.put (a42, index + 13)
			a.put (a43, index + 14)
			a.put (a44, index + 15)
		ensure
			a11_stored: about_equal (a11, a.item (0))
			a12_stored: about_equal (a12, a.item (1))
			a13_stored: about_equal (a13, a.item (2))
			a14_stored: about_equal (a14, a.item (3))
			a21_stored: about_equal (a21, a.item (4))
			a22_stored: about_equal (a22, a.item (5))
			a23_stored: about_equal (a23, a.item (6))
			a24_stored: about_equal (a24, a.item (7))
			a31_stored: about_equal (a31, a.item (8))
			a32_stored: about_equal (a32, a.item (9))
			a33_stored: about_equal (a33, a.item (10))
			a34_stored: about_equal (a34, a.item (11))
			a41_stored: about_equal (a41, a.item (12))
			a42_stored: about_equal (a42, a.item (13))
			a43_stored: about_equal (a43, a.item (14))
			a44_stored: about_equal (a44, a.item (15))
		end

feature -- Duplication
feature -- Basic operations
	
        to_real, determinant: DOUBLE is
                        -- Compute the determinant.
                do
                        Result := a11 * determinant3 (a22, a23, a24,
                                                                               a32, a33, a34,
                                                                               a42, a43, a44)
                                        - a21 * determinant3 (a12, a13, a14,
                                                                               a32, a33, a34,
                                                                               a42, a43, a44)
                                        + a31 * determinant3 (a12, a13, a14,
                                                                               a22, a23, a24,
                                                                               a42, a43, a44)
                                        - a41 * determinant3 (a12, a13, a14,
                                                                               a22, a23, a24,
                                                                               a32, a33, a34)
                end

	concatonate_transform (xform: TRANSFORM) is
			-- Append `xform' to `Current'
		require 
			xform_not_void: xform /= Void
		local
			tmp: TRANSFORM
		do
			tmp := Current * xform 
			Current.copy (tmp)
			
			update_required := true
		end 

	infix "*" (o: TRANSFORM): TRANSFORM is
			-- Product by `o'.
		do
			create Result.make_with_elements (
						a11 * o.a11 + a12 * o.a21 + a13 * o.a31 + a14 * o.a41,
						a11 * o.a12 + a12 * o.a22 + a13 * o.a32 + a14 * o.a42,
						a11 * o.a13 + a12 * o.a23 + a13 * o.a33 + a14 * o.a43,
						a11 * o.a14 + a12 * o.a24 + a13 * o.a34 + a14 * o.a44,
						a21 * o.a11 + a22 * o.a21 + a23 * o.a31 + a24 * o.a41,
						a21 * o.a12 + a22 * o.a22 + a23 * o.a32 + a24 * o.a42,
						a21 * o.a13 + a22 * o.a23 + a23 * o.a33 + a24 * o.a43,
						a21 * o.a14 + a22 * o.a24 + a23 * o.a34 + a24 * o.a44,
						a31 * o.a11 + a32 * o.a21 + a33 * o.a31 + a34 * o.a41,
						a31 * o.a12 + a32 * o.a22 + a33 * o.a32 + a34 * o.a42,
						a31 * o.a13 + a32 * o.a23 + a33 * o.a33 + a34 * o.a43,
						a31 * o.a14 + a32 * o.a24 + a33 * o.a34 + a34 * o.a44,
						a41 * o.a11 + a42 * o.a21 + a43 * o.a31 + a44 * o.a41,
						a41 * o.a12 + a42 * o.a22 + a43 * o.a32 + a44 * o.a42,
						a41 * o.a13 + a42 * o.a23 + a43 * o.a33 + a44 * o.a43,
						a41 * o.a14 + a42 * o.a24 + a43 * o.a34 + a44 * o.a44)
		end

	infix "+" (other: TRANSFORM): TRANSFORM is
			-- Sum with `other' (commutative).
		do
			create Result.make_with_elements (
						(a11 + other.a11),
						(a12 + other.a12),
						(a13 + other.a13),
						(a14 + other.a14),
						(a21 + other.a21),
						(a22 + other.a22),
						(a23 + other.a23),
						(a24 + other.a24),
						(a31 + other.a31),
						(a32 + other.a32),
						(a33 + other.a33),
						(a34 + other.a34),
						(a41 + other.a41),
						(a42 + other.a42),
						(a43 + other.a43),
						(a44 + other.a44))
		ensure then
			result_a11_is_sum: about_equal (Result.a11,
											(a11 + other.a11))
			result_a12_is_sum: about_equal (Result.a12, 
											(a12 + other.a12))
			result_a13_is_sum: about_equal (Result.a13, 
											(a13 + other.a13))
			result_a14_is_sum: about_equal (Result.a14, 
											(a14 + other.a14))
			result_a21_is_sum: about_equal (Result.a21, 
											(a21 + other.a21))
			result_a22_is_sum: about_equal (Result.a22, 
											(a22 + other.a22))
			result_a23_is_sum: about_equal (Result.a23, 
											(a23 + other.a23))
			result_a24_is_sum: about_equal (Result.a24, 
											(a24 + other.a24))
			result_a31_is_sum: about_equal (Result.a31, 
											(a31 + other.a31))
			result_a32_is_sum: about_equal (Result.a32, 
											(a32 + other.a32))
			result_a33_is_sum: about_equal (Result.a33, 
											(a33 + other.a33))
			result_a34_is_sum: about_equal (Result.a34, 
											(a34 + other.a34))
			result_a41_is_sum: about_equal (Result.a41, 
											(a41 + other.a41))
			result_a42_is_sum: about_equal (Result.a42, 
											(a42 + other.a42))
			result_a43_is_sum: about_equal (Result.a43, 
											(a43 + other.a43))
			result_a44_is_sum: about_equal (Result.a44, 
											(a44 + other.a44))
		end

	infix "-" (other: TRANSFORM): TRANSFORM is
			-- Result of subtracting `other'.
		do
			create Result.make_with_elements (
						(a11 - other.a11),
						(a12 - other.a12),
						(a13 - other.a13),
						(a14 - other.a14),
						(a21 - other.a21),
						(a22 - other.a22),
						(a23 - other.a23),
						(a24 - other.a24),
						(a31 - other.a31),
						(a32 - other.a32),
						(a33 - other.a33),
						(a34 - other.a34),
						(a41 - other.a41),
						(a42 - other.a42),
						(a43 - other.a43),
						(a44 - other.a44))
		ensure then
			result_a11_is_difference: about_equal (Result.a11, 
												   (a11 - other.a11))
			result_a12_is_difference: about_equal (Result.a12, 
												   (a12 - other.a12))
			result_a13_is_difference: about_equal (Result.a13, 
												   (a13 - other.a13))
			result_a14_is_difference: about_equal (Result.a14, 
												   (a14 - other.a14))
			result_a21_is_difference: about_equal (Result.a21, 
												   (a21 - other.a21))
			result_a22_is_difference: about_equal (Result.a22, 
												   (a22 - other.a22))
			result_a23_is_difference: about_equal (Result.a23, 
												   (a23 - other.a23))
			result_a24_is_difference: about_equal (Result.a24, 
												   (a24 - other.a24))
			result_a31_is_difference: about_equal (Result.a31, 
												   (a31 - other.a31))
			result_a32_is_difference: about_equal (Result.a32, 
												   (a32 - other.a32))
			result_a33_is_difference: about_equal (Result.a33, 
												   (a33 - other.a33))
			result_a34_is_difference: about_equal (Result.a34, 
												   (a34 - other.a34))
			result_a41_is_difference: about_equal (Result.a41, 
												   (a41 - other.a41))
			result_a42_is_difference: about_equal (Result.a42, 
												   (a42 - other.a42))
			result_a43_is_difference: about_equal (Result.a43, 
												   (a43 - other.a43))
			result_a44_is_difference: about_equal (Result.a44, 
												   (a44 - other.a44))
		end

	infix "^" (exponent: NUMERIC): like Current is
			-- Current raised to the power `exponent'.
		do
				check
					implemented: False
				end
		end

	prefix "+": TRANSFORM is
			-- Unary plus.
		do
---			Result := Current
			create Result.make_with_elements (a11, a12, a13, a14,
										a21, a22, a23, a24,
										a31, a32, a33, a34,
										a41, a42, a43, a44)
		end

	prefix "-": TRANSFORM is
			-- Unary minus
		do
			create Result.make_with_elements (-a11, -a12, -a13, -a14,
										-a21, -a22, -a23, -a24,
										-a31, -a32, -a33, -a34,
										-a41, -a42, -a43, -a44)
		ensure then
			result_a11_is_negated: about_equal (result.a11, -a11)
			result_a12_is_negated: about_equal (result.a12, -a12)
			result_a13_is_negated: about_equal (result.a13, -a13)
			result_a14_is_negated: about_equal (result.a14, -a14)
			result_a21_is_negated: about_equal (result.a21, -a21)
			result_a22_is_negated: about_equal (result.a22, -a22)
			result_a23_is_negated: about_equal (result.a23, -a23)
			result_a24_is_negated: about_equal (result.a24, -a24)
			result_a31_is_negated: about_equal (result.a31, -a31)
			result_a32_is_negated: about_equal (result.a32, -a32)
			result_a33_is_negated: about_equal (result.a33, -a33)
			result_a34_is_negated: about_equal (result.a34, -a34)
			result_a41_is_negated: about_equal (result.a41, -a41)
			result_a42_is_negated: about_equal (result.a42, -a42)
			result_a43_is_negated: about_equal (result.a43, -a43)
			result_a44_is_negated: about_equal (result.a44, -a44)
		end

	matrix_scale (scalar: DOUBLE): TRANSFORM is
			-- Result of multiplying each element by `scalar'.
		do
			create Result.make_with_elements (
						a11 * scalar, a12 * scalar, a13 * scalar, a14 * scalar,
						a21 * scalar, a22 * scalar, a23 * scalar, a24 * scalar,
						a31 * scalar, a32 * scalar, a33 * scalar, a34 * scalar,
						a41 * scalar, a42 * scalar, a43 * scalar, a44 * scalar)
		ensure then
			result_a11_is_scaled: about_equal (result.a11, a11 * scalar)
			result_a12_is_scaled: about_equal (result.a12, a12 * scalar)
			result_a13_is_scaled: about_equal (result.a13, a13 * scalar)
			result_a14_is_scaled: about_equal (result.a14, a14 * scalar)
			result_a21_is_scaled: about_equal (result.a21, a21 * scalar)
			result_a22_is_scaled: about_equal (result.a22, a22 * scalar)
			result_a23_is_scaled: about_equal (result.a23, a23 * scalar)
			result_a24_is_scaled: about_equal (result.a24, a24 * scalar)
			result_a31_is_scaled: about_equal (result.a31, a31 * scalar)
			result_a32_is_scaled: about_equal (result.a32, a32 * scalar)
			result_a33_is_scaled: about_equal (result.a33, a33 * scalar)
			result_a34_is_scaled: about_equal (result.a34, a34 * scalar)
			result_a41_is_scaled: about_equal (result.a41, a41 * scalar)
			result_a42_is_scaled: about_equal (result.a42, a42 * scalar)
			result_a43_is_scaled: about_equal (result.a43, a43 * scalar)
			result_a44_is_scaled: about_equal (result.a44, a44 * scalar)
		end

	apply_as_direction (v: VECTOR3): VECTOR3 is
			-- Apply the current transformation. Treat `v' as a direction.
		require
			v_not_void: v /= Void
		local
			vx, vy, vz, sx, sy, sz, sw: DOUBLE
		do
			vx := v.x
			vy := v.y
			vz := v.z
			sx := a11 * vx + a12 * vy + a13 * vz
			sy := a21 * vx + a22 * vy + a23 * vz
			sz := a31 * vx + a32 * vy + a33 * vz

				-- For perspective and uniform scaling
			
			sw := a41 * vx + a42 * vy + a43 * vz

			if sw /= 1.0 and then sw /= 0.0 then
				sw := 1.0 / sw
				sx := sx * sw
				sy := sy * sw
				sz := sz * sw
			end

			create Result.make (sx, sy, sz)
		end

feature -- Miscellaneous
feature -- Obsolete
feature -- Inapplicable
feature {TRANSFORM} -- Implementation

	zero: TRANSFORM is
			-- Neutral element for "+" and "-".
		once
			create Result
			Result.fill (0.0)
		end

	create_rotation_matrix (angle: DOUBLE;
							axis: VECTOR3; 
							sin_t, cos_t: DOUBLE) is
			-- Apply the rotation to the current transform.
		local
			vx, vy, vz: DOUBLE
		do
			vx := axis.x
			vy := axis.y
			vz := axis.z

			a11 := vx * vx + (1.0 - vx * vx) * cos_t
			a12 := vx * vy * (1.0 - cos_t) - vz * sin_t
			a13 := vx * vz * (1.0 - cos_t) + vy * sin_t
			a14 := 0.0

			a21 := vx * vy * (1.0 - cos_t) + vz * sin_t
			a22 := vy * vy + (1.0 - vy * vy) * cos_t
			a23 := vy * vz * (1.0 - cos_t) - vx * sin_t
			a24 := 0.0

			a31 := vx * vz * (1.0 - cos_t) - vy * sin_t
			a32 := vy * vz * (1.0 - cos_t) + vx * sin_t
			a33 := vz * vz + (1.0 - vz * vz) * cos_t
			a34 := 0.0

			a41 := 0.0
			a42 := 0.0
			a43 := 0.0
			a44 := 1.0
			
		end

feature {NONE} -- Implementation
	
    update_required: BOOLEAN
            -- Has the matrix been updated?
	
	affine_adjugate (scalar: DOUBLE) is
			-- Form the scaled transpose of the cofactor matrix.
		local
			ta11, ta12, ta13, ta14,
			ta21, ta22, ta23, ta24,
			ta31, ta32, ta33, ta34: DOUBLE
		do
			ta11 := a11
			ta12 := a12
			ta13 := a13
			ta14 := a14
			
			ta21 := a21
			ta22 := a22
			ta23 := a23
			ta24 := a24
			
			ta31 := a31
			ta32 := a32
			ta33 := a33
			ta34 := a34
			
				-- Compute the transpose of the cofactors:
			
			a11 := scalar *  (ta22 * ta33 - ta32 * ta23)
			a12 := scalar * -(ta12 * ta33 - ta32 * ta13)
			a13 := scalar *  (ta12 * ta23 - ta22 * ta13)

			a21 := scalar * -(ta21 * ta33 - ta31 * ta23)
			a22 := scalar *  (ta11 * ta33 - ta31 * ta13)
			a23 := scalar * -(ta11 * ta23 - ta21 * ta13)

			a31 := scalar *  (ta21 * ta32 - ta31 * ta22)
			a32 := scalar * -(ta11 * ta32 - ta31 * ta12)
			a33 := scalar *  (ta11 * ta22 - ta21 * ta12)
			
			-- Calculate -C * inverse(A)
			a14 := -(ta14 * a11 + ta24 * a12 + ta34 * a13)
			a24 := -(ta14 * a21 + ta24 * a22 + ta34 * a23)
			a34 := -(ta14 * a31 + ta24 * a32 + ta34 * a33)
			
			-- Fill in the `affine' row
			a41 := 0.0
			a42 := 0.0
			a43 := 0.0
			a44 := 1.0
		end

        determinant3 (ta11, ta12, ta13,
                          ta21, ta22, ta23,
                                  ta31, ta32, ta33: DOUBLE): DOUBLE is
                        -- Determinant of the 3 x 3 matrix.
                        -- Computed by Laplace expansion of the first row.
                require
                        not_void: Current /= Void
                do
                        Result := ta11 * (ta22 * ta33 - ta23 * ta32)
                                        - ta21 * (ta12 * ta33 - ta13 * ta32)
                                        + ta31 * (ta12 * ta23 - ta13 * ta22)
                end

end -- class TRANSFORM

