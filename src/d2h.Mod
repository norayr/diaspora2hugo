MODULE d2h;
IMPORT Out, Args, Strings,
       StringList,
       postgres;

PROCEDURE list(VAR s : StringList.TStringList);
VAR e : StringList.Node;
       i : INTEGER;
    L : StringList.TList;   
BEGIN
   NEW(e);
   i := 0;
   NEW(L);
   L := s;
   REPEAT
      e := s.Get(L, i);
      IF e # NIL THEN Out.String (e.obj(StringList.TString).str); Out.Ln END;
      (*Out.String (e.string); Out.Ln;*)
      INC(i);
   UNTIL i = s.Count;
END list;

PROCEDURE help;
BEGIN
  Out.String("usage:"); Out.Ln;
  Out.String("./d2h username"); Out.Ln;
  Out.Ln;
END help;

PROCEDURE parseArgs(VAR u: ARRAY OF CHAR);
BEGIN
 IF Args.argc > 1 THEN
   Args.Get(1, u)
 ELSE
   help;
   HALT(1)
 END
END parseArgs;

PROCEDURE getRaw(VAR username, userID: ARRAY OF CHAR);
VAR
  cmd: ARRAY 64 OF CHAR;
  strs: StringList.TStringList;
BEGIN
  cmd := "SELECT id FROM users WHERE username='";
  Strings.Append(username, cmd);
  Strings.Append("';", cmd); 
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
  list(strs);
END getRaw;

PROCEDURE getUserID(VAR username, userID: ARRAY OF CHAR);
VAR
  cmd: ARRAY 64 OF CHAR;
  rsp : ARRAY 32 OF CHAR;
BEGIN
  cmd := "SELECT id FROM users WHERE username='";
  Strings.Append(username, cmd);
  Strings.Append("';", cmd); 
  Out.String(cmd); Out.Ln;
  postgres.queryL(cmd, rsp);
END getUserID;


PROCEDURE main;
 VAR userID: ARRAY 5 OF CHAR;
 username: ARRAY 16 OF CHAR;
BEGIN
  parseArgs(username);
  postgres.setUser("diaspora");
  postgres.setDatabase("diaspora_production");
  getUserID(username, userID);

END main;

BEGIN
  main;
END d2h.
