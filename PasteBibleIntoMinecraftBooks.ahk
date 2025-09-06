#Requires AutoHotkey v2.0
#Include jsongo.v2.ahk

newBookSleep := 3 ;In seconds

BibleFolder := DirSelect(,2,"Select Bible Location")
if BibleFolder == "" {
    BibleFolder := "Bible-niv-main"
}

if FileExist(BibleFolder . "\Psalms.json") { 
    ;Psalms
    bookOrder := [
    "Genesis",
    "Exodus",
    "Leviticus",
    "Numbers",
    "Deuteronomy",
    "Joshua",
    "Judges",
    "Ruth",
    "1 Samuel",
    "2 Samuel",
    "1 Kings",
    "2 Kings",
    "1 Chronicles",
    "2 Chronicles",
    "Ezra",
    "Nehemiah",
    "Esther",
    "Job",
    "Psalms",
    "Proverbs",
    "Ecclesiastes",
    "Song Of Solomon",
    "Isaiah",
    "Jeremiah",
    "Lamentations",
    "Ezekiel",
    "Daniel",
    "Hosea",
    "Joel",
    "Amos",
    "Obadiah",
    "Jonah",
    "Micah",
    "Nahum",
    "Habakkuk",
    "Zephaniah",
    "Haggai",
    "Zechariah",
    "Malachi",
    "Matthew",
    "Mark",
    "Luke",
    "John",
    "Acts",
    "Romans",
    "1 Corinthians",
    "2 Corinthians",
    "Galatians",
    "Ephesians",
    "Philippians",
    "Colossians",
    "1 Thessalonians",
    "2 Thessalonians",
    "1 Timothy",
    "2 Timothy",
    "Titus",
    "Philemon",
    "Hebrews",
    "James",
    "1 Peter",
    "2 Peter",
    "1 John",
    "2 John",
    "3 John",
    "Jude",
    "Revelation"
    ]
} else { 
    ;Psalm
    bookOrder := [
    "Genesis",
    "Exodus",
    "Leviticus",
    "Numbers",
    "Deuteronomy",
    "Joshua",
    "Judges",
    "Ruth",
    "1 Samuel",
    "2 Samuel",
    "1 Kings",
    "2 Kings",
    "1 Chronicles",
    "2 Chronicles",
    "Ezra",
    "Nehemiah",
    "Esther",
    "Job",
    "Psalm",
    "Proverbs",
    "Ecclesiastes",
    "Song Of Solomon",
    "Isaiah",
    "Jeremiah",
    "Lamentations",
    "Ezekiel",
    "Daniel",
    "Hosea",
    "Joel",
    "Amos",
    "Obadiah",
    "Jonah",
    "Micah",
    "Nahum",
    "Habakkuk",
    "Zephaniah",
    "Haggai",
    "Zechariah",
    "Malachi",
    "Matthew",
    "Mark",
    "Luke",
    "John",
    "Acts",
    "Romans",
    "1 Corinthians",
    "2 Corinthians",
    "Galatians",
    "Ephesians",
    "Philippians",
    "Colossians",
    "1 Thessalonians",
    "2 Thessalonians",
    "1 Timothy",
    "2 Timothy",
    "Titus",
    "Philemon",
    "Hebrews",
    "James",
    "1 Peter",
    "2 Peter",
    "1 John",
    "2 John",
    "3 John",
    "Jude",
    "Revelation"
    ]
}

bible := LoadBooksFromJson(bookOrder)
ChunkedBible := ChunkBooksIntoPages()




