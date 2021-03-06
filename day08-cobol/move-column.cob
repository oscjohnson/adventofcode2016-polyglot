       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOVE-COLUMN.

       DATA DIVISION.
          WORKING-STORAGE SECTION.
          01 WS-WHAT PIC 9 VALUE 0.
          01 WS-INDEX PIC 9(2) VALUE 0.
          01 WS-HELP PIC 9(2) VALUE 0.
          01 WS-TEMP.
             05 WS-C1 OCCURS 6 TIMES.
             10 WS-D1 PIC X(1) VALUE '.'.
          01 COUNTER PIC 9(2) VALUE 1.
          LINKAGE SECTION.
          01 WS-TIMES PIC 9(2) VALUE 1.
          01 WS-COLUMN PIC 9(2) VALUE 1.
          01 WS-TABLE.
             05 WS-A OCCURS 6 TIMES INDEXED BY I.
             10 WS-C OCCURS 50 TIMES.
                15 WS-D PIC X(1) VALUE '.'.

       PROCEDURE DIVISION USING WS-TABLE, WS-COLUMN, WS-TIMES.
          PERFORM VARYING WS-WHAT FROM 1 BY 1 UNTIL WS-WHAT>WS-TIMES
             PERFORM 6 TIMES
               MOVE WS-C(COUNTER, WS-COLUMN) TO WS-C1(COUNTER)
               ADD 1 TO COUNTER
              END-PERFORM

            PERFORM VARYING WS-INDEX FROM 1 BY 1 UNTIL WS-INDEX>6
               IF WS-INDEX = 6
                  MOVE WS-C1(6) TO WS-C(1, WS-COLUMN)
               ELSE
                  SET WS-HELP TO WS-INDEX
                  ADD 1 to WS-HELP
                  MOVE WS-C1(WS-INDEX) TO WS-C(WS-HELP, WS-COLUMN)
               END-IF
            END-PERFORM

             MOVE 1 TO COUNTER
          END-PERFORM
          
          EXIT PROGRAM.
