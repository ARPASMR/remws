



indexing
    description: "A virtual trackball"
    names: "trackball", "arcball"
    representation: "quaterion"
    access: "fixed"
    size: "fixed"
    contents: "QUATERNION", "DOUBLE", "TRANSFORM"
    patterns: "none"
    date: "$DateTime: 2002/07/12 17:10:09 $"
    revision: "$Revision: 1.1 $"
    author: "$Author: renderdude $"
    status: "unreviewed"




class 

	TRACKBALL

inherit
	
	BASIC_NUMERIC

creation
	make

feature -- Initialization

	make (window_width, window_height: INTEGER) is
			-- Create an arcball with `window_width`, `window_height`
		require 
			window_width_is_positive: window_width > 0
			window_height_is_positive: window_height > 0
		do
			q := update (0, 0, 0, 0)
			tracking := false
			
			set_width (window_width)
			set_height (window_height)
			
			create beginning_pt
			create tmp_vec
		end

feature -- Access
	
	track_ball_radius: DOUBLE is 0.8
	
	trackball_matrix: TRANSFORM is
			-- Return the rotation matrix corresponding to the trackball
		do
			Result := q.rotation_matrix
		end

feature -- Measurement
feature -- Comparison
feature -- Status report
	
	x_location, y_location: DOUBLE
	
feature -- Status setting
	
	set_width (new_width: INTEGER) is
			-- Set the width of the trackball's domain
		require 
			new_width_is_positive: new_width > 0
		do
			width := new_width
		ensure 
			width_set: width = new_width
		end -- set_width

	set_height (new_height: INTEGER) is
			-- Set the height of the trackball's domain
		require 
			new_height_is_positive: new_height > 0
		do
			height := new_height
		ensure 
			height_set: height = new_height
		end -- set_height

feature -- Cursor movement
feature -- Element change
	
	step_animation is
			-- Update the position of the trackball
		do
			q := q * last
--			q.normalize
		end -- step_animation
	
	start_motion (new_pt: POINT2) is
			-- Update the necessary parameters for trackball motion
		require
			new_pt_not_void: new_pt /= Void
		do
			tracking := true
			beginning_pt.copy (new_pt)
		end -- start_motion
	
	stop_motion is
			-- 
		do
			tracking := false
		end -- stop_motion

feature -- Removal
feature -- Resizing
feature -- Transformation
feature -- Conversion
feature -- Duplication
feature -- Basic operations
	
	grab_event (down: BOOLEAN; new_pt: POINT2) is
			-- Process the grab/release of the trackball
		require
			new_pt_not_void: new_pt /= Void
		do
			if down then
				start_motion (new_pt)
			else
				stop_motion
			end
		end -- grab_event
	
	rotate_event (new_pt: POINT2) is
			-- Process the dragging of the trackball
		require
			new_pt_not_void: new_pt /= Void
		do
			if tracking then
				last := update ((2.0 * beginning_pt.x - width)/width,
								(height - 2.0 * beginning_pt.y)/height,
								(2.0 * new_pt.x - width)/width,
								(height - 2.0 * new_pt.y)/height)
				beginning_pt.copy (new_pt)
				
				step_animation
			end
		ensure 
			ball_updated: equal (beginning_pt, new_pt)
		end -- rotate_event
	
feature -- Miscellaneous
feature -- Obsolete
feature -- Inapplicable
feature {NONE} -- Implementation
	
	q, last: QUATERNION
	
	width, height: DOUBLE
	
	beginning_pt: POINT2
	
	tracking: BOOLEAN
	
	tmp_vec: VECTOR3
			-- Temporary vector for computation
	
	project_to_sphere (x, y: DOUBLE): DOUBLE is
			-- Project a 2d point onto a sphere of radius `track_ball_radius' 
			-- OR a hyberbolic sheet if we are away from the center 
			-- of the sphere.
		local
			t: DOUBLE
		do
			t := square_root (x *x + y * y)
			if t < track_ball_radius * 0.70710678118654752440 then
				Result := square_root (track_ball_radius * track_ball_radius - t * t)
			else
				Result := track_ball_radius / 1.41421356237309504880
				Result := Result * Result / t
			end
		end -- project_to_sphere

	update (p1x, p1y, p2x, p2y: DOUBLE): QUATERNION is
			-- Update the trackball to the new position
		local
			p1, p2, qv, d: VECTOR3
			phi, w: DOUBLE
		do
			if p1x = p2x and p1y = p2y then
				create Result.make (0, 0, 0, 1.0)
			else
				create p1.make (p1x, p1y, project_to_sphere(p1x, p1y))
				create p2.make (p2x, p2y, project_to_sphere(p2x, p2y))
				
				qv := p2 * p1
				d := p1 - p2
				w := d.magnitude / (2.0 * track_ball_radius)

				if w > 1.0 then
					w := 1.0
				elseif w < -1.0 then
					w := -1.0
				end

				phi := 2.0 * arc_sine (w)
				qv.normalize
				qv := qv.scale (sine (phi / 2.0))
				create Result.make (qv.x, qv.y, qv.z, cosine (phi / 2.0))
			end
		ensure 
			result_not_void: Result /= Void
		end -- update

invariant
	
	beginning_pt_not_void: beginning_pt /= Void
	height_and_width_positive: height >= 0 and width >= 0
	begin_positive: beginning_pt.x >= 0 and beginning_pt.y >= 0
	
end -- TRACKBALL

