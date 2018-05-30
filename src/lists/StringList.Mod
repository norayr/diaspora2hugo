MODULE StringList;
(* Oberon implementation without methods *)
IMPORT S := Sys, List, strutils;

TYPE 

      TObject* = S.TObject;
  TObjectDesc* = S.TObjectDesc;
       string* = S.string;
      integer* = S.integer;
   
  TString* = POINTER TO TStringDesc;
  
  TStringDesc =RECORD (S.TObjectDesc)
      str* : string
  END;
   
     Node* = List.Node;
 NodeDesc* = List.NodeDesc;

      TList* = List.TList;

      TStringList* = POINTER TO TStringListDesc;

      TStringListDesc* = RECORD (List.TListDesc)
	 IndexOf* : PROCEDURE (VAR l : TStringList; s : string) : integer;
       AddString* : PROCEDURE (l : TStringList; s : string) : integer;
    AppendString* : PROCEDURE (l : TStringList; s : string);
      END;

 PROCEDURE IndexOf*(VAR l : TStringList; s : string): integer;
 VAR i : integer;
     found : BOOLEAN;
     e : Node;
 BEGIN
    found := FALSE;
    NEW(e);
    e := l.First;
    i := 0;
    
    REPEAT

          IF strutils.Compare (s, e.obj(TString).str) = strutils.equal THEN
              found := TRUE;	  
          ELSE
             e := e.next;       
             INC(i);
          END;

    UNTIL found OR (i = l.Count);
    IF found THEN
       RETURN i
    ELSE
       RETURN -1
    END
 END IndexOf;

 PROCEDURE AddString* (l : TStringList; s : string) : integer;
    VAR str : TString;
    i : integer;
 BEGIN
    NEW(str);
    COPY (s, str^.str); (*str^.str := s;*)
    i := l.Add (l, str);
    RETURN i
 END AddString;
 
 PROCEDURE AppendString*(l : TStringList; s : string);
    VAR str : TString;
 BEGIN
    NEW(str);
    COPY (s, str^.str); (*str^.str := s;*)
    l.Append (l, str);
 END AppendString;

 PROCEDURE Create* () : TStringList;
    VAR l : TStringList;
 BEGIN
    NEW(l);
    l.First   := NIL;
    l.Last    := NIL;
    l.Count   := 0;
    l.Add     := List.Add;
    l.Append  := List.Append;
    l.Clear   := List.Clear;
    l.Free    := List.Free;
    l.Insert  := List.Insert;
    l.Delete  := List.Delete;
    l.Empty   := List.Empty;
    l.Get     := List.Get;
    l.res     := TRUE;
  l.AddString := AddString;
l.AppendString:= AppendString;
    l.IndexOf := IndexOf;
    RETURN(l);
 END Create;

(* PROCEDURE Delete* (VAR l : StringList; VAR e : Str);
 BEGIN
    e := l.First;
    l.First := l.First.next;
    IF l.First = NIL THEN l.Last := NIL END;
 END Delete;
*)
 
END StringList.
