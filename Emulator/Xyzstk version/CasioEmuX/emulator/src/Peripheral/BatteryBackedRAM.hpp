#pragma once
#include "../Config.hpp"

#include "Peripheral.hpp"
#include "../Chipset/MMURegion.hpp"

namespace casioemu
{
	class BatteryBackedRAM : public Peripheral
	{
		MMURegion region, region_2;

		size_t ram_size;
		bool ram_file_requested;

	public:
		using Peripheral::Peripheral;
		uint8_t *ram_buffer;
		void Initialise();
		void Uninitialise();
		void SaveRAMImage();
		void LoadRAMImage();
	};
}

