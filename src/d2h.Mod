MODULE d2h;
IMPORT Out, Args, Strings,
       postgres;

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

PROCEDURE getUserID(VAR username, userID: ARRAY OF CHAR);
VAR
  cmd: ARRAY 64 OF CHAR;
BEGIN
  cmd := "SELECT id FROM users WHERE username='";
  Strings.Append(username, cmd);
  Strings.Append("';", cmd); 
  Out.String(cmd); Out.Ln;
  postgres.query(cmd);
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
