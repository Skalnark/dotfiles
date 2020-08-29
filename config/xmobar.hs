--                        _                
--  __  ___ __ ___   ___ | |__   __ _ _ __ 
--  \ \/ / '_ ` _ \ / _ \| '_ \ / _` | '__|
--   >  <| | | | | | (_) | |_) | (_| | |   
--  /_/\_\_| |_| |_|\___/|_.__/ \__,_|_|   
--
--
Config { 

   -- appearance
     font        = "xft:Iosevka Nerd Font:size=10:bold:antialias=true"
   , bgColor     = "#333300"
   , fgColor     = "#00f7ff"
   , position    = Top
   , border      = BottomB
   , borderColor = "#000000"
   , alpha       = 190
   -- layout
   , sepChar =  "%"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment
   , template = "  %StdinReader%                                                                                          %date% }{%default:Master%    %multicpu% %coretemp%    %memory%         %dynnetwork%        %disku%      %docker%   <fc=#00ff00> %spotify%</fc>       "
--"%battery% | %multicpu% | %coretemp% | %memory% | %dynnetwork% }{ %RJTT% | %date% || %kbd% "

   , lowerOnStart =     True    -- send to bottom of window stack on start
   , hideOnStart =      False   -- start with window unmapped (hidden)
   , allDesktops =      True    -- show on all desktops
   , overrideRedirect = True    -- set the Override Redirect flag (Xlib)
   , pickBroadest =     False   -- choose widest display (multi-monitor)
   , persistent =       True    -- enable/disable hiding (True = disabled)
   , commands = 

        
        [ Run StdinReader
	, Run Com "/bin/bash" ["-c", "$HOME/.config/xmobar/scripts/spotify"] "spotify" 100

        , Run Com "/bin/bash" ["-c", "$HOME/.config/xmobar/scripts/docker"] "docker" 100

        -- network activity monitor (dynamic interface resolution)
        , Run DynNetwork     [ "--template" , "  <tx>kB/s     <rx>kB/s"
                             , "--Low"      , "10000"       -- units: B/s
                             , "--High"     , "50000"       -- units: B/s
                             , "--low"      , "#00ddff"
                             , "--normal"   , "#00ddff"
                             , "--high"     , "#00ff00"
                             ] 10

        -- cpu activity monitor
        , Run MultiCpu       [ "--template" , " : <total2>%"
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
        , Run Memory         [ "--template" ," : <usedratio>%"
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
        , Run Date           "<fc=#00f7ff>  %T - %a    %F</fc>" "date" 10

        -- keyboard layout indicator
        , Run Kbd            [ ("us(dvorak)" , "<fc=#00008B>DV</fc>")
                             , ("us"         , "<fc=#8B0000>US</fc>")
                             ]
        -- Disk Usage
	, Run DiskU          [ ("/", " : <usedp>%"),  ("/home", "   : <usedp>%")]               
                             [ "-L", "20" -- low
                             , "-H", "70" -- high
                             , "-m", "1"
                             , "-p", "3" -- have no idea
                             , "--normal", "#ffffff"
                             , "--high", "#ff4444"
                             , "--low", "#00ff34"] 20
       
       -- Volume
       , Run Volume "default" "Master" [ "--template", "  <volume>%"
                                       ] 10
        ]
   }
