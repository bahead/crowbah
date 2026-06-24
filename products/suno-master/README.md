# CROWBAH — «Релизный звук за вечер»

Продукт №1. 5 команд + карта дистрибуции: сырой Suno-трек → релизный звук **-12 LUFS / -1 dBTP** без FL/Ableton, и заливка без AI-бана. Цена: 1290₽ (старт 990₽).

Источник цепочки — рабочий `MIRA_VALE_HUB/scripts/master-track.js` (адаптивная версия). Здесь — статичные дефолты для покупателя без Node.

## Команды (copy-paste)

**0. Проверить громкость трека** (узнать сколько у тебя сейчас LUFS):
```
ffmpeg -i input.wav -af loudnorm=print_format=summary -f null -
```

**1. Чистка** — убрать гул, муть 300 Гц, AI-звон 8.5 кГц:
```
ffmpeg -y -i input.wav -af "highpass=f=28:poles=2,equalizer=f=300:width_type=q:width=1.2:g=-2.0,equalizer=f=8500:width_type=q:width=2:g=-2.0" out1.wav
```

**2. Кристаллик** — воздух через эксайтер (гармоники, НЕ EQ-буст) + де-эссер:
```
ffmpeg -y -i out1.wav -af "deesser=i=0.25:m=0.4:f=0.5,aexciter=freq=9000:amount=1.5:drive=4" out2.wav
```

**3. Склейка** — компрессор-glue, ratio 2, не убивает динамику:
```
ffmpeg -y -i out2.wav -af "acompressor=threshold=-18dB:ratio=2:attack=80:release=300:knee=4:makeup=1.0" out3.wav
```

**4. Громкость релиза** — loudnorm до -12 LUFS / -1 dBTP + лимитер (attack 1ms = транзиент жив):
```
ffmpeg -y -i out3.wav -af "loudnorm=I=-12:TP=-1:LRA=8,alimiter=limit=0.891:attack=1:release=80:level=disabled" out4.wav
```

**5. Финал FLAC + чистый MP3 320** (очистка тегов, 48k):
```
ffmpeg -y -i out4.wav -map_metadata -1 -c:a flac -compression_level 8 -ar 48000 -ac 2 master.flac
ffmpeg -y -i out4.wav -map_metadata -1 -c:a libmp3lame -b:a 320k -ar 44100 -ac 2 master.mp3
```

**Всё в одном** — `master-release.bat` (перетащи трек на файл).

## Скелет гайда (8 модулей)

1. Почему Suno звучит «как демка» — муть low-mid, металлический звон, узкая сцена
2. Ставим ffmpeg за 10 минут (Win+Mac по скриншотам)
3. Команда «Чистка»
4. Команда «Кристаллик» (эксайтер vs EQ-буст)
5. Команда «Громкость релиза» (loudnorm 2-pass, лимитер без убийства транзиентов)
6. «Всё в одном» + FLAC/MP3 320, очистка тегов, обложка
7. Дистрибуция без граблей 2026: кто банит AI, где нужна пометка о синтетике
8. Чек-лист загрузки + что делать если завернули (живой раздел)

## Пруфы для лендинга

- Альбом Mirror (11 треков) + обложка — `MIRA_VALE_HUB/_SITE/assets/album-cover-mirror.jpg`
- Инфографика мастеринга — `MIRA_VALE_HUB/_history_snapshots/loudness_audit.json` (134 трека, median -12 LUFS, stddev 0.09)
- A/B «до/после» — нарезать 15 сек из MP3 320 альбома (TODO)

## TODO продукта

- [ ] Нарезать 2 A/B-семпла «сырой Suno → мастер»
- [ ] Собрать инфографику из loudness_audit.json
- [ ] Написать PDF по 8 модулям + скриншоты установки ffmpeg
- [ ] Лид-магнит: команда «Громкость» отдельным мини-PDF бесплатно
