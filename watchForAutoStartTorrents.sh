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

#Best guesses below apple ii
declare -A SYSTEMS=(
	["various artists-music"]="Music:Music"
	["various artists-books"]="Books:Books,Games"
	["playstation 1"]="PSX:PSX,Games"
	["playstation 2"]="PS2:PS2,Games"
	["playstation 3"]="PS3:PS3,Games"
	["playstation 4"]="PS4:PS4,Games"
	["dreamcast"]="Dreamcast:Dreamcast,Games"
	["nintendo ds"]="NDS:NDS,Games"
	["nes"]="NES:NES,Games"
	["amiga"]="Amiga:Amiga,Games"
	["windows"]="PC:PC,Games"
	["xbox"]="Xbox:Xbox,Games"
	["apple ii"]="Apple2:Apple2,Games"
	["v.smile"]="VSmile:V.Smile,Games"
	["turbografx-16"]="TurboGrafx-16:TurboGrafx-16"
	["mega drive"]="Sega_Genesis_MegaSG:SegaGenesis,Games"
	["sega genesis"]="Sega_Genesis_MegaSG:SegaGenesis,Games"
	["sega cd"]="Sega_Genesis_MegaSG:SegaGenesis,Games"
	["playstation vita"]="PSVita:PSVita,Games"
	["playstation portable"]="PSP:PSP,Games"
	["mac"]="Mac:Mac,Games"
	["sg-1000"]="SG-1000:SG-1000,Games"
	["xbox 360"]="Xbox360:Xbox360,Games"
	["dos"]="DOS:DOS,Games"
	["wii"]="Wii:Wii,Games"
	["wii u"]="WiiU:WiiU,Games"
	["switch"]="Switch:Switch,Games"
	["nintendo 3ds"]="3DS:3DS,Games"
	["zx spectrum"]="ZXSpectrum:ZXSpectrum,Games"
	["super nintendo"]="SNES:SNES,Games"
	["gamecube"]="Gamecube:Gamecube,Games"
	["pico"]="Pico:Pico,Games"
	["linux"]="Linux:Linux,Games"
	["gameboy color"]="GBC:GBC,Games"
	["gameboy advance"]="GBA:GBA,Games"
	["gameboy"]="Gameboy:Gameboy,Games"
	["amiga"]="Amiga:Amiga,Games"
	["commodore 64"]="Commodore64:Commodore64,Games"
	["amstrad cpc"]="AmstradCPC:AmstradCPC,Games"
	["3do"]="3DO:3DO,Games"
	["sega saturn"]="SegaSaturn:SegaSaturn,Games"
	["pc-98"]="PC-98:PC-98,Games"
	["android"]="Android:Android,Games"
	["cd-i"]="CD-i:CD-i,Games"
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
	echo Login Failed!

	find "$AUTO_BASE" -type f -depth +0 -print0 | head -n1 | while IFS= read -r -d '' file; do 
		echo Got new file $file
		system="` basename "$file" | awk -F ' - ' '{ print tolower($1) }' `"
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
		echo File: $file
		echo Tags: [$tags]
		echo Destination: $destination
		echo Base64: ${base64file:0:20}...${base64file: -20}
		echo

		curl -L -X POST --fail \
			-H "Content-Type: application/json; charset=utf-8" \
			--cookie-jar ./flood-cookies.txt --cookie ./flood-cookies.txt \
			-d '{"files":["'"$base64file"'"],"destination":"'"$destination"'","isBasePath":false,"isCompleted":false,"isSequential":false,"start":true,"tags":['"$tags"',"Scripted"]}' \
			https://flood.finaldoom.net/api/torrents/add-files ||
		echo Sending failed! &&
		mv "$file" $ADDED_BASE/
		echo
		echo
	done
	# Clean up login
	rm ./flood-cookies.txt 2>/dev/null
done
