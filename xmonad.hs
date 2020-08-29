{-# LANGUAGE QuasiQuotes, OverloadedStrings #-}

import qualified Data.Map as M
import qualified Data.Text.IO
import Data.Monoid

import System.Exit
import System.Process


import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Gaps
import XMonad.Layout.OneBig
import XMonad.Layout.Reflect
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Layout.ThreeColumns
import qualified XMonad.StackSet as W
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

import NeatInterpolation (text)
--import qualified Xmobar as Xmb
main :: IO ()
main = do
  --  p <- spawnPipe "./.config/polybar/launch.sh"
  --  spawnPipe "mkdir -p $HOME/.config/xmobar && touch $HOME/.config/xmobar/xmobarrc &"
--  writeFile "$HOME/.config/xmobar/xmobarrc" $ show xmobarConfig
 
  xmprop <- spawnPipe "xmobar $HOME/.config/xmobar/xmobar.hs"
  xmonad $ docks $ defaults xmprop

defaults xmprop =
  def
    { -- simple stuff
      terminal = myTerminal,
      focusFollowsMouse = myFocusFollowsMouse,
      clickJustFocuses = myClickJustFocuses,
      borderWidth = myBorderWidth,
      modMask = myModMask,
      workspaces = myWorkspaces,
      normalBorderColor = myNormalBorderColor,
      focusedBorderColor = myFocusedBorderColor,
      -- key bindings
      keys = myKeys,
      mouseBindings = myMouseBindings,
      -- hooks, layouts
      layoutHook = myLayout,
      manageHook = myManageHook,
      handleEventHook = myEventHook,
      logHook = myLogHook xmprop,
      startupHook = myStartupHook
    }


data Symbols = Symbols { upload   :: String
                       , download :: String
                       , cpu      :: String
                       , ram      :: String
                       , disk     :: String
                       , files    :: String
                       , clock    :: String
                       , calendar :: String
                       , speaker  :: String
                       }

smb = Symbols { upload   = "\\uf093"
              , download = "\\uf019"
              , cpu      = "\\uf85a"
              , ram      = "\\uf2db"
              , disk     = "\\uf01c"
              , files    = "\\uf413"
              , clock    = "\\uf017"
              , calendar = "\\uf5ec"
              , speaker  = "\\uf485"
              }


myTerminal = "kitty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth :: Dimension
myBorderWidth = 1

myModMask = mod4Mask

-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces = ["1 - main", "2 - code", "3 - Audio", "4", "5", "6", "7", "8", "9"]

-- Border colors for unfocused and focused windows, respectively.
myNormalBorderColor = "#005500"

myFocusedBorderColor = "#00ff00"

------------------------------------------------------------------------

-- Key bindings. Add, modify or remove key bindings here.
--
myKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- launch a terminal
    [ ((modm, xK_Return), spawn $ XMonad.terminal conf),
      -- launch dmenu
      ((modm, xK_space), spawn "/home/skalnark/.config/polybar/scripts/menu"),
      ((controlMask .|. mod1Mask, xK_Delete), spawn "/home/skalnark/.config/polybar/scripts/sysmenu"),
      -- launch gmrun
      ((modm .|. shiftMask, xK_p), spawn "gmrun"),
      -- close focused window
      ((modm .|. shiftMask, xK_k), kill),
      -- Rotate through the available layout algorithms
      ((modm .|. shiftMask, xK_space), sendMessage NextLayout),
      --  Reset the layouts on the current workspace to default
      -- , ((modm .|. controlMask, xK_space ), setLayout $ XMonad.layoutHook conf)

      -- Resize viewed windows to the correct size
      ((modm, xK_n), refresh),
      -- Move focus to the next window
      ((modm, xK_Down), windows W.focusDown),
      -- Move focus to the previous window
      ((modm, xK_Up), windows W.focusUp),
      -- Move focus to the master window
      ((modm, xK_m), windows W.focusMaster),
      -- Swap the focused window and the master window
      ((modm .|. shiftMask, xK_m), windows W.swapMaster),
      -- Swap the focused window with the next window
      ((modm .|. shiftMask, xK_Right), windows W.swapDown),
      -- Swap the focused window with the previous window
      ((modm .|. shiftMask, xK_Left), windows W.swapUp),
      -- Shrink the master area
      ((modm .|. shiftMask, xK_Down), sendMessage Shrink),
      -- Expand the master area
      ((modm .|. shiftMask, xK_Up), sendMessage Expand),
      -- Push window back into tiling
      ((modm, xK_t), withFocused $ windows . W.sink),
      -- Increment the number of windows in the master area
      ((modm, xK_comma), sendMessage (IncMasterN 1)),
      -- Deincrement the number of windows in the master area
      ((modm, xK_period), sendMessage (IncMasterN (-1))),
      -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

      -- Restart xmonad
      ((modm, xK_q), spawn "killall xmobar && killall polybar && xmonad --recompile; xmonad --restart"),
      -- Run xmessage with a summary of the default keybindings (useful for beginners)
      ((modm .|. shiftMask, xK_slash), spawn ("echo \"" ++ help ++ "\" | xmessage -file -")),
      ((0, xK_Print), spawn "scrot $HOME/'Pictures/Screenshots/%Y-%m-%d_%H%M%S-$wx$h_scrot.png'"),
      ((controlMask, xK_Print), spawn "sleep 0.2 ; scrot -s $HOME/'Pictures/Screenshots/%Y-%m-%d_%H%M%S-$wx$h_scrot.png'")
    ]
      ++
      --
      -- mod-[1..9], Switch to workspace N
      -- mod-shift-[1..9], Move client to workspace N
      --
      [ ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9],
          (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
      ]
      ++
      --
      -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
      -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
      --
      [ ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0 ..],
          (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
      ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings :: XConfig l -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings (XConfig {XMonad.modMask = modm}) =
  M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ( (modm, button1),
        ( \w ->
            focus w >> mouseMoveWindow w
              >> windows W.shiftMaster
        )
      ),
      -- mod-button2, Raise the window to the top of the stack
      ((modm, button2), (\w -> focus w >> windows W.shiftMaster)),
      -- mod-button3, Set the window to floating mode and resize by dragging
      ( (modm, button3),
        ( \w ->
            focus w >> mouseResizeWindow w
              >> windows W.shiftMaster
        )
      )
      -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- Now this type signature is too big and it increases as far as you
-- add new options
myLayout =
  avoidStruts
    ( spacingRaw False screenBorder True windowBorder True $
        tiled ||| Full ||| bsp ||| threeCol ||| threeColMid ||| oneBig
    )
  where
    --configs
    nmaster = 1
    ratio = 1 / 2
    delta = 3 / 100
    screenBorder = Border 0 1 1 1
    windowBorder = Border 0 1 1 1

    --layouts
    tiled = renamed [Replace "Tall"] $ reflectHoriz $ Tall nmaster delta ratio

    bsp = reflectHoriz $ emptyBSP

    threeCol = ThreeCol nmaster delta (1 / 2)

    threeColMid = renamed [Replace "ThreeCol Mid"] $ ThreeColMid nmaster delta ratio

    oneBig = OneBig (3 / 4) (3 / 4)

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
myLogHook xmprop = dynamicLogWithPP $ xmobarPP {ppOutput = hPutStrLn xmprop}
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
  spawnOnce "xcompmgr -n&"
  spawnOnce "xrdb $HOME/.Xresources &"
  spawnOnce "xsetroot -cursor_name left_ptr &"
  spawnOnce "xbindkeys --poll-rc &"
  spawnOnce "wmname LG3D &"
  spawnOnce "feh --bg-fill $HOME/Pictures/Wallpapers/wallpaper.jpg &"

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["read the code fucker"]


{-


xmobarConfig = 
  Xmb.Config
    { Xmb.font = "xft:Iosevka Nerd Font:size=10:bold:antialias=true",
      Xmb.additionalFonts = [],
      Xmb.borderColor = "#000000",
      Xmb.border = Xmb.TopB,
      Xmb.bgColor = "#004400",
      Xmb.fgColor = "#00f7ff",
      Xmb.alpha = 160,
      Xmb.position = Xmb.Top,
      Xmb.textOffset = -1,
      Xmb.iconOffset = -1,
      Xmb.lowerOnStart = True,
      Xmb.pickBroadest = False,
      Xmb.persistent = False,
      Xmb.hideOnStart = False,
      Xmb.iconRoot = ".",
      Xmb.allDesktops = True,
      Xmb.overrideRedirect = True,
      Xmb.sepChar = "%",
      Xmb.alignSep = "}{",
      Xmb.template =
        "%cpu% | %memory% * %swap% | %eth0% - %eth1% }\
        \ %hw% { <fc=#ee9a00>%date%</fc>| %EGPH% | %uname%",
      Xmb.commands =         
        [ Xmb.Run Xmb.StdinReader
       --, Xmb.Run Xmb.Com "/bin/bash" ["-c", "$HOME/.config/xmobar/scripts/spotify"] "spotify" 100

        --, Xmb.Run Xmb.Com "/bin/bash" ["-c", "$HOME/.config/xmobar/scripts/docker"] "docker" 100

        -- network activity monitor (dynamic interface resolution)
        , Xmb.Run Xmb.DynNetwork     [ "--template" , (smb.upload ++ "  <tx>kB/s   " ++ smb.download ++ "  <rx>kB/s")
                             , "--Low"      , "10000"       -- units: B/s
                             , "--High"     , "50000"       -- units: B/s
                             , "--low"      , "#00ddff"
                             , "--normal"   , "#00ddff"
                             , "--high"     , "#00ff00"
                             ] 10

        -- cpu activity monitor
        , Xmb.Run Xmb.MultiCpu       [ "--template" , (smb.cpu ++ " : <total2>%")
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#ffffff"
                             , "--normal"   , "#ff8888"
                             , "--high"     , "#ff3333"
                             ] 10

        -- cpu core temperature monitor
        , Xmb.Run Xmb.CoreTemp       [ "--template" , "<core2>°C"
                             , "--Low"      , "70"        -- units: °C
                             , "--High"     , "80"        -- units: °C
                             , "--low"      , "yellow"
                             , "--normal"   , "orange"
                             , "--high"     , "red"
                             ] 50
                          
        -- memory usage monitor
        , Xmb.Run Xmb.Memory         [ "--template" , (smb.ram ++ " : <usedratio>%")
                             , "--Low"      , "10"        -- units: %
                             , "--High"     , "60"        -- units: %
                             , "--low"      , "green"
                             , "--normal"   , "yellow"
                             , "--high"     , "red"
                             ] 10

        -- battery monitor
        , Xmb.Run Xmb.Battery        [ "--template" , "Batt: <acstatus>"
                             , "--Low"      , "10"        -- units: %
                             , "--High"     , "80"        -- units: %
                             , "--low"      , "red"
                             , "--normal"   , "orange"
                             , "--high"     , "green"

                             , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"	, "<left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O"	, "<fc=#dAA520>Charging</fc>"
                                       -- charged status
                                       , "-i"	, "<fc=#006000>Charged</fc>"
                             ] 50

        -- time and date indicator 
        --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
        , Xmb.Run Xmb.Date           ("<fc=#00f7ff>" ++ smb.clock ++ "  %T - %a  " ++smb.calendar ++"  %F</fc>") "date" 10

        -- keyboard layout indicator
        , Xmb.Run Xmb.Kbd            [ ("us(dvorak)" , "<fc=#00008B>DV</fc>")
                             , ("us"         , "<fc=#8B0000>US</fc>")
                             ]
        -- Disk Usage
	      , Xmb.Run Xmb.DiskU          [ ("/", (smb.disk ++ " : <usedp>%")),  ("/home", ("  "++smb.files++" : <usedp>%"))]               
                             [ "-L", "20" -- low
                             , "-H", "70" -- high
                             , "-m", "1"
                             , "-p", "3" -- have no idea
                             , "--normal", "#ffffff"
                             , "--high", "#ff4444"
                             , "--low", "#00ff34"] 20
       
       -- Volume
       , Xmb.Run Xmb.Volume "default" "Master" [ "--template", (smb.speaker ++ "  <volume>%")
                                       ] 10
        ]
    }
  -}

xmobarConfig = [text|
  Config
    { font = "xft:Iosevka Nerd Font:size=10:bold:antialias=true",
      additionalFonts = [],
      borderColor = "#000000",
      border = TopB,
      bgColor = "#004400",
      fgColor = "#00f7ff",
      alpha = 160,
      position = Top,
      textOffset = -1,
      iconOffset = -1,
      lowerOnStart = True,
      pickBroadest = False,
      persistent = False,
      hideOnStart = False,
      iconRoot = ".",
      allDesktops = True,
      overrideRedirect = True,
      sepChar = "%",
      alignSep = "}{",
      template =
        "%cpu% | %memory% * %swap% | %eth0% - %eth1% }\
        \ %hw% { <fc=#ee9a00>%date%</fc>| %EGPH% | %uname%",
      commands =         
        [ Run StdinReader
       --, Run Com "/bin/bash" ["-c", "$$HOME/.config/xmobar/scripts/spotify"] "spotify" 100

        --, Run Com "/bin/bash" ["-c", "$$HOME/.config/xmobar/scripts/docker"] "docker" 100

        -- network activity monitor (dynamic interface resolution)
        , Run DynNetwork     [ "--template" , (smb.upload ++ "  <tx>kB/s   " ++ smb.download ++ "  <rx>kB/s")
                             , "--Low"      , "10000"       -- units: B/s
                             , "--High"     , "50000"       -- units: B/s
                             , "--low"      , "#00ddff"
                             , "--normal"   , "#00ddff"
                             , "--high"     , "#00ff00"
                             ] 10

        -- cpu activity monitor
        , Run MultiCpu       [ "--template" , (smb.cpu ++ " : <total2>%")
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#ffffff"
                             , "--normal"   , "#ff8888"
                             , "--high"     , "#ff3333"
                             ] 10

        -- cpu core temperature monitor
        , Run CoreTemp       [ "--template" , "<core2>°C"
                             , "--Low"      , "70"        -- units: °C
                             , "--High"     , "80"        -- units: °C
                             , "--low"      , "yellow"
                             , "--normal"   , "orange"
                             , "--high"     , "red"
                             ] 50
                          
        -- memory usage monitor
        , Run Memory         [ "--template" , (smb.ram ++ " : <usedratio>%")
                             , "--Low"      , "10"        -- units: %
                             , "--High"     , "60"        -- units: %
                             , "--low"      , "green"
                             , "--normal"   , "yellow"
                             , "--high"     , "red"
                             ] 10

        -- battery monitor
        , Run Battery        [ "--template" , "Batt: <acstatus>"
                             , "--Low"      , "10"        -- units: %
                             , "--High"     , "80"        -- units: %
                             , "--low"      , "red"
                             , "--normal"   , "orange"
                             , "--high"     , "green"

                             , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"	, "<left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O"	, "<fc=#dAA520>Charging</fc>"
                                       -- charged status
                                       , "-i"	, "<fc=#006000>Charged</fc>"
                             ] 50

        -- time and date indicator 
        --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
        , Run Date           ("<fc=#00f7ff>" ++ smb.clock ++ "  %T - %a  " ++smb.calendar ++"  %F</fc>") "date" 10

        -- keyboard layout indicator
        , Run Kbd            [ ("us(dvorak)" , "<fc=#00008B>DV</fc>")
                             , ("us"         , "<fc=#8B0000>US</fc>")
                             ]
        -- Disk Usage
	      , Run DiskU          [ ("/", (smb.disk ++ " : <usedp>%")),  ("/home", ("  "++smb.files++" : <usedp>%"))]               
                             [ "-L", "20" -- low
                             , "-H", "70" -- high
                             , "-m", "1"
                             , "-p", "3" -- have no idea
                             , "--normal", "#ffffff"
                             , "--high", "#ff4444"
                             , "--low", "#00ff34"] 20
       
       -- Volume
       , Run Volume "default" "Master" [ "--template", (smb.speaker ++ "  <volume>%")
                                       ] 10
        ]
    }
|]
