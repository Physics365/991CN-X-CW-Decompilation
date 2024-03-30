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
		model_name = "fx-991CW",
		interface_image_path = "interface.png",
		rom_path = "rom.bin",
		hardware_id = 5,
		real_hardware = 0,
		csr_mask = 0x000F,
		pd_value = 0x00,
		rsd_interface = {0, 0, 284, 562, 0, 0},
		rsd_pixel = { 46, 96,  1,  1,  46, 96},
		rsd_s     = { 60, 565,  7,  7,  60, 86},
		rsd_math  = { 70, 565, 13,  7,  70, 86},
		rsd_d     = {86, 565,  7,  7, 86, 86},
		rsd_r     = {95, 565,  7,  7, 95, 86},
		rsd_g     = {103, 565,  7,  7, 103, 86},
		rsd_fix   = {112, 565, 14,  7, 112, 86},
		rsd_sci   = {127, 565, 12,  7, 127, 86},
		rsd_e     = {142, 565,  6,  7, 142, 86},
		rsd_cmplx = {151, 565,  4,  7, 151, 86},
		rsd_angle = {157, 565,  7,  7, 157, 86},
		rsd_wdown = {166, 565, 6,  7, 166, 86},
		rsd_verify = {175, 565, 7, 7, 175, 86},
		rsd_left  = {185, 565,  6,  7, 185, 86},
		rsd_down  = {193, 565,  6,  7, 193, 86},
		rsd_up    = {200, 565,  6,  7, 200, 86},
		rsd_right = {208, 565,  6,  7, 208, 86},
		rsd_pause = {218, 565, 8,  7, 218, 86},
		rsd_sun   = {228, 565,  8,  7, 228, 86},
		ink_colour = {30, 52, 90},
		button_map = buttons
	})
	generate( 30, 384, 32, 32, 5, 4, 48, 40, {
		0x02, '7', 0x12, '8', 0x22, '9', 0x32, 'Backspace', 0x42, 'Space',
		0x01, '4', 0x11, '5', 0x21, '6', 0x31, '' , 0x41, '/',
		0x00, '1', 0x10, '2', 0x20, '3', 0x30, '=', 0x40, '-',
		0x64, '0', 0x63, '.', 0x62, 'E', 0x61, '' , 0x60, 'Return',
	})
	generate( 32, 316, 25, 25, 6, 2, 39, 34, {
		0x04, '', 0x14, '', 0x24, '', 0x34, '', 0x44, '', 0x54, '',
		0x03, '', 0x13, '', 0x23, '', 0x33, '', 0x43, '', 0x53, '',
	})
	generate( 32, 240, 25, 25, 6, 1, 39, 0, {
		0x06, '', 0x16, '', 0x26, '', 0x36, '', 0x46, '', 0x56, '',
	})
	generate( 32, 280, 25, 25, 3, 1,  40,  0, {0x05, 'F5', 0x15, 'F6', 0x25, '',})
	generate(188, 280, 25, 25, 2, 1,  40,  0, {0x45, 'F7', 0x55, 'F8',})
	generate( 150, 275, 24, 24, 1, 1,  0,  0, {0x35, 'F1',})
	generate(71, 205, 25, 25, 3, 1,  78,  0, {0x17, 'F3', 0x37, 'F4', 0x57, '',})
	generate(34, 204, 22, 22, 1, 1, 0, 0, {0xFF, 'Left'})
end
