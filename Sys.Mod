MODULE Sys;

CONST StrLen = 255;

TYPE  string* = ARRAY StrLen OF CHAR;
     strings* = POINTER TO ARRAY OF string;
     pstring* = POINTER TO string;
    pstrings* = POINTER TO ARRAY OF pstring;
     integer* = LONGINT(*INTEGER*);

     TObject* = POINTER TO TObjectDesc;
     TObjectDesc* = RECORD
     END;

END Sys.

