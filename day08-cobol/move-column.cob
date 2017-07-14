       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOVE-COLUMN.

       DATA DIVISION.
          WORKING-STORAGE SECTION.
          01 WS-WHAT PIC 9 VALUE 0.
          01 WS-TEMP.
             05 WS-C1 OCCURS 3 TIMES.
             10 WS-D1 PIC X(1) VALUE '.'.
          01 COUNTER PIC 9(2) VALUE 1.
          LINKAGE SECTION.
          01 WS-TIMES PIC 9(2) VALUE 1.
          01 WS-COLUMN PIC 9(2) VALUE 1.
          01 WS-TABLE.
             05 WS-A OCCURS 3 TIMES INDEXED BY I.
             10 WS-C OCCURS 7 TIMES.
                15 WS-D PIC X(1) VALUE '.'.

       PROCEDURE DIVISION USING WS-TABLE, WS-COLUMN, WS-TIMES.
          PERFORM VARYING WS-WHAT FROM 1 BY 1 UNTIL WS-WHAT>WS-TIMES
             PERFORM 3 TIMES
               MOVE WS-C(COUNTER, WS-COLUMN) TO WS-C1(COUNTER)

               ADD 1 TO COUNTER
             
              END-PERFORM
             MOVE WS-C1(1) TO WS-C(2,WS-COLUMN)
             MOVE WS-C1(2) TO WS-C(3,WS-COLUMN)
             MOVE WS-C1(3) TO WS-C(1,WS-COLUMN)

             MOVE 1 TO COUNTER
          END-PERFORM
          
          EXIT PROGRAM.
