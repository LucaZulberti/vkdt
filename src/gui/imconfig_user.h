#pragma once

//---- Don't define obsolete functions/enums/behaviors. Consider enabling from time to time after updating to clean your code of obsolete function/names.
#define IMGUI_DISABLE_OBSOLETE_FUNCTIONS
#define IMGUI_DISABLE_OBSOLETE_KEYIO                      // 1.87: disable legacy io.KeyMap[]+io.KeysDown[] in favor io.AddKeyEvent(). This will be folded into IMGUI_DISABLE_OBSOLETE_FUNCTIONS in a few versions.

//---- Use 32-bit for ImWchar (default is 16-bit) to support unicode planes 1-16. (e.g. point beyond 0xFFFF like emoticons, dingbats, symbols, shapes, ancient languages, etc...)
#define IMGUI_USE_WCHAR32

#if VKDT_USE_FREETYPE == 1
#define IMGUI_ENABLE_FREETYPE
#endif
