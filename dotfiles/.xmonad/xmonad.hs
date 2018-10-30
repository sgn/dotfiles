import XMonad
import qualified XMonad.StackSet as W
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad
import XMonad.Util.WorkspaceCompare
import Graphics.X11.ExtraTypes.XF86
import Text.Printf

-- launch XMonad with a status bar and overridden configuration
main = xmonad =<< statusBar myBar myPp myToggleStrutsKey myConfig

myBar = "xmobar -x 0"

myPp = xmobarPP
  { ppSep  = " | "
  , ppTitle = xmobarColor "green" "" . shorten 140
  , ppUrgent = xmobarColor "purple" "" . wrap "{" "}"
  }

myToggleStrutsKey XConfig { XMonad.modMask = modMask } = (modMask, xK_v)

myConfig = withUrgencyHook NoUrgencyHook $ def
  { modMask            = myModMask
  , terminal           = myTerminal
  , startupHook        = ewmhDesktopsStartup
  , layoutHook         = myLayoutHook
  , handleEventHook    = ewmhDesktopsEventHook
  , logHook            = myLogHook
  , manageHook         = myManageHook
  , borderWidth        = 2
  , normalBorderColor  = "gray20"
  , focusedBorderColor = "purple"
  } `additionalKeys`
  [ ((myModMask .|. shiftMask, xK_p),
     spawn("j4-dmenu-desktop --no-generic --term=" ++ myTerminal ++" >/dev/null 2>&1"))
  , ((myModMask,               xK_s),
     scratchpadSpawnActionTerminal "urxvt")
  , ((myModMask .|. shiftMask, xK_s),
     spawn "emacsclient -nc -a ''")
  , ((myModMask,               xK_u),
     focusUrgent)
  , ((myModMask,               xK_c),
     spawn "urxvtc -name weechat -e weechat-curses")
  , ((myModMask              , xK_o),
     if True -- will be change to condition to check number of windows soon
     then windows W.focusDown
     else spawn "xdotool key --clearmodifiers Hyper_L+o")
  , ((myModMask .|. shiftMask, xK_o),
     if True
     then windows W.focusUp
     else spawn "xdotool key --clearmodifiers Hyper_L+Shift+o")
  -- , ((myModMask              , xK_h),
     -- spawn("xdotool key --clearmodifiers Hyper_L+h"))
  , ((myModMask,               xK_j     ),
     spawn "xdotool key --clearmodifiers Hyper_L+j")
     -- windows W.focusDown) -- %! Move focus to the next window
  , ((myModMask,               xK_k     ),
     spawn "xdotool key --clearmodifiers Hyper_L+k")
     -- windows W.focusUp  ) -- %! Move focus to the previous window
  , ((myModMask .|. shiftMask, xK_j     ),
     spawn "xdotool key --clearmodifiers Hyper_L+Shift+j")
     -- windows W.swapDown  ) -- %! Swap the focused window with the next window
  , ((myModMask .|. shiftMask, xK_k     ),
     spawn "xdotool key --clearmodifiers Hyper_L+Shift+k")
     -- windows W.swapUp    ) -- %! Swap the focused window with the previous window

    -- resizing the master/slave ratio
  , ((myModMask,               xK_h     ),
     if True
     then sendMessage Shrink -- %! Shrink the master area
     else spawn "xdotool key --clearmodifiers Hyper_L+h")
  , ((myModMask,               xK_l ),
     if True
     then sendMessage Expand -- %! Expand the master area
     else spawn "xdotool key --clearmofifiers Hyper_L+l")
  ]
  where
    notSP = (return $ ("NSP" /=) . W.tag) :: X (WindowSpace -> Bool)

  -- layouts
myLayoutHook = smartBorders $ tall ||| Full ||| wide
  where
    tall    = Tall nmaster delta ratio
    wide    = renamed [ Replace "Wide" ] $ Mirror tall
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100
-- myLayoutHook = smartBorders $ multiCol [1] 1 0.03 (-0.5)

myManageHook = myFloatHook
               <+> fullscreenManageHook
               <+> myScratchpadManageHook

myFloatHook = composeAll
  [ className =? "Xmessage" --> doFloat,
    (className =? "Firefox" <&&> (resource =? "Dialog" <||> resource=? "Browser")) --> doFloat,
    className =? "weechat"  --> doShift "9"
  ]


myScratchpadManageHook = scratchpadManageHook (W.RationalRect l t w h)
  where
    h = 0.2
    w = 1
    t = 0
    l = 0

myLogHook = ewmhDesktopsLogHook

myModMask = mod4Mask
myTerminal = "urxvtc"
