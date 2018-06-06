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
  strs.Delete(strs, 0);
  strs.Delete(strs, 0);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  RETURN(strs);
END getListOfPosts;

PROCEDURE getText*(postid: ARRAY OF CHAR): StringList.TStringList;
VAR
  cmd: ARRAY 256 OF CHAR;
  strs: StringList.TStringList;
BEGIN
  cmd := "SELECT text from posts WHERE id='";
  Strings.Append(postid, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
  strs := postgres.query(cmd);
  strs.Delete(strs, 0);
  strs.Delete(strs, 0);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  RETURN(strs);
END getText;

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
