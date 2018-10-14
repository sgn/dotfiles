import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Util.EZConfig

-- launch XMonad with a status bar and overridden configuration
main = xmonad =<< statusBar my_bar my_PP my_toggle_struts_key my_config

my_bar = "xmobar -x 0"

my_PP = xmobarPP
  { ppSep  = " | "
  , ppTitle = xmobarColor "green" "" . shorten 140
  }

my_toggle_struts_key XConfig { XMonad.modMask = modMask } = (modMask, xK_b)

my_config = def
  { modMask            = my_mod_mask
  , terminal           = my_terminal
  , startupHook        = ewmhDesktopsStartup
  , layoutHook         = my_layout_hook
  , handleEventHook    = ewmhDesktopsEventHook
  , logHook            = ewmhDesktopsLogHook
  , manageHook         = my_manage_hook
  , borderWidth        = 2
  , normalBorderColor  = "gray20"
  , focusedBorderColor = "#646464"
  } `additionalKeys`
  [ ((my_mod_mask .|. shiftMask, xK_p),
     spawn("dmenu_run >/dev/null 2>&1"))
  , ((my_mod_mask              , xK_p),
     spawn("j4-dmenu-desktop --no-generic --term=" ++ my_terminal ++" >/dev/null 2>&1"))
  , ((my_mod_mask              , xK_f),
     spawn("firefox -P default"))
  , ((my_mod_mask .|. shiftMask, xK_f),
     spawn("firefox -P script --no-remote"))
  , ((my_mod_mask .|. shiftMask, xK_l),
     spawn("xautolock -locknow"))]
  -- layouts
my_layout_hook = smartBorders $ Full ||| tall ||| wide
  where
    tall    = Tall nmaster delta ratio
    wide    = renamed [ Replace "Wide" ] $ Mirror tall
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100

my_manage_hook = composeAll
  [ className =? "Xmessage" --> doFloat ]

my_mod_mask = mod4Mask
my_terminal = "urxvt"
my_browser = "firefox"
