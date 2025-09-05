# Minecraft Bible Printer
This AutoHotKey v2 script takes the Bible in JSON format and divides it into chunks that fit Minecraft book pages. It then provides functions to paste either a single book or all books of the Bible.

Default hotkeys:
- F9 -> Print one book
- F10 -> Print all books
- F8 -> Terminate the script

## How To Install
1. Install AHK v2 https://www.autohotkey.com/v2/
2. Clone or download files
3. Run PasteBibleIntoMinecraftBooks.ahk

## Sources
- Bible-niv-main was taken from https://github.com/aruljohn/Bible-niv/tree/main
- jsongo.v2.ahk was taken from https://github.com/GroggyOtter/jsongo_AHKv2

## How To Change Translations
The script is hardcoded to read the JSON structure from aruljohn. They also have a KJV (https://github.com/aruljohn/Bible-kjv), which will work as is. I also intend to write a function to translate the JSON structure from https://github.com/jadenzaleski/BibleTranslations/tree/master to work with the script.
