do
	local buttons = {}
	local function generate(px, py, w, h, nx, ny, sx, sy, code)
		local cp = 1
		for iy = 0, ny - 1 do
			for ix = 0, nx - 1 do
				table.insert(buttons, {px + ix*sx, py + iy*sy, w, h, code[cp], code[cp+1]})
				cp = cp + 2
			end
		end
	end
	-- Refer to https://wiki.libsdl.org/SDL_Keycode for key names.
	emu:model({
		model_name = "fx-991CN CW",
		interface_image_path = "interface.png",
		rom_path = "rom.bin",
		hardware_id = 5,
		real_hardware = 1,
		csr_mask = 0x000F,
		pd_value = 0x00,
		rsd_interface = {0, 0, 284, 562, 0, 0},
		rsd_pixel = { 46, 100,  1,  1,  46, 100},
		rsd_s     = { 60, 565,  7,  7,  60, 90},
		rsd_math  = { 70, 565, 13,  7,  70, 90},
		rsd_d     = {86, 565,  7,  7, 86, 90},
		rsd_r     = {95, 565,  7,  7, 95, 90},
		rsd_g     = {103, 565,  7,  7, 103, 90},
		rsd_fix   = {112, 565, 14,  7, 112, 90},
		rsd_sci   = {127, 565, 12,  7, 127, 90},
		rsd_e     = {142, 565,  6,  7, 142, 90},
		rsd_cmplx = {151, 565,  4,  7, 151, 90},
		rsd_angle = {157, 565,  7,  7, 157, 90},
		rsd_wdown = {166, 565, 6,  7, 166, 90},
		rsd_verify = {175, 565, 7, 7, 175, 90},
		rsd_left  = {185, 565,  6,  7, 185, 90},
		rsd_down  = {193, 565,  6,  7, 193, 90},
		rsd_up    = {200, 565,  6,  7, 200, 90},
		rsd_right = {208, 565,  6,  7, 208, 90},
		rsd_pause = {218, 565, 8,  7, 218, 90},
		rsd_sun   = {228, 565,  8,  7, 228, 90},
		ink_colour = {30, 52, 90},
		button_map = buttons
	})
	generate( 30, 392, 32, 32, 5, 4, 48, 41, {
		0x02, 'Keypad 7', 0x12, 'Keypad 8', 0x22, 'Keypad 9', 0x32, 'Backspace', 0x42, 'Space',
		0x01, 'Keypad 4', 0x11, 'Keypad 5', 0x21, 'Keypad 6', 0x31, 'Keypad *' , 0x41, 'Keypad /',
		0x00, 'Keypad 1', 0x10, 'Keypad 2', 0x20, 'Keypad 3', 0x30, 'Keypad +', 0x40, 'Keypad -',
		0x64, 'Keypad 0', 0x63, 'Keypad .', 0x62, '/', 0x61, 'Right Shift' , 0x60, 'Return',
	})
	generate( 32, 322, 25, 25, 6, 2, 39, 34, {
		0x04, 'A', 0x14, 'S', 0x24, 'D', 0x34, 'J', 0x44, 'K', 0x54, 'L',
		0x03, 'Z', 0x13, 'X', 0x23, 'C', 0x33, 'B', 0x43, 'N', 0x53, 'M',
	})
	generate( 32, 245, 25, 25, 6, 1, 39, 0, {
		0x06, 'Left Shift', 0x16, 'Escape', 0x26, 'Left', 0x36, '\\', 0x46, 'Right', 0x56, 'PageDown',
	})
	generate( 32, 286, 25, 25, 3, 1,  40,  0, {0x05, 'Q', 0x15, 'W', 0x25, 'E',})
	generate(188, 286, 25, 25, 2, 1,  40,  0, {0x45, 'O', 0x55, 'P',})
	generate( 150, 280, 24, 24, 1, 1,  0,  0, {0x35, 'Down',})
	generate(71, 209, 25, 25, 3, 1,  78,  0, {0x17, 'Home', 0x37, 'Up', 0x57, 'PageUp',})
	generate(34, 208, 22, 22, 1, 1, 0, 0, {0xFF, 'F1'})
end
