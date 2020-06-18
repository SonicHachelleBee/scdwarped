@ECHO OFF

REM // ask to uncompress archives of iso files
IF NOT EXIST "Sonic CD (J)\Sonic CD (J).iso" goto LABLERROR6
IF NOT EXIST "Sonic CD (U)\Sonic CD (U).iso" goto LABLERROR7
IF NOT EXIST "Sonic CD (E)\Sonic CD (E).iso" goto LABLERROR8

REM // make sure we can write to the file scdbuilt.iso
REM // also make a backup to scdbuilt.prev.iso
IF NOT EXIST scdbuilt.iso goto LABLNOCOPY
IF EXIST scdbuilt.prev.iso del scdbuilt.prev.iso
IF EXIST scdbuilt.prev.iso goto LABLNOCOPY
move /Y scdbuilt.iso scdbuilt.prev.iso > NUL
IF EXIST scdbuilt.iso goto LABLERROR3
REM IF EXIST scdbuilt.prev.iso copy /Y scdbuilt.prev.iso scdbuilt.iso
:LABLNOCOPY

REM // delete some intermediate assembler output just in case
IF EXIST scdwarped.p del scdwarped.p
IF EXIST scdwarped.p goto LABLERROR2
IF EXIST scdwarped.h del scdwarped.h
IF EXIST scdwarped.h goto LABLERROR1

REM // clear the output window
REM cls


REM // run the assembler
REM // -xx shows the most detailed error output
REM // -c outputs a shared file (scdwarped.h)
REM // -q shuts up AS
REM // -U forces case-sensitivity
REM // -A gives us a small speedup
set AS_MSGPATH=win32/as
set USEANSI=n

set debug_syms=
set print_err=-E -q
set s2p2bin_args=

:parseloop
IF "%1"=="-ds" (
	set debug_syms=-g MAP
	echo Will generate debug symbols
)
IF "%1"=="-pe" (
	REM // allow the user to choose to print error messages out by supplying the -pe parameter
	set print_err=
	echo Selected detailed assembler output
)
SHIFT
IF NOT "%1"=="" goto parseloop

echo Building Sonic CD Warped
echo Assembling...

"win32/as/asw" -xx -c %debug_syms% %print_err% -A -U -L scdwarped.asm

REM // if there were errors, there won't be any scdwarped.p output
IF NOT EXIST scdwarped.p goto LABLERROR5

REM // combine the assembler output into an iso
"win32/s2p2bin" %s2p2bin_args% scdwarped.p scdbuilt.iso scdwarped.h

REM // if there were errors/warnings, a log file is produced
IF EXIST scdwarped.log goto LABLERROR4


REM // done -- pause if we seem to have failed, then exit
IF EXIST scdbuilt.iso exit /b

pause


exit /b

:LABLERROR1
echo Failed to build because write access to scdwarped.h was denied.
pause


exit /b

:LABLERROR2
echo Failed to build because write access to scdwarped.p was denied.
pause


exit /b

:LABLERROR3
echo Failed to build because write access to scdbuilt.iso was denied.
pause

exit /b

:LABLERROR4
REM // display a noticeable message
echo.
echo **********************************************************************
echo *                                                                    *
echo *   There were build warnings. See scdwarped.log for more details.   *
echo *                                                                    *
echo **********************************************************************
echo.
pause

exit /b

:LABLERROR5
REM // display a noticeable message
echo.
echo **********************************************************************
echo *                                                                    *
echo *    There were build errors. See scdwarped.log for more details.    *
echo *                                                                    *
echo **********************************************************************
echo.
pause

exit /b

:LABLERROR6
echo Please, uncompress "Sonic CD (J)\Sonic CD (J).7z" before proceeding.
pause

exit /b

:LABLERROR7
echo Please, uncompress "Sonic CD (U)\Sonic CD (U).7z" before proceeding.
pause

exit /b

:LABLERROR8
echo Please, uncompress "Sonic CD (E)\Sonic CD (E).7z" before proceeding.
pause
