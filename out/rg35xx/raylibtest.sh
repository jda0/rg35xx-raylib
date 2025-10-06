#!/bin/sh
# HELP: RaylibTest
# ICON: test

APP_ID=raylibtest

. /opt/muos/script/var/func.sh

if pgrep -f "playbgm.sh" >/dev/null; then
	killall -q "playbgm.sh" "mpg123"
fi

echo app >/tmp/act_go

GPTOKEYB="$(GET_VAR "device" "storage/rom/mount")/MUOS/emulator/gptokeyb/gptokeyb2"

export LD_LIBRARY_PATH=/usr/lib32

export SDL_HQ_SCALER="$(GET_VAR "device" "sdl/scaler")"

case "$(GET_VAR "device" "board/name")" in
	rg28xx)
		export SDL_ROTATION=0
		;;
	*)
		export SDL_ROTATION=3
		;;
esac

RUNDIR="$(realpath "$(dirname "$0")")/.${APP_ID}/"
echo "RUNDIR: ${RUNDIR}" > /tmp/test.log
cd "${RUNDIR}" || exit

SET_VAR "system" "foreground_process" "${APP_ID}"

HOME="${RUNDIR}" \
SDL_GAMECONTROLLERCONFIG=$(grep "Deeplay" "/usr/lib32/gamecontrollerdb.txt") \
$GPTOKEYB "./${APP_ID}" -c "./${APP_ID}.gptk" &
./${APP_ID}

kill -9 "$(pidof ${APP_ID})"
kill -9 "$(pidof gptokeyb2)"

unset SDL_HQ_SCALER
unset SDL_ROTATION
unset LD_LIBRARY_PATH
