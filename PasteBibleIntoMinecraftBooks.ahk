#Requires AutoHotkey v2.0
#Include jsongo.v2.ahk

booksJson := FileRead("Bible-niv-main/Books.json")
bookOrder := jsongo.Parse(booksJson)

bible := LoadBooksFromJson(bookOrder)
ChunkedBible := ChunkBooksIntoPages()




LoadBooksFromJson(bookOrder) {
    tempMap := Map()

    for book in bookOrder {
        ;MsgBox(each)
        tempBookJson := FileRead("Bible-niv-main/" . book . ".json", "UTF-8")
        tempMap[book] := jsongo.Parse(tempBookJson)
        ;tempMap.Set(book,jsongo.Parse(tempBookJson))
    }
    return tempMap
}

ChunkBooksIntoPages() {
    tempMap := Map()

    pageCounter := 1
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
        pageCounter := 1
    }

    return tempMap
}

WriteAllBooks(*) {
    for book, v in ChunkedBible {
        if MsgBox("Open new book", "MC Bible Writer", 1) == "Cancel" {
            return
        }
        Sleep(3000)
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
                if MsgBox("Open new book", "MC Bible Writer", 1) == "Cancel" {
                    return
                }
                Sleep(3000)
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
    if MsgBox("Open new book", "MC Bible Writer", 1) == "Cancel" {
        return
    }
    Sleep(3000)
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
            if MsgBox("Open new book", "MC Bible Writer", 1) == "Cancel" {
                return
            }
            Sleep(3000)
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
HotKey "F7", PageLookup

EndScript(*) {
    ExitApp(0)
}


PageLookup(*) {
    book := InputBox("Which book?", "Page Lookup").Value
    Page := Integer(InputBox("Which page?", "Page Lookup").Value)

    MsgBox(ChunkedBible[book]["Pages"][Page])
}

/*
MsgBox("Open new book")
Sleep(3000)
text := ScrubText(ChunkedBible["John"]["Pages"][1])
SendText(text)
*/


/*
;how many minecraft books per bible book
bruh := ""
for book, v in ChunkedBible {
    bruh .= book . ": " . (v["PageNum"] / 100) . "`n"
}
MsgBox(bruh)
*/

/*
bruh := 0
for book, v in ChunkedBible {
    x := v["PageNum"] / 100
    y := v["PageNum"] // 100
    z := x - y
    bruh += (z > 0 ? y + 1 : y)
}
MsgBox(bruh)
*/



/*
for i, Page in ChunkedBible["John"]["Pages"] {
    if MsgBox(ChunkedBible["John"]["Pages"][i], "John Page: " . i, 1) == "Cancel" {
        break
    }
}
*/

;MsgBox(ChunkedBible["John"]["Pages"][1])
;MsgBox(bible["John"]["chapters"][3]["verses"][16]["text"])
;MsgBox(bible["John"]["chapters"][11]["verses"][35]["text"])

