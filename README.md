# Minecraft Bible Printer
This AutoHotKey v2 script takes the Bible in JSON format and divides it into chunks that fit Minecraft book pages. It then provides functions to paste either a single book or all books of the Bible.

Default hotkeys:
- F9 -> Print one book
- F10 -> Print all books
- F8 -> Terminate the script

When one of the main hotkeys is pressed (F9 or F10), a message box will open saying how many Minecraft books will be needed and asking if you are ready to proceed.

![alt text](https://github.com/HarryPotato986/MCBiblePrinter/raw/main/README_IMAGES/MCBibleWriter.png)
![alt text](https://github.com/HarryPotato986/MCBiblePrinter/raw/main/README_IMAGES/SingleBookWriter.png)

Once OK is pressed you will get another prompt telling you to open a new Book and Quill. When you press OK again the script gives you 3 seconds to return the focus to Minecraft before it starts printing. (The length of this delay can be changed by changing the "newBookSleep" variable at the top of the script)

## How To Install
1. Install AHK v2 https://www.autohotkey.com/v2/
2. Clone or download files
3. Run PasteBibleIntoMinecraftBooks.ahk

## Sources
- Bible-niv-main was taken from https://github.com/aruljohn/Bible-niv/
- jsongo.v2.ahk was taken from https://github.com/GroggyOtter/jsongo_AHKv2

## How To Change Translations
When you start the script it will prompt you to choose the folder where the JSON files are located.

The script is hardcoded to read the JSON structure from [Aruljohn](https://github.com/aruljohn) or [jadenzaleski](https://github.com/jadenzaleski). Aruljohn also has a [KJV translation](https://github.com/aruljohn/Bible-kjv), while jadenzaleski has a large number of translations avalible [here](https://github.com/jadenzaleski/BibleTranslations/).
