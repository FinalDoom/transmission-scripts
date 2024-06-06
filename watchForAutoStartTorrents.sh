#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

TRANSMISSION_BASE=/mnt/transmission
AUTO_BASE=${TRANSMISSION_BASE}/ToAddAutomatically
ADDED_BASE=${TRANSMISSION_BASE}/AddedAutomatically
DOWNLOADS_BASE=${TRANSMISSION_BASE}/Downloads/Games

mkdir $AUTO_BASE 2>/dev/null
mkdir $ADDED_BASE 2>/dev/null

# Get login info
source /root/.flood
# Get colors
source $SCRIPT_DIR/colors.sh

#Best guesses below zx spectrum
declare -A SYSTEMS=(
	["various artists-music"]="Music:Music"
	["various artists-books"]="Books:Books,Games"
	["amstrad cpc"]="AmstradCPC:AmstradCPC,Games"
	["android"]="Android:Android,Games"
	["apple ii"]="Apple2:Apple2,Games"
	["commodore 64"]="Commodore64:Commodore64,Games"
	["commodore amiga"]="Amiga:Amiga,Games"
	["dos"]="DOS:DOS,Games"
	["dreamcast"]="Dreamcast:Dreamcast,Games"
	["game boy advance"]="GBA:GBA,Games"
	["game boy color"]="GBC:GBC,Games"
	["game boy"]="Gameboy:Gameboy,Games"
	["mac"]="Mac:Mac,Games"
	["master system"]="Sega_Genesis_MegaSG:SegaGenesis,Games"
	["mega drive"]="Sega_Genesis_MegaSG:SegaGenesis,Games"
	["neo geo pocket color"]="NeoGeoPocketColor:NeoGeoPocketColor,Games"
	["nes"]="NES:NES,Games"
	["nintendo 3ds"]="3DS:3DS,Games"
	["nintendo 64"]="N64:N64,Games"
	["nintendo ds"]="NDS:NDS,Games"
	["nokia n-gage"]="N-Gage:NGage,Games"
	["ouya"]="Ouya:Ouya,Games"
	["philips cd-i"]="CD-i:CD-i,Games"
	["phone-pda"]="Phone-PDA:Phone/PDA,Games"
	["playstation 1"]="PSX:PSX,Games"
	["playstation 2"]="PS2:PS2,Games"
	["playstation 3"]="PS3:PS3,Games"
	["playstation 4"]="PS4:PS4,Games"
	["playstation portable"]="PSP:PSP,Games"
	["playstation vita"]="PSVita:PSVita,Games"
	["saturn"]="Sega_Saturn:SegaSaturn,Games"
	["sega genesis"]="Sega_Genesis_MegaSG:SegaGenesis,Games"
	["sega saturn"]="Sega_Saturn:SegaSaturn,Games"
	["snes"]="SNES:SNES,Games"
	["super nintendo"]="SNES:SNES,Games"
	["switch"]="Switch:Switch,Games"
	["v.smile"]="VSmile:V.Smile,Games"
	["wii u"]="WiiU:WiiU,Games"
	["wii"]="Wii:Wii,Games"
	["windows"]="PC:PC,Games"
	["xbox 360"]="Xbox360:Xbox360,Games"
	["xbox"]="Xbox:Xbox,Games"
	["zx spectrum"]="ZXSpectrum:ZXSpectrum,Games"
	["turbografx-16"]="TurboGrafx-16:TurboGrafx-16"
	["sega cd"]="Sega_Genesis_MegaSG:SegaGenesis,Games"
	["sg-1000"]="SG-1000:SG-1000,Games"
	["gamecube"]="Gamecube:Gamecube,Games"
	["pico"]="Pico:Pico,Games"
	["linux"]="Linux:Linux,Games"
	["amiga"]="Amiga:Amiga,Games"
	["3do"]="3DO:3DO,Games"
	["pc-98"]="PC-98:PC-98,Games"
	["bandai wonderswan color"]="Wonderswan_Color:WonderswanColor,Games"
)

while :
do
	wait_on -w ${AUTO_BASE}
	# Wait till file changes stop
	until wait_on -t 1 "`find ${AUTO_BASE} -type f -depth +0 | head -n1`"
	do
		sleep 1
	done
	
	# Log in once per batch
	curl -L -X POST --silent --fail \
		-H "Content-Type: application/json; charset=utf-8" \
		--cookie-jar ./flood-cookies.txt --cookie ./flood-cookies.txt \
		-d '{"username":"'"${FLOOD_USER}"'","password":"'"${FLOOD_PASSWORD}"'"}' \
		https://flood.finaldoom.net/api/auth/authenticate > /dev/null ||
	echo ${RED}Login Failed!${RESET}

	find "$AUTO_BASE" -type f -depth +0 -print0 | head -n1 | while IFS= read -r -d '' file; do 
		echo ${CYAN}Got new file $file${RESET}
		system="` basename "$file" | sed 's/^Retro - Other - //i' | awk -F ' - ' '{ print tolower($1) }' `"
		# Special case for music/books
		if [ "$system" = "various artists" ]
		then
			case "`echo $file | awk '{ print tolower($0) }'`" in
				*mp3* | *flac*)
					system="${system}-music"
					;;
				*)
					system="${system}-books"
					;;
			esac
		fi
		systeminfo="${SYSTEMS[$system]}"
		echo Got system info $systeminfo
		destination="$DOWNLOADS_BASE/` echo $systeminfo | awk -F : '{ print $1 }' `"
		tags='"'"` echo $systeminfo | awk -F : '{ print $2 }' | sed 's/,/","/g' `"'"'
		base64file="` base64 -e "$file" | tr -d $'\n' `"

		echo
		echo Sending torrent to Flood:
		echo ${BLACK}${BGWHITE}File:${RESET} $file
		echo ${BLACK}${BGWHITE}Tags:${RESET} [$tags]
		echo ${BLACK}${BGWHITE}Destination:${RESET} $destination
		echo ${BLACK}${BGWHITE}Base64:${RESET} ${base64file:0:20}...${base64file: -20}
		echo ${GREEN}

		curl -L -X POST --fail \
			-H "Content-Type: application/json; charset=utf-8" \
			--cookie-jar ./flood-cookies.txt --cookie ./flood-cookies.txt \
			-d '{"files":["'"$base64file"'"],"destination":"'"$destination"'","isBasePath":false,"isCompleted":false,"isSequential":false,"start":true,"tags":['"$tags"',"Scripted"]}' \
			https://flood.finaldoom.net/api/torrents/add-files ||
		echo ${RED}Sending failed! &&
		echo ${RESET} &&
		mv "$file" $ADDED_BASE/
		echo
		echo
	done
	# Clean up login
	rm ./flood-cookies.txt 2>/dev/null
done
