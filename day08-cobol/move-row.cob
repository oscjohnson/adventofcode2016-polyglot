IDENTIFICATION DIVISION.
PROGRAM-ID. MOVE-ROW.

DATA DIVISION.
   WORKING-STORAGE SECTION.
   01 WS-TEMP.
      05 WS-C1 OCCURS 7 TIMES.
         10 WS-D1 PIC X(1) VALUE '.'.
   LINKAGE SECTION.
   01 WS-TIMES PIC 9(2) VALUE 1.
   01 WS-ROW PIC 9(2) VALUE 1.
   01 WS-TABLE.
      05 WS-A OCCURS 3 TIMES INDEXED BY I.
         10 WS-C OCCURS 7 TIMES.
            15 WS-D PIC X(1) VALUE '.'.

PROCEDURE DIVISION USING WS-TABLE, WS-ROW, WS-TIMES.
   PERFORM 3 TIMES

      MOVE WS-A(WS-ROW) TO WS-TEMP

      MOVE WS-C1(1) TO WS-C(1,2)
      MOVE WS-C1(2) TO WS-C(1,3)
      MOVE WS-C1(3) TO WS-C(1,4)
      MOVE WS-C1(4) TO WS-C(1,5)
      MOVE WS-C1(5) TO WS-C(1,6)
      MOVE WS-C1(6) TO WS-C(1,7)
      MOVE WS-C1(7) TO WS-C(1,1)
   END-PERFORM.
EXIT PROGRAM.
