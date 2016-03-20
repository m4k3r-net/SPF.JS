\ $Id: spf_immed_transl.f,v 1.7 2006/12/04 21:15:59 ygreks Exp $

\ Слова немедленного выполнения, используемые в режиме компиляции.
\  ОС-независимые определения.
\  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
\  Преобразование из 16-разрядного в 32-разрядный код - 1995-96гг
\  Ревизия - сентябрь 1999


: TO \ 94 CORE EXT
\ Интерпретация: ( x "<spaces>name" -- )
\ Пропустить ведущие пробелы и выделить name, ограниченное пробелом.
\ Записать x в name. Неопределенная ситуация возникает, если name не
\ определено через VALUE.
\ Компиляция: ( "<spaces>name" -- )
\ Пропустить ведущие пробелы и выделить name, ограниченное пробелом.
\ Добавить семантику времени выполнения, данную ниже, к текущему определению.
\ Неопределенная ситуация возникает, если name не определено через VALUE.
\ Время выполнения: ( x -- )
\ Записать x в name.
\ Примечание: Неопределенная ситуация возникает, если POSTPONE или [COMPILE]
\ применяются к TO.
  ' DUP CELL+ ( addr ) SWAP
  CELL+ CELL+ @ ( cfa of to )
  STATE @
  IF SWAP LIT, 0 , , ELSE EXECUTE THEN
; IMMEDIATE

: POSTPONE \ 94
\ Интерпретация: семантика не определена.
\ Компиляция: ( "<spaces>name" -- )
\ Пропустить ведущие разделители. Выделить имя, ограниченное пробелами.
\ Найти имя. Добавить семантику компиляции имени в текущее определение.
  ?COMP
  PARSE-NAME SFIND DUP
  0= IF -321 THROW THEN
  1 = IF COMPILE,
      ELSE LIT, ['] COMPILE, COMPILE, THEN
; IMMEDIATE

: \   \ 94 CORE EXT
\ Компиляция: Выполнить семантику выполнения, данную ниже.
\ Выполнение: ( "ccc<eol>" -- )
\ Выделить и отбросить остаток разбираемой области.
\ \ - слово немедленного исполнения.
  1 PARSE 2DROP
; IMMEDIATE

: .(  \ 94 CORE EXT
\ Компиляция: Выполнить семантику выполнения, данную ниже.
\ Выполнение: ( "ccc<paren>" -- )
\ Выделить и вывести на дисплей ccc, ограниченные правой скобкой ")".
\ .( - слово немедленного исполнения.
  [CHAR] ) PARSE TYPE
; IMMEDIATE

: (  ( "ccc<paren>" -- ) \ 94 FILE
\ Расширить семантику CORE (, включив:
\ Когда разбирается текстовый файл, если конец разбираемой области достигнут
\ раньше, чем найдена правая скобка, снова заполнить входной буфер следующей
\ строкой из файла, установить >IN в ноль и продолжать разбор, повторяя
\ этот процесс до тех пор, пока не будет найдена правая скобка или не
\ будет достигнут конец файла.
  BEGIN
    [CHAR] ) DUP PARSE + C@ = 0=
  WHILE
    REFILL 0= IF EXIT THEN
  REPEAT
; IMMEDIATE

: [COMPILE]  \ 94 CORE EXT
\ Интерпретация: семантика неопределена.
\ Компиляция: ( "<spaces>name" -- )
\ Пропустить ведущие пробелы. Выделить name, ограниченное пробелами.
\ Найти name. Если имя имеет иную семантику компиляции, чем "по-умолчанию", 
\ добавить ее в текущее определение; иначе добавить семантику выполнения name.
\ Неопределенная ситуация возникает, если name не найдено.
  ?COMP
  '
  COMPILE,
; IMMEDIATE

: ; ( -- )
  RET, [COMPILE] [ SMUDGE
  0 TO LAST-NON
; IMMEDIATE

: EXIT
  RET,
; IMMEDIATE

: \EOF  ( -- )
\ Заканчивает трансляцию текущего потока
  BEGIN REFILL 0= UNTIL
  POSTPONE \
;

: --
  CREATE OVER , +
  (DOES1) @ +
;

