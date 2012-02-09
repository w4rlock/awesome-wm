myawesomemenu = {
   { "manual"      , env.terminal .. " -e man awesome" }                           , 
   { "edit theme"  , editor_cmd .. " " .. dir .. "/themes/default/theme.lua" } , 
   { "edit config" , editor_cmd .. " " .. dir .. "/rc.lua" }                   , 
   { "restart"     , awesome.restart }                                         , 
   { "quit"        , awesome.quit }
   }

develop = {
	{ "Android" , "~/Motorola_Mobility/MOTODEV_Studio_for_Android_2.2/motodevstudio.sh" }, 
	{ "MonoDevelop" , "monodevelop" } , 
	{ "NetBeans"    , "netbeans" }    , 
	{ "gVim"        , "gvim" }
	}
	
music = {
	{ "Audacious", "audacious" },
	{ "Ncmpcpp", env.terminal .. " -e ncmpcpp" },
	{ "Mocp",    env.terminal .. " -e mocp" }
	}

sniffs = {
	{ "wireshark" , env.terminal .. " -e sudo wireshark" }
	}

firewall = {
	{ "Ubuntu Firewall" , env.terminal .. " -e sudo gufw" } ,
	{ "firestarter" , env.terminal .. " -e sudo firestarter" },
}
services = {
	{ "tor"      , env.terminal .. " -e sudo /etc/rc.d/tor start" }    , 
	{ "privoxy"   , env.terminal .. " -e sudo /etc/rc.d/privoxy start" } , 
	}
	

browsers = {
	{ "w3m"      , env.terminal .. " -e w3m" }    , 
	{ "elinks"   , env.terminal .. " -e elinks" } , 
	{ "firefox"  , "firefox" }, 
	{ "luakit"  , "luakit" }, 
	{ "chromium" , "chromium" }
	}

wifi = {
	{"wicd", "wicd-client"}
	}

scanners = {
	{"Nmap",  "zenmap"},
	{"Nbtscan", "urxvt -e nbtscan"}
	}

exploits = {
	{"metaspl0it", "/opt/metasploit/msfconsole"},
	{"fasttrack", "fasttrack"}
	}

network = {
	{ "Wifi"     , wifi}       , 
	{ "Expl0its" , exploits}   , 
	{ "Sniffers" , sniffs}   , 
	{ "Scanners" , scanners}   , 
	{ "Browsers" , browsers }
	}

myimagenMenu = {
    {"Gimp"     , "gimp"}     , 
    {"Gpicview" , "gpicview"} , 
    {"Nitrog3n" , "nitrogen"} , 
    {"Picasa"   , "picasa"}
	}


editors = {
    { "vim"  , env.terminal .. " -e vim"} , 
    { "gvim" , "gvim"}
	}

crypt = {
    { "TrueCrypt"  , "truecrypt"}    , 
    { "Gpa"        , "gpa"}          , 
    { "GpgCrypter" , "gpg-crypter"}
	}

utils = {
   {"Galculator", "galculator"}
   }

tools = {
	{ "Thun4r"     , "thunar"}, 
	{ "Nautilus"   , "nautilus --no-desktop"},
	{ "VirtualBox" , "VirtualBox"}
	}

dataBase = { 
	{ "Query"      , "mysql-query"}, 
	{ "Emma"       , "emma"}, 
	{ "Workbench"  , "mysql-workbench"}, 
	{ "PhpMyadmin" , "firefox http://localhost/phpmyadmin/index.php"}
	}

mymainmenu = awful.menu({ items = {
	{ "Awes0me"  , myawesomemenu , beautiful.awesome_icon } , 
	{ "Gr4phics" , myimagenMenu} , 
	--{ "edit0rs"  , editors       , beautiful.editors},
	{ "edit0rs"  , editors       , },
	{ "Mu5ic"    , music}        , 
	{ "cryp7"    , crypt}        , 
	{ "my5ql"    , dataBase}     , 
	--{ "t00ls"    , tools         , beautiful.tools},
	{ "t00ls"    , tools         , },
	{ "Dev3lop"  , develop}      , 
	{ "netw0rk"  , network}      , 
	{ "Servic3s"  , services}      , 
	{ "Util5"    , utils}
	}
    })

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon), menu = mymainmenu })
