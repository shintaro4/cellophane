//
//  KC.mm
//

#include "KC.h"


namespace cellophane {


//--------------------------------------------------------------
// color constants
//--------------------------------------------------------------
//  {0xF2EFDF,0xF3EAC9, 0xF7E8C8, 0xF9EEDE}
const int KC::kBackgroundColor = 0xF2EFDF;

const int KC::kPaletteList[kPaletteListSize][KT::kTotalTrackSize] = {
  {0x191B31, 0x135F70, 0x507374, 0x6C0D20},
  {0x020202, 0x0E5757, 0x414B7F, 0x4C0A18},
  {0x0D0C05, 0x3E020A, 0x16185A, 0x1F5B5B},

  {0x012411, 0x4D0C3F, 0x20806A, 0x064b6E},
  {0x0D0B1A, 0x56055F, 0x2F8599, 0x284710},
  {0x0D0C05, 0x1C0046, 0x173462, 0x063F24},

  {0x475C1D, 0x661F18, 0x66510D, 0x064448},
  {0x020202, 0x550005, 0x7E6F40, 0x144E44},
  {0x060610, 0x1F4B32, 0x7F7954, 0x5E2010},
  {0x05060D, 0x38490F, 0x613812, 0x3C001B},

  {0x241301, 0x02424D, 0x806A20, 0x4A6E03},
  {0x05060D, 0x266157, 0x2F1C0B, 0x4A6134},
  {0x0A091F, 0x250016, 0x4A5115, 0x08273C},
};

const int KC::KPaletteMap[kPaletteSize] = {
  10, 7, 0
};

  
}  // namespace cellophane
