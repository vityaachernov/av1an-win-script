@echo off
TITLE Av1an Win Script 🐦

cls

setlocal enabledelayedexpansion 

:: Set path 
set "AV1=%~dp0"

:: Set Wget command
set "Download-->=%AV1%\wget.exe -q -N --show-progress"

:: Set 7zr command
set "Extract-->=%AV1%\7zr.exe -y x"

:: Correct path
cd "%AV1%"

echo   Installing
echo  ````````````

:: Create directories if they don't exist
for %%d in (
    ".\input"
    ".\input\completed-inputs"
    ".\output"
    ".\dependencies\vapoursynth64-r62"
    ".\dependencies\ffmpeg-5.1.2"
    ".\dependencies\ffmpeg-latest"
    ".\dependencies\mkvtoolnix"
    ".\dependencies\svt-av1"
    ".\dependencies\vmaf"
    ".\dependencies\aom"
    ".\dependencies\rav1e"
    ".\dependencies\x264"
    ".\dependencies\x265"
    ".\scripts\ffmpeg\input"
    ".\scripts\ffmpeg\input\completed-inputs"
    ".\scripts\ffmpeg\output"
    ".\scripts\ffmpeg-vp9\input"
    ".\scripts\ffmpeg-vp9\input\completed-inputs"
    ".\scripts\ffmpeg-vp9\output"
) do if not exist "%%~d" mkdir "%%~d"

popd

:: Download portable Wget
curl -O -C - --progress-bar https://web.archive.org/web/20230511215002/https://eternallybored.org/misc/wget/1.21.4/64/wget.exe

:: Download portable 7zip
%Download-->% https://www.7-zip.org/a/7zr.exe

:: Download av1an
%Download-->% https://github.com/master-of-zen/Av1an/releases/download/latest/av1an.exe

pushd .\dependencies\ffmpeg-5.1.2

:: Download ffmpeg with shared libaries ~5.1.2 
%Download-->% https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-5.1.2-full_build-shared.7z
%Extract-->% .\ffmpeg-5.1.2-full_build-shared.7z ffmpeg-5.1.2-full_build-shared\bin > nul

:: Move contents of bin
for /R "ffmpeg-5.1.2-full_build-shared\bin" %%f in (*) do (
    move "%%f" "%destination%" > nul
)

rmdir /s /q .\ffmpeg-5.1.2-full_build-shared

cd ..\
cd .\ffmpeg-latest

:: Download the latest ffmpeg bins 
%Download-->% https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-essentials.7z -O ffmpeg-latest.7z
%Extract-->% .\ffmpeg-latest.7z *.exe -r > nul

:: Move files out of bin
for /r %%i in (*) do (
    move "%%i" "%%~nxi" > nul
)

:: Clean up
for /d /r %%i in (*) do (
    rd /s /q "%%i" > nul
)

cd ..\

:: Download portable mkvtoolnix 
%Download-->% https://mkvtoolnix.download/windows/releases/76.0/mkvtoolnix-64-bit-76.0.7z -O mkvtoolnix.7z
%Extract-->% .\mkvtoolnix.7z > nul
del .\mkvtoolnix.7z

cd .\aom

:: Download aom av1 encoder
%Download-->% https://github.com/BlueSwordM/aom-av1-psy/releases/download/aom-av1-psy-1.0.0/Skylake.Windows.aom-av1-psy-Windows-Endless_Possibility-LTO-2022-09-06.7z
%Extract-->% Skylake.Windows.aom-av1-psy-Windows-Endless_Possibility-LTO-2022-09-06.7z > nul
MOVE /y aom-av1-psy-Windows-Endless_Possibility-Skylake-LTO-2022-09-06.exe aomenc.exe > nul

cd ..\
cd .\vmaf

:: Download vmaf model
%Download-->% https://raw.githubusercontent.com/Netflix/vmaf/master/model/vmaf_v0.6.1neg.json
%Download-->% https://raw.githubusercontent.com/Netflix/vmaf/master/model/vmaf_4k_v0.6.1neg.json

cd ..\
cd .\x264

:: Download x264 encoder
%Download-->% https://artifacts.videolan.org/x264/release-win64/x264-r3107-a8b68eb.exe -O x264.exe

cd ..\
cd .\x265

:: Download x265 encoder
%Download-->% https://github.com/jpsdr/x265/releases/download/r3.50.103/x265_r3_5_0_103.7z
%Extract-->% .\x265_r3_5_0_103.7z > nul
MOVE /y .\Winthread\Multilib\Release\x265_x64.exe x265.exe > nul
rmdir /s /q .\winthread
rmdir /s /q .\llvm
del ReadMe.txt

cd ..\
cd .\rav1e

:: Download rav1e
%Download-->% https://github.com/xiph/rav1e/releases/latest/download/rav1e.exe

cd ..\
cd .\vapoursynth64-r62

:: Download embedded Python ~3.11.2
%Download-->% https://www.python.org/ftp/python/3.11.2/python-3.11.2-embed-amd64.zip
tar -xf .\python-3.11.2-embed-amd64.zip 
del .\python-3.11.2-embed-amd64.zip

:: Download VapourSynth64 Portable ~R62
%Download-->% https://github.com/vapoursynth/vapoursynth/releases/download/R62/VapourSynth64-Portable-R62.7z
%Extract-->% .\VapourSynth64-Portable-R62.7z > nul
del .\VapourSynth64-Portable-R62.7z

:: Download plugins [But its broken for now]
:: .\python.exe .\vsrepo.py update -p
:: .\python.exe .\vsrepo.py install lsmas ffms2 -p

cd ..\
cd .\svt-av1

:: Download SVT-AV1 release ~1.5.0
curl -sLf "https://gitlab.com/AOMediaCodec/SVT-AV1/-/jobs/4187469677/artifacts/download?file_type=archive" -O NUL -w "%%{url_effective}" > ./raw.txt

(for /f "usebackq delims=" %%a in ("raw.txt") do (
    set "line=%%a"
    set "line=!line:~0,-11!"
    echo !line!
)) > "downloadlink.txt"


%Download-->% -i .\downloadlink.txt -O SVT-AV1-1.5.zip

:: Clean up
del download > nul 2>&1
del downloadlink.txt > nul
del raw.txt > nul

tar -xf .\SVT-AV1-1.5.zip --strip-components 2 > nul

popd

:: Clean up
del .wget-hsts > nul
del wget.exe > nul
del 7zr.exe > nul
del preview.png > nul

echo:
echo Installation Finished
echo:   Exiting...
echo:
