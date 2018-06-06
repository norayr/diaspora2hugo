MODULE diasporadb;

IMPORT postgres, StringList, Strings := oocStrings, Out;

PROCEDURE getListOfPosts*(VAR userid: ARRAY OF CHAR): StringList.TStringList;
VAR
  cmd: ARRAY 128 OF CHAR;
  strs: StringList.TStringList;
BEGIN
  cmd := "SELECT id from posts WHERE author_id='";
  Strings.Append(userid, cmd);
  Strings.Append("' AND type='StatusMessage' AND public='f';", cmd);
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
  RETURN(strs);
END getListOfPosts;

PROCEDURE getRaw*(VAR username, userID: ARRAY OF CHAR);
VAR
  cmd: ARRAY 64 OF CHAR;
  strs: StringList.TStringList;
BEGIN
  cmd := "SELECT id FROM users WHERE username='";
  Strings.Append(username, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
END getRaw;

PROCEDURE getUserID*(VAR username, userID: ARRAY OF CHAR);
VAR
  cmd: ARRAY 64 OF CHAR;
BEGIN
  cmd := "SELECT id FROM users WHERE username='";
  Strings.Append(username, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  postgres.queryL(cmd, userID);
END getUserID;



BEGIN
  postgres.setUser("diaspora");
  postgres.setDatabase("diaspora_production");


END diasporadb.
