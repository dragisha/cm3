(* Copyright 1994 Digital Equipment Corporation. *)
(* Distributed only by permission. *)
(* Created on Sat Jan 11 15:49:00 PST 1992 by wobber *)
(* $Id: SupTCPHack.m3,v 1.1.1.1 2009-04-09 17:02:04 jkrell Exp $ *)

UNSAFE MODULE SupTCPHack;

IMPORT Uin, Usocket;

CONST TCP_NODELAY = 1;

PROCEDURE RefetchError(fd: INTEGER): BOOLEAN =
  VAR optbuf: INTEGER := 0;   optlen := BYTESIZE(optbuf);
  BEGIN
    RETURN Usocket.getsockopt(fd, Uin.IPPROTO_TCP, TCP_NODELAY,
                              ADR(optbuf), ADR(optlen)) >= 0;
  END RefetchError;

BEGIN
END SupTCPHack.
