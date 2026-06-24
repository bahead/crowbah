@echo off
chcp 65001 >nul
REM ===========================================================
REM  CROWBAH — Suno -> релизный мастер  (-12 LUFS / -1 dBTP)
REM  Перетащи WAV / MP3 / FLAC на этот файл.
REM  Нужен ffmpeg в PATH (full build, напр. gyan.dev).
REM ===========================================================
if "%~1"=="" (
  echo Перетащи трек ^(WAV/MP3/FLAC^) прямо на этот .bat
  pause
  exit /b
)
ffmpeg -y -i "%~1" -af "highpass=f=28:poles=2,equalizer=f=300:width_type=q:width=1.2:g=-2.0,equalizer=f=8500:width_type=q:width=2:g=-2.0,deesser=i=0.25:m=0.4:f=0.5,acompressor=threshold=-18dB:ratio=2:attack=80:release=300:knee=4:makeup=1.0,aexciter=freq=9000:amount=1.5:drive=4,loudnorm=I=-12:TP=-1:LRA=8,alimiter=limit=0.891:attack=1:release=80:level=disabled" -c:a flac -compression_level 8 -ar 48000 -ac 2 "%~dpn1.master.flac"
echo.
echo Готово: "%~dpn1.master.flac"
pause
