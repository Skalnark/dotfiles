--export :: Config -> IO ()
--export = writeFile ".xmobarrc".show

Config { 

   -- appearance
     font        = "xft:Iosevka Nerd Font:size=10:bold:antialias=true"
   , additionalFonts  = ["xft:Iosevka Nerd Font:size=12:bold:antialias=true"]
   , bgColor     = "#000000"
   , fgColor     = "#ffffff"
   , position    = Top
   , border      = BottomB
   , borderColor = "#ffffff"
   , alpha       =  128
   -- layout
   , sepChar =  "%"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment
   , template = " <fc=#ffffff>%StdinReader%</fc>         <fc=#ffffff>%locks%</fc>                                                                            %date% }{%default:Master%    %multicpu% %coretemp%    %memory%         %dynnetwork%        %disku%   <fn=1> </fn> %docker%   <fc=#009900> %spotify%</fc>   <fn=1> </fn>   "
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
        , Run DynNetwork     [ "--template" , "<fn=1> </fn><tx>kB/s   <fn=1> </fn><rx>kB/s"
                             , "--Low"      , "10000"       -- units: B/s
                             , "--High"     , "50000"       -- units: B/s
                             , "--low"      , "#ffffff"
                             , "--normal"   , "#ffffff"
                             , "--high"     , "#ffffff"
                             ] 10

        -- cpu activity monitor
        , Run MultiCpu       [ "--template" , "<fn=1> </fn><total>%"
                             , "--Low"      , "50"         -- units: %
                             , "--High"     , "85"         -- units: %
                             , "--low"      , "#ffffff"
                             , "--normal"   , "#ffffff"
                             , "--high"     , "#ffffff"
                             ] 10

        -- cpu core temperature monitor
        , Run CoreTemp       [ "--template" , "<core2>°C"
                             , "--Low"      , "70"        -- units: °C
                             , "--High"     , "80"        -- units: °C
                             , "--low"      , "#ffffff"
                             , "--normal"   , "#ffffff"
                             , "--high"     , "#ff0000"
                             ] 10
                          
        -- memory usage monitor
        , Run Memory         [ "--template" ,"<fn=1> </fn><usedratio>%"
                             , "--Low"      , "10"        -- units: %
                             , "--High"     , "70"        -- units: %
                             , "--low"      , "#ffffff"
                             , "--normal"   , "#ffffff"
                             , "--high"     , "#ff0000"
                             ] 10

        -- battery monitor
        , Run Battery        [ "--template" , "Batt: <acstatus>"
                             , "--Low"      , "10"        -- units: %
                             , "--High"     , "80"        -- units: %
                             , "--low"      , "#ffffff"
                             , "--normal"   , "#ffffff"
                             , "--high"     , "#ff0000"

                             , "--" -- battery specific options
                                       -- discharging status
                                       , "-o"	, "<left>% (<timeleft>)"
                                       -- AC "on" status
                                       , "-O"	, "<fc=#ffffff>Charging</fc>"
                                       -- charged status
                                       , "-i"	, "<fc=#ffffff>Charged</fc>"
                             ] 50

        -- time and date indicator 
        --   (%F = y-m-d date, %a = day of week, %T = h:m:s time)
        , Run Date           "<fn=1> </fn> <fc=#ffffff>%T - %a</fc>  <fn=1> </fn> <fc=#ffffff>%F</fc>" "date" 10

        -- keyboard layout indicator
        , Run Kbd            [ ("us(dvorak)" , "<fc=#ffffff>DV</fc>")
                             , ("us"         , "<fc=#ffffff>US</fc>")
                             ]
        -- Disk Usage
	, Run DiskU          [ ("/", "<fn=1> </fn> <usedp>%"),  ("/home", "  <fn=1></fn> <usedp>%")]               
                             [ "-L", "20" -- low
                             , "-H", "70" -- high
                             , "-m", "1"
                             , "-p", "3" -- have no idea
                             , "--normal", "#ffffff"
                             , "--high", "#ff0000"
                             , "--low", "#ffffff"] 20
       
       -- Volume
       , Run Volume "default" "Master" [ "--template", "<fn=1> </fn> <volume>%"
                                       ] 10
       , Run Locks
       ]
   }
