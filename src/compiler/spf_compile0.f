\ $Id: spf_compile0.f,v 1.9 2009/02/22 20:22:04 spf Exp $

\ Компиляция чисел словарь.
\  ОС-независимые определения.
\  Copyright [C] 1992-1999 A.Cherezov ac@forth.org
\  Преобразование из 16-разрядного в 32-разрядный код - 1995-96гг
\  Ревизия - сентябрь 1999, март 2000


  USER CURRENT     \ дает wid текущего словаря компиляции

  VARIABLE (DP)    \ переменная, содержащая HERE сегмента данных
4 CONSTANT CFL     \ длина кода, компилируемого CREATE в сегмент CS.
  USER     DOES>A  \ временная переменная - адрес для DOES>

: SET-CURRENT ( wid -- ) \ 94 SEARCH
\ Установить список компиляции на список, идентифицируемый wid.
  CURRENT !
;

: GET-CURRENT ( -- wid ) \ 94 SEARCH
\ Возвращает wid - идентификатор списка компиляции.
  CURRENT @
;

: IS-TEMP-WORDLIST ( wid -- flag )
\ проверяет, является ли словарь wid временным (внешним)
  CELL- @ -1 =
;
: IS-TEMP-WL ( -- flag )
\ проверяет, является ли текущий словарь компиляции временным (внешним)
  GET-CURRENT IS-TEMP-WORDLIST
;
: DP ( -- addr ) \ переменная, содержащая HERE сегмента данных
  (DP) EXIT
  IS-TEMP-WL
  IF GET-CURRENT 7 CELLS + ELSE (DP) THEN
;

: ALLOT ( n -- ) \ 94
\ Если n больше нуля, зарезервировать n байт пространства данных. Если n меньше 
\ нуля - освободить |n| байт пространства данных. Если n ноль, оставить 
\ указатель пространства данных неизменным.
\ Если перед выполнением ALLOT указатель пространства данных выровнен и n
\ кратно размеру ячейки, он остается выровненным и после ALLOT.
\ Если перед выполнением ALLOT указатель пространства данных выровнен на
\ границу символа и n кратно размеру символа, он остается выровненным на
\ границу символа и после ALLOT.
  DP +!
;

: , ( x -- ) \ 94
\ Зарезервировать одну ячейку в области данных и поместить x в эту ячейку.
  DP @ 4 ALLOT !
;

: C, ( char -- ) \ 94
\ Зарезервировать место для символа в области данных и поместить туда char.
  DP @ 1 CHARS ALLOT C!
;

: W, ( word -- )
\ Зарезервировать место для word в области данных и поместить туда char.
  DP @ 2 ALLOT W!
;
