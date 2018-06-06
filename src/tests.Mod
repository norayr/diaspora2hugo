MODULE tests;

IMPORT pipes, postgres, Out;

PROCEDURE test0;

BEGIN
  (*postgres.setUser("postgres");
  postgres.setDatabase("diaspora_production");
  postgres.constructQuery("SELECT id from posts WHERE author_id='1' AND type='StatusMessage' AND public='t';");
  postgres.constructQuery("SELECT id from users WHERE username='norayr'");*)
END test0;


PROCEDURE test1;
  VAR
    cmd, out: ARRAY 64 OF CHAR;
    f: pipes.Text;
    ch : CHAR;
BEGIN

  Out.String(postgres.queryStr); Out.Ln;

  cmd := "ls -al";
  NEW(f);
  pipes.Popen(f, cmd, 'r');
  REPEAT
    pipes.ReadLine(f, out);
    Out.String(out); Out.Ln;
    Out.Ln
  UNTIL f.eof;

  (*
  REPEAT
    pipes.Read(f, ch);
    Out.Char(ch); Out.Ln;
  UNTIL f.eof;
  *)
END test1;

PROCEDURE test2;
VAR s : ARRAY 16 OF CHAR;
BEGIN
  s := "aaa'bbb'ccc'ddd";
  Out.String(s); Out.Ln;
(*  postgres.screen(s);*)
  Out.String(s); Out.Ln
END test2;


BEGIN
  test0;
  test1;
  test2;
END tests.
