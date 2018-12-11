MODULE pipes;

  IMPORT SYSTEM, Platform, Strings := oocStrings, Ascii := oocAscii, strutils, Out;

  CONST
    EOF* = -1;

  TYPE 
  File = SYSTEM.ADDRESS;
	Files = ARRAY 64 OF File; (* should be enough to hold FILE struct *)
	PtrFile = POINTER TO Files;
	Pchar = POINTER TO ARRAY OF CHAR;
   
  Text* = POINTER TO TextDesc;

  TextDesc* = RECORD;
     text- : PtrFile;
  	 eof-  : BOOLEAN;
   END;

PROCEDURE -Astdio '#include <stdio.h>';


PROCEDURE OberonStringtoPchar( VAR s : ARRAY OF CHAR) : Pchar;
VAR l, i : LONGINT;
p : Pchar;
BEGIN
   l := Strings.Length(s);
   INC(l);
   INC(l);
   NEW(p, l);
   i := 0;
   REPEAT
     p[i] := s[i];
     INC(i)
   UNTIL i = l-2;
   INC(i);
   p[i] := Ascii.nul; 
   RETURN p;
END OberonStringtoPchar;

PROCEDURE dumpChars(VAR s : ARRAY OF CHAR);
VAR
  i : INTEGER;
BEGIN
  i := 0;
  WHILE s[i] # Ascii.nul DO
    Out.Int(i, 0); Out.Char(" "); Out.Char(s[i]); Out.Ln; INC(i)
  END
END dumpChars;

PROCEDURE -popen (VAR command, modes : ARRAY OF CHAR) : PtrFile "popen((char*)command, (char*)modes)";

PROCEDURE Popen*(VAR t: Text; VAR command: ARRAY OF CHAR; mode: CHAR);
VAR
	cmd : ARRAY 256 OF CHAR;
	md  : ARRAY 2 OF CHAR;
BEGIN
  (*NEW(md, 2);
  md^[0] := mode; md^[1] := Ascii.nul;
  cmd := OberonStringtoPchar(command);*)
  strutils.Assign(command, cmd);
  strutils.Assign("r", md);
  (*dumpChars(md); dumpChars(cmd);*)
  t.text := popen(cmd, md);
  t.eof := FALSE;
END Popen;

(*PROCEDURE pclose* (stream : LONGINT) : LONGINT "close(fd)";*)

PROCEDURE Pclose* (stream: Platform.FileHandle): LONGINT;
VAR
  result: LONGINT;
BEGIN
  result := Platform.Close(stream)
END Pclose;

PROCEDURE -getc(f: PtrFile): LONGINT "getc(f)";

PROCEDURE Read*(VAR(*CONST*) f  : Text; VAR ch : CHAR);
VAR
  l, e : LONGINT;
  s : ARRAY 5 OF CHAR;
BEGIN
   l := getc(f.text);
   IF l < 0 THEN
     f.eof := TRUE
   ELSE
     ch := CHR((SHORT(SHORT(l))))
   END
END Read;

PROCEDURE ReadLine*(VAR(*CONST*) f : Text; VAR s : ARRAY OF CHAR);
VAR
  i: INTEGER;
	ch: CHAR;
	eol: BOOLEAN;
BEGIN
  eol := FALSE;
  i := 0;
  REPEAT
    Read(f, ch);
    IF (ch = Ascii.cr) OR (ch = Ascii.lf) OR (i = LEN(s) - 1) OR f.eof THEN eol := TRUE END;
    IF eol THEN
	    s[i] := Ascii.nul
	  ELSE
	    s[i] := ch
	  END;
	  INC(i)
  UNTIL eol;
END ReadLine;

PROCEDURE isEOF*(VAR(*CONST*) f: Text): BOOLEAN;
BEGIN
  RETURN f.eof;
END isEOF;


BEGIN


END pipes.
