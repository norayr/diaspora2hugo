MODULE strutils;
IMPORT S := Sys, Strings;
 TYPE string* = S.string;
      pstring* = POINTER TO string;
      strings* = POINTER TO ARRAY OF string;
(* from the oo2c Strings module, implements string comparison, which should be implemented in a library level in case of Oberon-1 *)
TYPE  CompareResults* = SHORTINT;
  (**Result type of @oproc{Compare}.  *)

CONST
  less* = -1;
  (**Result of @oproc{Compare} if the first argument is lexically less
     than the second one.  *)
  equal* = 0;
  (**Result of @oproc{Compare} if the first argument is equal to the second
     one.  *)
  greater* = 1;
  (**Result of @oproc{Compare} if the first argument is lexically greater
     than the second one.  *)

 PROCEDURE Compare* (stringVal1, stringVal2: ARRAY OF CHAR): CompareResults;
(**Returns @oconst{less}, @oconst{equal}, or @oconst{greater}, according as
   @oparam{stringVal1} is lexically less than, equal to, or greater than
   @oparam{stringVal2}.  Note that Oberon-2 and Oberon-07 already contains predefined comparison operators on strings.  *)
  VAR
    i: INTEGER;
  BEGIN
    i := 0;
    WHILE (stringVal1[i] # 0X) & (stringVal1[i] = stringVal2[i]) DO
      INC (i)
    END;
    IF (stringVal1[i] < stringVal2[i]) THEN
      RETURN less
    ELSIF (stringVal1[i] > stringVal2[i]) THEN
      RETURN greater
    ELSE
      RETURN equal
    END
  END Compare;  

PROCEDURE Pos* (substr : CHAR ; s : ARRAY OF CHAR; n : INTEGER) : INTEGER;
VAR i : INTEGER;
BEGIN
FOR i := n TO Strings.Length(s) DO
IF s[i] = substr THEN RETURN(i) END;
END;
RETURN(0);
END Pos;

PROCEDURE RemoveLeftChars* (VAR s : ARRAY OF CHAR; ch : CHAR);
BEGIN
REPEAT
IF s[0] = ch THEN Strings.Delete (s, 0, 1) END;

UNTIL s[0] # ch;

END RemoveLeftChars;

PROCEDURE RemoveRightChars* (VAR s : ARRAY OF CHAR; ch : CHAR);
VAR l : INTEGER;
BEGIN
l := Strings.Length(s);
REPEAT

IF s[l] = ch THEN Strings.Delete (s, l, 1) END;
DEC(l);
UNTIL s[l] # ch;

END RemoveRightChars;

PROCEDURE WordCount* (s : ARRAY OF CHAR; ch : CHAR) : INTEGER;
VAR 
k,l : INTEGER;
BEGIN
RemoveLeftChars(s, ch);
RemoveRightChars (s, ch);
k := 0;
l := 0;
REPEAT 
IF s[l] = ch THEN 
   INC(k);
      REPEAT
      INC(l);
      UNTIL s[l] # ch;
        END;
INC(l);
UNTIL l = Strings.Length(s);
INC(k);
RETURN(k);


END WordCount;


PROCEDURE NumberOfChar* (s : ARRAY OF CHAR; ch : CHAR) : LONGINT;
VAR n, i : LONGINT;
BEGIN
n := 0;
FOR i := 0 TO Strings.Length(s) DO
IF s[i] = ch THEN INC(n) END;
END;
RETURN(n);
END NumberOfChar;

PROCEDURE Rpos* ( s : ARRAY OF CHAR ; ch : CHAR) : INTEGER;
VAR l : INTEGER;
BEGIN
l := Strings.Length (s);
IF s[l] = ch THEN RETURN(l) END;
REPEAT
DEC(l);
UNTIL s[l] = ch;
RETURN(l);
END Rpos;

PROCEDURE Lpos* ( s : ARRAY OF CHAR ; ch : CHAR) : INTEGER;
VAR l : INTEGER;
BEGIN
l := 0;
IF s[l] = ch THEN RETURN(l) END;
REPEAT
INC(l);
IF s[l] = ch THEN RETURN(l) END;
UNTIL l = Strings.Length(s);
RETURN(0);
END Lpos;

PROCEDURE ExtractWord* (n : INTEGER; s : string; ch : CHAR) : pstring;
VAR i,j, k, l : INTEGER;
str : string;
pstr : pstring;
BEGIN
RemoveLeftChars (s, ch);
RemoveRightChars (s, ch);
IF n = WordCount (s, ch) THEN
l := Rpos (s, ch);
Strings.Extract (s, l+1, Strings.Length(s)-l, str);
NEW(pstr);
pstr^ := str;
RETURN (pstr);
END;

IF n = 1 THEN
l := Lpos(s, ch);
Strings.Extract (s, 0, l, str);
NEW(pstr);
pstr^ := str;
RETURN (pstr);
END;

j := 0;
k := 0;
l := 0;
i := 0;

REPEAT
  IF s[i] = ch THEN INC(j) ;
            IF j = (n-1) THEN k := i  END;
         
           IF j = n THEN l := i END;
  END;
  INC(i);
UNTIL i = Strings.Length(s);

NEW (pstr);
Strings.Extract(s, k+1, l-k-1, str);
pstr^ := str;
RETURN (pstr);



END ExtractWord;

PROCEDURE tokenize*(s : string; ch : CHAR) : strings;
VAR strs : strings;
pstr : pstring;
l, n : INTEGER;
BEGIN
n := WordCount(s, ch);
NEW (strs, n);
IF n = 1 THEN
RemoveRightChars (s, ch);
RemoveLeftChars (s, ch);
strs^[0] := s;
RETURN (strs);
END;
l := 0;
REPEAT
pstr := ExtractWord ( l+1, s, ch);
strs^[l] := pstr^;
INC(l);
UNTIL l = n;
RETURN (strs); 
END tokenize;

PROCEDURE Assign* (VAR src : ARRAY OF CHAR ; VAR dst : ARRAY OF CHAR); 
VAR i, k : LONGINT;
BEGIN
IF LEN (src) < LEN(dst) THEN k := LEN(src) ELSE k := LEN(dst)  END;
FOR i := 0 TO k-2 DO
dst[i] := src[i];
END;
dst[k-1] := 0X;
END Assign;


BEGIN


END strutils.
