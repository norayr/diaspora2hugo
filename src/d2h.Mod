MODULE d2h;
IMPORT Out, Args, Strings := oocStrings,
       StringList,
       diasporadb,
	   diasporaPost,
     Files;

CONST
  title = "…";
  author = "նորայր_չիլինգարեան";
  defcat = "սփիւռք_գրառումներ";
  purl = "https://spyurk.am/posts/";

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
  Out.String("./d2h username [postid]"); Out.Ln;
  Out.Ln;
  Out.String("if optional postid argument given, then hugo files will be generated starting from that post."); Out.Ln;
  Out.Ln;
END help;

PROCEDURE parseArgs(VAR u, sposid: ARRAY OF CHAR);
BEGIN
 IF Args.argc > 1 THEN
   Args.Get(1, u);
   IF Args.argc > 2 THEN
   Args.Get(2, sposid)
   END
 ELSE
   help;
   HALT(1)
 END
END parseArgs;


PROCEDURE WriteChar(VAR r : Files.Rider; ch : CHAR);
BEGIN
   Files.Write(r, SHORT(ORD(ch))); (* write ascii character *)
   Out.Char(ch);
END WriteChar;

PROCEDURE WriteString(VAR r : Files.Rider; str : ARRAY OF CHAR);
BEGIN
   Files.WriteBytes(r, str, Strings.Length(str));
   Out.String(str);
END WriteString;

PROCEDURE main;
VAR
 userID, postID: ARRAY 8 OF CHAR;
 username, sposid: ARRAY 16 OF CHAR;
 postIDs, text, tags: StringList.TStringList;
 time: ARRAY 32 OF CHAR;
 url: ARRAY 16 OF CHAR;
 year, month, day: ARRAY 8 OF CHAR;
 guid, tag: ARRAY 128 OF CHAR;
 line: StringList.string;
 photoFull, photoScaled: ARRAY 128 OF CHAR;
 i : LONGINT; j : INTEGER;
 e, et : StringList.Node;
 L, Lt : StringList.TList;
 F : Files.File; R : Files.Rider;
 filename : ARRAY 128 OF CHAR;
 process: BOOLEAN;
BEGIN
  process := TRUE;
  Strings.Assign("", sposid);
  parseArgs(username, sposid);
  IF sposid # "" THEN process := FALSE END;
  diasporadb.getUserID(username, userID);
  postIDs := diasporadb.getListOfPosts(userID, TRUE);
  Out.String("postids count "); Out.Int(postIDs.Count, 0); Out.Ln;
  (*list(postIDs);*)
  NEW(e); NEW(L);
  L := postIDs;
  i := 0;
  REPEAT
    Out.Int(i, 0); Out.Ln;
	  e := postIDs.Get(L, i);
    IF e # NIL THEN
      Strings.Assign(e.obj(StringList.TString).str, postID);
      IF ~process & (postID = sposid) THEN process := TRUE END;
      IF ~process THEN
        Out.String("skipping post id "); Out.String(postID); Out.Ln;
      ELSE
        Out.String(postID); Out.Ln;
        diasporadb.getPostGuid(postID, guid);
        diasporadb.getCreationTime(postID, time);
        Strings.Append("+04:00", time);
        time[10] := 'T';
        Strings.Extract(time, 0, 4, year);
        Strings.Assign("/", url);
        Strings.Append(year, url);
        Strings.Append("/", url);
        Strings.Extract(time, 5, 2, month);
        Strings.Append(month, url);
        Strings.Append("/", url);
        Strings.Extract(time, 8, 2, day);
        Strings.Append(day, url);
        Strings.Append("/", url);
        Strings.Append(postID, url);
        Strings.Append("/", url);
        Out.String(time); Out.Ln;
        Out.String(url); Out.Ln;
        text := diasporadb.getText(postID);
        (* now generating the header *)
        Strings.Assign(year, filename);
        Strings.Append("-", filename);
        Strings.Append(month, filename);
        Strings.Append("-", filename);
        Strings.Append(day, filename);
        Strings.Append("_", filename);
        Strings.Append(postID, filename);
        Strings.Append("_spyurk.md", filename);
        F := Files.New(filename);
        IF F # NIL THEN
          Files.Set(R, F, 0);
          WriteString(R, "---"); WriteChar(R, 0AX);
          WriteString(R, "title: "); WriteString(R, title); WriteChar(R, 0AX);
          WriteString(R, "author: "); (*Files.WriteString(R, author);*) WriteString(R, author); WriteChar(R, 0AX);
          WriteString(R, "type: post");  WriteChar(R, 0AX);
          WriteString(R, "date: "); WriteString(R, time); WriteChar(R, 0AX);
          WriteString(R, "url: "); WriteString(R, url); WriteChar(R, 0AX);
          WriteString(R, "categories:"); WriteChar(R, 0AX);
          WriteString(R, "  - ");
          WriteString(R, defcat); WriteChar(R, 0AX);
          tags := diasporaPost.findTags(text);
          IF tags.Count > 0 THEN
            WriteString(R, "tags:"); WriteChar(R, 0AX);
            NEW(et); NEW(Lt);
            Lt := tags;
            j := 0;
            REPEAT
              et := tags.Get(Lt, j);
              IF et # NIL THEN
                Strings.Assign(et.obj(StringList.TString).str, tag);
                WriteString(R, "  - "); WriteString(R, tag); WriteChar(R, 0AX);
              END;
              INC(j);
            UNTIL j = tags.Count;
          END;
          WriteString(R, "---"); WriteChar(R, 0AX);

          IF diasporadb.getPhotoLinksByPostId(postID, photoFull, photoScaled) THEN
            Out.String(photoFull); Out.Ln;
            Out.String(photoScaled); Out.Ln;
            WriteString(R, '{{< figure link="');
            WriteString(R, photoFull);
            WriteString(R, '" src="');
            WriteString(R, photoScaled);
            WriteString(R, '" width="100%" >}}'); WriteChar(R, 0AX); WriteChar(R, 0AX);
          ELSE
            Out.String("post has no photo"); Out.Ln
          END;
         
          NEW(et); NEW(Lt);
          Lt := text;
          j := 0;
          REPEAT
            et := text.Get(Lt, j);
            IF et # NIL THEN
              Strings.Assign(et.obj(StringList.TString).str, line);
              WriteString(R, line); WriteChar(R, 0AX);
            END;
            INC(j);
          UNTIL j = text.Count;
          
          WriteChar(R, 0AX);
          WriteChar(R, 0AX);
          WriteChar(R, 0AX);
          WriteString(R, "-----------------------"); WriteChar(R, 0AX);
          WriteString(R, "[բնօրինակ սփիւռքում(եւ մեկնաբանութիւննե՞ր)](");
          WriteString(R, purl);
          WriteString(R, guid);
          WriteString(R, ")");
          WriteChar(R, 0AX);
        END;
        Files.Register(F);
        (*Files.Close(F);*)
      END; (* if process or not *)
    END;
    INC(i);
  UNTIL i = postIDs.Count;
END main;

BEGIN
  main;
END d2h.
