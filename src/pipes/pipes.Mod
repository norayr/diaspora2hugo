MODULE pipes;

  IMPORT SYSTEM, Platform;

  CONST
    EOF* = -1;
	
  VAR
    SeekSet, SeekCur, SeekEnd, result : INTEGER;

PROCEDURE -Astdio '#include <stdio.h>';

PROCEDURE -popen (command, modes : ARRAY OF CHAR) : LONGINT "popen((char*)command, (char*)modes)";

PROCEDURE Popen*(VAR command, modes: ARRAY OF CHAR): Platform.FileHandle;
  VAR
    f : Platform.FileHandle;
BEGIN
  f := popen(command, modes);
  RETURN f;
END Popen;

(*PROCEDURE pclose* (stream : LONGINT) : LONGINT "close(fd)";*)

PROCEDURE Pclose* (stream: Platform.FileHandle);
BEGIN
  result := Platform.Close(stream)
END Pclose;


BEGIN
	SeekSet := Platform.SeekSet;
  	SeekCur := Platform.SeekCur;
	SeekEnd := Platform.SeekEnd;


END pipes.
