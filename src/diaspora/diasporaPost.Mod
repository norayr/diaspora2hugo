MODULE diasporaPost;

IMPORT (*Out,*)
       Strings,
       StringList;

VAR tmp: ARRAY 32 OF CHAR;

(*PROCEDURE dump(VAR str: ARRAY OF CHAR);
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
*)
PROCEDURE findTagsInString*(VAR stringToSearch: ARRAY OF CHAR): StringList.TStringList; 
VAR
    tag: ARRAY 256 OF CHAR;
    found, found2, EOL: BOOLEAN;
    posOfPattern, posOfPattern2: INTEGER;
    i, j: INTEGER;
    l: LONGINT;
    tags : StringList.TStringList;
BEGIN
  tags := StringList.Create();
  i := 0;
  REPEAT
    found := FALSE; EOL := FALSE;
      REPEAT
      IF stringToSearch[i] = "#" THEN 
        found := TRUE
      END;
      IF (ORD(stringToSearch[i]) < 32) THEN
        EOL := TRUE
      END; 
      INC(i)
      UNTIL found OR EOL;

      IF found THEN
        found2 := FALSE; EOL := FALSE;
        j := i;
        REPEAT
          IF (ORD(stringToSearch[j]) >= 32) & (ORD(stringToSearch[j]) <= 47)
           & (ORD(stringToSearch[j]) # 45) OR 
           ((ORD(stringToSearch[j]) = 213) & (ORD(stringToSearch[j+1]) = 157)) OR (* բութ՝             ՝  - d5 9d    *)
           ((ORD(stringToSearch[j]) = 214) & (ORD(stringToSearch[j+1]) = 137)) OR (* հայերէն վերջակէտ՝ ։  - d6 89    *)
           ((ORD(stringToSearch[j]) = 226) & (ORD(stringToSearch[j+1]) = 128) & (ORD(stringToSearch[j+2]) = 164)) OR (* միջակէտ՝          ․  - e2 80 a4 *)
           (ORD(stringToSearch[j]) = 58 ) OR (* երկու կէտ՝        :  - 3a       *)
           (ORD(stringToSearch[j]) = 59 ) OR (* կէտ ստորակէտ՝     ;  - 3b       *)
           (ORD(stringToSearch[j]) >= 58) & (ORD(stringToSearch[j]) <= 64) THEN
            found2 := TRUE
          END;
          IF (ORD(stringToSearch[j]) < 32) THEN
            EOL := TRUE;
          END;
          INC(j)
        UNTIL found2 OR EOL;

        IF found2 OR (found & EOL) THEN
          Strings.Extract(stringToSearch, i, j - i - 1, tag);
          l := tags.AddString(tags, tag);
        END
      END;
    INC(i)
  UNTIL EOL;
  RETURN tags
END findTagsInString;

PROCEDURE findTags*(VAR text: StringList.TStringList): StringList.TStringList;
VAR
  e : StringList.Node;
  i : INTEGER;
  L : StringList.TList;
  tags, tags0 : StringList.TStringList;
BEGIN
  tags := StringList.Create();
  NEW(e);
  i := 0;
  NEW(L);
  L := text;
  REPEAT
    e := text.Get(L, i);
    IF e # NIL THEN
      tags0 := findTagsInString(e.obj(StringList.TString).str);
      tags.AppendList(tags0, tags);
    END;
    INC(i);
  UNTIL i = text.Count;
  RETURN tags
END findTags;

BEGIN
  tmp := "aaa #aoa #bob bbb #eoe eee";

  (*findTags(tmp);*)

END diasporaPost.
