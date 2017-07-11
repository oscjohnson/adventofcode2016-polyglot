           IDENTIFICATION DIVISION.
           PROGRAM-ID. MAIN.

           DATA DIVISION.
              WORKING-STORAGE SECTION.
              01 WS-TIMES PIC 9(2) VALUE 1.
              01 WS-ROW PIC 9(2) VALUE 1.
              01 WS-COLUMN PIC 9(2) VALUE 2.
              01 RECT-WITDTH PIC 9(2) VALUE 3.
              01 RECT-HEIGHT PIC 9(2) VALUE 2.
              01 WS-TEMP.
                 05 WS-C1 OCCURS 7 TIMES.
                 10 WS-D1 PIC X(1) VALUE '.'.
              01 WS-TABLE.
                 05 WS-A OCCURS 3 TIMES INDEXED BY I.
                 10 WS-C OCCURS 7 TIMES INDEXED BY J.
                    15 WS-D PIC X(1) VALUE '.'.

           PROCEDURE DIVISION.
              CALL 'CREATE-RECT' USING WS-TABLE, RECT-WITDTH,
              RECT-HEIGHT.
              CALL 'PRINT-TABLE' USING WS-TABLE.

              MOVE 2 TO WS-COLUMN
              MOVE 1 TO WS-TIMES
              CALL 'MOVE-COLUMN' USING WS-TABLE, WS-COLUMN, WS-TIMES.

              MOVE 1 TO WS-ROW
              MOVE 4 TO WS-TIMES
              CALL 'MOVE-ROW' USING WS-TABLE, WS-ROW, WS-TIMES.

              MOVE 2 TO WS-COLUMN
              MOVE 1 TO WS-TIMES
              CALL 'MOVE-COLUMN' USING WS-TABLE, WS-COLUMN, WS-TIMES.

              CALL 'PRINT-TABLE' USING WS-TABLE.

           STOP RUN.

             *> 0 index to 1 index compensation
