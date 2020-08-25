import XMonad
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Reflect
import XMonad.Layout.ThreeColumns
import XMonad.Layout.OneBig
import XMonad.Layout.Renamed

import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myTerminal      = "kitty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth :: Dimension
myBorderWidth   = 1

myModMask       = mod4Mask

-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1 - main","2 - code","3 - Audio", "4", "5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor  = "#000000"
myFocusedBorderColor = "#00ff00"
------------------------------------------------------------------------
myXmobar :: String
myXmobar = "xmobar -d -b" 

------------------------------------------------------------------------

-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_space     ), spawn "/home/skalnark/.config/polybar/scripts/menu")

    , ((controlMask .|. mod1Mask, xK_Delete), spawn "/home/skalnark/.config/polybar/scripts/sysmenu")

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- close focused window
    , ((modm .|. shiftMask, xK_k     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm .|. shiftMask, xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    -- , ((modm .|. controlMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Down     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_Up       ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m        ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm .|. shiftMask, xK_m        ), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_Right     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_Left     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm .|. shiftMask, xK_Down     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm .|. shiftMask, xK_Up     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "killall xmobar && killall polybar && xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))
    , ((0                 , xK_Print), spawn "scrot $HOME/'Pictures/Screenshots/%Y-%m-%d_%H%M%S-$wx$h_scrot.png'")
    , ((controlMask       , xK_Print), spawn "sleep 0.2 ; scrot -s $HOME/'Pictures/Screenshots/%Y-%m-%d_%H%M%S-$wx$h_scrot.png'")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings :: XConfig l -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- Now this type signature is too big and it increases as far as you
-- add new options
myLayout = avoidStruts (
           spacingRaw False screenBorder True windowBorder True
         $ tiled ||| Full ||| bsp ||| threeCol ||| threeColMid ||| oneBig)
  where
     --configs 
     nmaster      = 1
     ratio        = 1/2
     delta        = 3/100
     screenBorder = Border 0 1 1 1
     windowBorder = Border 0 1 1 1

     --layouts
     tiled          = renamed [Replace "Tall"] $ reflectHoriz $ Tall nmaster delta ratio

     bsp            = reflectHoriz $ emptyBSP

     threeCol       = ThreeCol nmaster delta (1/2)
     
     threeColMid    = renamed [Replace "ThreeCol Mid"] $ ThreeColMid nmaster delta ratio

     oneBig         = OneBig (3/4) (3/4)

     

------------------------------------------------------------------------
-- Window rules:

myManageHook :: ManageHook
myManageHook = manageDocks <+> composeAll []
   -- [ className =? "xterm"        --> doFullFloat ]

------------------------------------------------------------------------
-- Event handling
myEventHook :: Event -> X All
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- this import is shadowed and declare it gives you an error
-- so let this commented
--myLogHook :: GHC.IO.Handle.Types.Handle -> X () 
myLogHook h = dynamicLogWithPP $ xmobarPP { ppOutput = hPutStrLn h }

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "setxkbmap -model abnt2 -layout br &"
    spawnOnce "xcompmgr -n &"
    spawnOnce "xrdb $HOME/.Xresources &"
    spawnOnce "xsetroot -cursor_name left_ptr &"
    spawnOnce "xbindkeys --poll-rc &"
    spawnOnce "wmname LG3D &"
    spawnOnce "feh --bg-fill $HOME/Pictures/Wallpapers/wallpaper.jpg &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
    p <- spawnPipe "./.config/polybar/launch.sh"
    h <- spawnPipe myXmobar
    xmonad $ docks $ defaults h
    --xmonad defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults h = def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook h,
        startupHook        = myStartupHook
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines [ "read the code fucker" ]
