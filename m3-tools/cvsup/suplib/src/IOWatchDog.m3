(* Copyright 1996-2003 John D. Polstra.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgment:
 *      This product includes software developed by John D. Polstra.
 * 4. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * $Id: IOWatchDog.m3,v 1.1.1.1 2009-04-09 17:01:55 jkrell Exp $ *)

MODULE IOWatchDog;

IMPORT
  Rd, RdClass, RefList, Thread, Time, Wr, WrClass;

REVEAL
  Private = Thread.Closure BRANDED OBJECT END;

  T = Public BRANDED OBJECT
    thread: Thread.T;
    creator: Thread.T;
    mu: MUTEX;
    pollInterval: Time.T;
    expired: BOOLEAN;
    canceled: BOOLEAN;
    pollLimit: CARDINAL;
    pollCount: CARDINAL := 0;
    targets: RefList.T := NIL;
  OVERRIDES
    apply := Apply;
    alert := Alert;
    init := Init;
  END;

TYPE
  Target = OBJECT
    rdwr: REFANY;
    lastIndex: CARDINAL;
  END;

(* Note: To check for progress on a reader or a writer, we have to examine
   its fields directly, and we cannot lock it.  If a reader is blocked in
   a read operation, it is already locked.  If we try to lock it, we will
   block too, defeating the purpose of the watch dog timer.

   It doesn't really matter that we don't lock the readers and writers.
   The kinds of things that can go wrong don't make any difference to us. *)

PROCEDURE AddRd(wd: T;
                rd: Rd.T) =
  VAR
    target := NEW(Target, rdwr := rd);
  BEGIN
    IF rd.closed THEN RETURN END;
    target.lastIndex := rd.cur;

    LOCK wd.mu DO
      wd.targets := RefList.Cons(target, wd.targets);
    END;
  END AddRd;

PROCEDURE AddWr(wd: T;
                wr: Wr.T) =
  VAR
    target := NEW(Target, rdwr := wr);
  BEGIN
    IF wr.closed THEN RETURN END;
    target.lastIndex := wr.cur;

    LOCK wd.mu DO
      wd.targets := RefList.Cons(target, wd.targets);
    END;
  END AddWr;

PROCEDURE Alert(self: T) =
  BEGIN
    Thread.Alert(self.creator);
  END Alert;

PROCEDURE Apply(self: T): REFANY =
  VAR
    cur, prev: RefList.T;
    target: Target;
    closed: BOOLEAN;
    index: CARDINAL;
    madeProgress: BOOLEAN;
  BEGIN
    LOOP
      TRY Thread.AlertPause(self.pollInterval) EXCEPT Thread.Alerted => END;
      madeProgress := FALSE;
      prev := NIL;
      LOCK self.mu DO
	IF self.canceled THEN
	  RETURN NIL;
	END;
	cur := self.targets;
	WHILE cur # NIL DO
	  closed := FALSE;
	  target := cur.head;
	  TYPECASE target.rdwr OF
	  | Rd.T(rd) =>
	      IF rd.closed THEN closed := TRUE ELSE index := rd.cur END;
	  | Wr.T(wr) =>
	      IF wr.closed THEN closed := TRUE ELSE index := wr.cur END;
	  ELSE
	    <* ASSERT FALSE *>
	  END;
	  IF closed THEN  (* Remove it from the list. *)
	    IF prev # NIL THEN
	      prev.tail := cur.tail;
	    ELSE
	      self.targets := cur.tail;
	    END;
	  ELSE
	    IF index # target.lastIndex THEN
	      madeProgress := TRUE;
	      target.lastIndex := index;
	    END;
	    prev := cur;
	  END;
	  cur := cur.tail;
	END;
	IF madeProgress THEN
	  self.pollCount := 0;
	ELSE
	  INC(self.pollCount);
	  IF self.pollCount >= self.pollLimit THEN
	    self.expired := TRUE;
	    EXIT;
	  END;
	END;
      END;
    END;
    self.alert();
    RETURN NIL;
  END Apply;

PROCEDURE Cancel(wd: T) =
  BEGIN
    LOCK wd.mu DO
      wd.canceled := TRUE;
    END;
    Thread.Alert(wd.thread);
  END Cancel;

PROCEDURE Expired(wd: T): BOOLEAN =
  BEGIN
    LOCK wd.mu DO
      RETURN wd.expired;
    END;
  END Expired;

PROCEDURE Init(self: T;
               timeout: Time.T;
	       pollInterval: Time.T := 60.0d0): T =
  BEGIN
    self.mu := NEW(MUTEX);
    self.pollInterval := pollInterval;
    self.pollLimit := CEILING(timeout / pollInterval);
    self.creator := Thread.Self();
    self.expired := FALSE;
    self.canceled := FALSE;
    LOCK self.mu DO
      self.thread := Thread.Fork(self);
    END;
    RETURN self;
  END Init;

BEGIN
END IOWatchDog.
