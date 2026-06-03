#define HEX_COLOR(hex)                                                         \
  {.red = ((hex >> 24) & 0xff) * 257,                                          \
   .green = ((hex >> 16) & 0xff) * 257,                                        \
   .blue = ((hex >> 8) & 0xff) * 257,                                          \
   .alpha = (hex & 0xff) * 257}

static bool ipc              = false;
static bool hidden           = false;
static bool bottom           = false;
static bool hide_vacant      = true;
static uint32_t vertical_padding = 4;
static bool status_commands  = true;
static bool center_title     = true;
static bool custom_title     = true;
static bool active_color_title = false;
static uint32_t buffer_scale = 1;

/* font: Luxi Sans for the plan9port feel, Noto Sans as Cyrillic fallback.
 * The font-fallback patch splits on ','
 */
static char *fontstr = "Luxi Mono:style=Bold:size=11,Noto Sans:size=11";

static char *tags_names[] = {"B", "T", "A", "?", "F", "K", "7", "8", "9"};

static pixman_color_t active_fg_color =          HEX_COLOR(0xeeeeeeff); /* near-white text on dark */
static pixman_color_t active_bg_color =          HEX_COLOR(0x333333ff); /* dark grey active tag    */
static pixman_color_t occupied_fg_color =        HEX_COLOR(0x111111ff); /* black text              */
static pixman_color_t occupied_bg_color =        HEX_COLOR(0x999999ff); /* mid grey occupied       */
static pixman_color_t inactive_fg_color =        HEX_COLOR(0x222222ff); /* dark text               */
static pixman_color_t inactive_bg_color =        HEX_COLOR(0xbbbbbbff); /* light grey inactive     */
static pixman_color_t urgent_fg_color =          HEX_COLOR(0xeeeeeeff); /* light text on red       */
static pixman_color_t urgent_bg_color =          HEX_COLOR(0x884444ff); /* muted red               */
static pixman_color_t middle_bg_color =          HEX_COLOR(0xbbbbbbff); /* title area = inactive   */
static pixman_color_t middle_bg_color_selected = HEX_COLOR(0xbbbbbbff); /* same — flat surface     */
