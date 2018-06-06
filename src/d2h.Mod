MODULE d2h;
IMPORT Out, Args,
       postgres;



PROCEDURE getUserID(VAR userID: ARRAY OF CHAR);
VAR
  cmd: ARRAY 64 OF CHAR;
BEGIN
  cmd := "SELECT id FROM users WHERE username='norayr';"; 
END getUserID;

PROCEDURE main;
 VAR userID: ARRAY 5 OF CHAR;
BEGIN
  getUserID(userID);

END main;

BEGIN
  main;
END d2h.