LoadBooksFromJson(bookOrder) {
    tempMap := Map()
    for book in bookOrder {
        tempBookJson := FileRead(BibleFolder . "\" . book . ".json", "UTF-8")
        tempMap[book] := jsongo.Parse(tempBookJson)
        if tempMap[book].Has(book) { ;converts from different JSON format
            tempMap[book]["chapters"] := []
            j := 1
            while j <= tempMap[book][book].count {
                verses := tempMap[book][book][String(j)]
                chpMap := Map()
                chpMap["chapter"] := String(j)
                chpMap["verses"] := []
                i := 1
                while i <= verses.count {
                    verMap := Map()
                    verMap["verse"] := String(i)
                    verMap["text"] := verses[String(i)]
                    chpMap["verses"].Push(verMap)
                    i++
                }
                tempMap[book]["chapters"].Push(chpMap)
                j++
            }
            tempMap[book]["book"] := book
            tempMap[book]["count"] := tempMap[book]["chapters"].Length
            tempMap[book].Delete(book)
        }
    }
    return tempMap
}

ChunkBooksIntoPages() {
    tempMap := Map()

    pageCounter := 1
    totalMCBookNum := 0
    for book, v in bible {
        tempMap[book] := Map()
        tempMap[book]["Pages"] := []
        pageString := ""
        for chp in bible[book]["chapters"] {
            chapterNum := "(" . chp["chapter"] . ") "
            if (StrLen(pageString) <= 225) {
                        pageString .= chapterNum
                    } else {
                        tempMap[book]["Pages"].Push(pageString)
                        pageCounter++
                        pageString := ""
                        pageString .= chapterNum
                    }
            for ver in chp["verses"] {
                verseNum := ver["verse"] . " "
                if (StrLen(pageString) <= 225) {
                        pageString .= verseNum
                    } else {
                        tempMap[book]["Pages"].Push(pageString)
                        pageCounter++
                        pageString := ""
                        pageString .= verseNum
                    }
                loop parse ver["text"], A_Space {
                    word := A_LoopField . " "
                    wordLen := StrLen(word)
                    if ((StrLen(pageString) + wordLen) <= 256) {
                        pageString .= word
                    } else {
                        tempMap[book]["Pages"].Push(pageString)
                        pageCounter++
                        pageString := ""
                        pageString .= word
                    }
                }
                ;if book == "John" {
                ;    OutputDebug("Book: " . book . "   Chapter: " . chp["chapter"] . "   Verse: " . ver["verse"])
                ;}
            }
        }
        tempMap[book]["Pages"].Push(pageString)
        pageCounter++
        tempMap[book]["PageNum"] := pageCounter
        tempMap[book]["MCBookNum"] := Ceil(pageCounter / 100) ;100 pages per MC book
        totalMCBookNum += Ceil(pageCounter / 100)
        pageCounter := 1
    }
    tempMap["TotalMCBookNum"] := totalMCBookNum

    return tempMap
}

WriteAllBooks(*) {
    if MsgBox("You will need " . ChunkedBible["TotalMCBookNum"] . " Minecraft books to write the whole Bible.`n`nReady?", "MC Bible Writer", 1) == "Cancel" {
        return
    }
    for book, v in ChunkedBible {
        if MsgBox("Open a new Book and Quill", "MC Bible Writer", 1) == "Cancel" {
            return
        }
        Sleep(newBookSleep * 1000)
        subBook := 100
        for i, page in v["Pages"] {
            if i = subBook + 1 {
                ;Sign current book
                Send("{Tab}{Tab}{Tab}{Enter}")
                Sleep(100)
                SendText(SubStr(book, 1, 6) . " - Book " . (subBook // 100))
                Sleep(100)
                Send("{Tab}{Enter}")
                subBook += 100

                ;Ask for new book
                if MsgBox("Open a new Book and Quill", "MC Bible Writer", 1) == "Cancel" {
                    return
                }
                Sleep(newBookSleep * 1000)
            }
            text := ScrubText(page)
            SendText(text)
            Sleep(100)
            Send("{PgDn}")
            Sleep(100)
        }
        ;Sign current book
        Send("{Tab}{Tab}{Tab}{Enter}")
        Sleep(100)
        if subBook = 100 {
            SendText(book)
        } else {
            SendText(SubStr(book, 1, 6) . " - Book " . (subBook // 100))
        }
        Sleep(100)
        Send("{Tab}{Enter}")
    }
}

WriteOneBooks(*) {
    book := InputBox("Which book to write?", "Single Book Writer").Value
    v := ChunkedBible[book]
    if MsgBox("You will need " . v["MCBookNum"] . " Minecraft books to write " . book . ".`n`nReady?", "Single Book Writer", 1) == "Cancel" {
        return
    }
    if MsgBox("Open a new Book and Quill", "Single Book Writer", 1) == "Cancel" {
        return
    }
    Sleep(newBookSleep * 1000)
    subBook := 100
    for i, page in v["Pages"] {
        if i = subBook + 1 {
            ;Sign current book
            Send("{Tab}{Tab}{Tab}{Enter}")
            Sleep(100)
            SendText(SubStr(book, 1, 6) . " - Book " . (subBook // 100))
            Sleep(100)
            Send("{Tab}{Enter}")
            subBook += 100

            ;Ask for new book
            if MsgBox("Open a new Book and Quill", "Single Book Writer", 1) == "Cancel" {
                return
            }
            Sleep(newBookSleep * 1000)
        }
        text := ScrubText(page)
        SendText(text)
        Sleep(100)
        Send("{PgDn}")
        Sleep(100)
    }
    ;Sign current book
    Send("{Tab}{Tab}{Tab}{Enter}")
    Sleep(100)
    if subBook = 100 {
        SendText(book)
    } else {
        SendText(SubStr(book, 1, 6) . " - Book " . (subBook // 100))
    }
    Sleep(100)
    Send("{Tab}{Enter}")
}


ScrubText(text) {
    text := StrReplace(text, "``", "`'")
    text := StrReplace(text, "“", "`"")
    text := StrReplace(text, "”", "`"")
    text := StrReplace(text, "‘", "`'")
    return text
}


Hotkey "F9", WriteOneBooks
Hotkey "F10", WriteAllBooks
Hotkey "F8", EndScript

;For testing and debugging
;HotKey "F7", PageLookup
;HotKey "F7", ReadJohn

EndScript(*) {
    ExitApp(0)
}


PageLookup(*) {
    book := InputBox("Which book?", "Page Lookup").Value
    Page := Integer(InputBox("Which page?", "Page Lookup").Value)

    MsgBox(ChunkedBible[book]["Pages"][Page])
}

ReadJohn(*) {
    for i, Page in ChunkedBible["John"]["Pages"] {
        if MsgBox(ChunkedBible["John"]["Pages"][i], "John Page: " . i, 1) == "Cancel" {
            break
        }
    }
}

/*
;how many minecraft books per bible book
bruh := ""
for book, v in ChunkedBible {
    bruh .= book . ": " . (v["PageNum"] / 100) . "`n"
}
MsgBox(bruh)
*/

/*
;how many minecraft books total
bruh := 0
for book, v in ChunkedBible {
    x := v["PageNum"] / 100
    y := v["PageNum"] // 100
    z := x - y
    bruh += (z > 0 ? y + 1 : y)
}
MsgBox(bruh)
*/






;MsgBox(ChunkedBible["John"]["Pages"][1])
;MsgBox(bible["John"]["chapters"][3]["verses"][16]["text"])
;MsgBox(bible["John"]["chapters"][11]["verses"][35]["text"])

