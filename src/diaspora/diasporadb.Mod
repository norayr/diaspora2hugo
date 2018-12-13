MODULE diasporadb;

IMPORT postgres, StringList, Strings := oocStrings, strutils, Out;

PROCEDURE dump(VAR str: ARRAY OF CHAR);
VAR
  i, l : INTEGER;
BEGIN
  i := 0;
  l := Strings.Length(str);
  REPEAT
    Out.Char(str[i]); Out.Int(i, 5); Out.Ln;
    INC(i)
  UNTIL i = l;
END dump;

PROCEDURE clean(VAR strs: StringList.TStringList);
VAR
  e : StringList.Node;
  L : StringList.TList;
  i, l : INTEGER;
BEGIN
  NEW(e); NEW(L);
  L := strs;
  REPEAT
    e := strs.Get(L, i);
    IF e # NIL THEN
      l := Strings.Length(e.obj(StringList.TString).str) - 1;
      IF e.obj(StringList.TString).str[l] = '+' THEN
        Strings.Delete(e.obj(StringList.TString).str, l, 1);
        strutils.RemoveRightChars(e.obj(StringList.TString).str, ' ');
        l := Strings.Length(e.obj(StringList.TString).str) - 1 ;
        IF (e.obj(StringList.TString).str[l-1] = '\') & (e.obj(StringList.TString).str[l] = 'r') THEN
          Strings.Delete(e.obj(StringList.TString).str, l-1, 2);
        END;
      END; (* clean *)
    END;
    INC(i)
  UNTIL i = strs.Count;
END clean;

PROCEDURE getListOfPosts*(VAR userid: ARRAY OF CHAR; public : BOOLEAN): StringList.TStringList;
VAR
  cmd: ARRAY 128 OF CHAR;
  strs: StringList.TStringList;
BEGIN
  cmd := "SELECT id from posts WHERE author_id='";
  Strings.Append(userid, cmd);
  IF public THEN
    Strings.Append("' AND type='StatusMessage' AND public='t';", cmd)
  ELSE
    Strings.Append("' AND type='StatusMessage' AND public='f';", cmd)
  END;
  Out.String(cmd); Out.Ln;
  strs := postgres.query(cmd);
  strs.Delete(strs, 0);
  strs.Delete(strs, 0);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  strs.Delete(strs, strs.Count-1);
  RETURN(strs);
END getListOfPosts;

PROCEDURE getListOfPrivatePosts*(VAR userid: ARRAY OF CHAR): StringList.TStringList;
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
END getListOfPrivatePosts;


PROCEDURE getCreationTime*(postid: ARRAY OF CHAR; VAR time: ARRAY OF CHAR);
VAR
  cmd: ARRAY 256 OF CHAR;
  strs: StringList.TStringList;
  e: StringList.Node;
  p: INTEGER;
BEGIN
  cmd := "SELECT created_at from posts WHERE id='";
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
  e := strs.Get(strs, strs.Count-1);
  Strings.Assign(e.obj(StringList.TString).str, time);
  (* now check if the line contains dot, then cut everything from right till the dot included *)
  p := strutils.Pos('.', time, 0);
  IF p # 0 THEN
    Strings.Delete(time, p, Strings.Length(time)-p);
  END
END getCreationTime;

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
  clean(strs);
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

PROCEDURE getAuthorID*(VAR ownerid, authorid: ARRAY OF CHAR);
VAR
  cmd: ARRAY 64 OF CHAR;
BEGIN
  cmd := "SELECT id FROM people WHERE owner_id='";
  Strings.Append(ownerid, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  postgres.queryL(cmd, authorid);
END getAuthorID;

PROCEDURE getPostGuid*(VAR id, guid: ARRAY OF CHAR);
VAR
  cmd: ARRAY 64 OF CHAR;
BEGIN
  cmd := "SELECT guid FROM posts WHERE id='";
  Strings.Append(id, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  postgres.queryL(cmd, guid);
END getPostGuid;

PROCEDURE getPhotoPath*(VAR guid, photoPath: ARRAY OF CHAR);
VAR
  cmd: ARRAY 128 OF CHAR;
BEGIN
  cmd := "SELECT remote_photo_path FROM photos WHERE status_message_guid='";
  Strings.Append(guid, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  postgres.queryL(cmd, photoPath);
  IF photoPath[0] = '-' THEN Strings.Assign("", photoPath) END;
END getPhotoPath;

PROCEDURE getPhotoName*(VAR guid, photoName: ARRAY OF CHAR);
VAR
  cmd: ARRAY 128 OF CHAR;
BEGIN
  cmd := "SELECT remote_photo_name FROM photos WHERE status_message_guid='";
  Strings.Append(guid, cmd);
  Strings.Append("';", cmd);
  Out.String(cmd); Out.Ln;
  postgres.queryL(cmd, photoName);
  IF photoName[0] = '-' THEN Strings.Assign("", photoName) END;
END getPhotoName;

PROCEDURE getPhotoLinksByPostId*(pid: ARRAY OF CHAR; VAR full, scaled: ARRAY OF CHAR): BOOLEAN;
VAR
   statusMessageGuid : ARRAY 128 OF CHAR;
   photoPath : ARRAY 128 OF CHAR;
   photoName : ARRAY 64 OF CHAR;
   b : BOOLEAN;
BEGIN
   b := FALSE;
   getPostGuid(pid, statusMessageGuid);
   getPhotoPath(statusMessageGuid, photoPath);
   getPhotoName(statusMessageGuid, photoName);
   Strings.Assign(photoPath, full);
   Strings.Append(photoName, full);
   Strings.Assign(photoPath, scaled);
   IF photoPath # "" THEN
     Strings.Append("scaled_full_", scaled);
	 b := TRUE
   END;
   Strings.Append(photoName, scaled);
   RETURN b
END getPhotoLinksByPostId;

BEGIN
  postgres.setUser("diaspora");
  postgres.setDatabase("diaspora_production");


END diasporadb.
