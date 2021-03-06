 IDENTIFICATION DIVISION.
 PROGRAM-ID. MAIN.
  
  ENVIRONMENT DIVISION.
    INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       SELECT STUDENT ASSIGN TO 'input.txt'
       ORGANIZATION IS LINE SEQUENTIAL. 

 DATA DIVISION.
  FILE SECTION.
  FD STUDENT.
  01 STUDENT-FILE.
     05 STUDENT-ID PIC 9(5).
     05 NAME PIC A(25).

    WORKING-STORAGE SECTION.
    01 WS-LINE.
         05 WS-STUDENT-ID PIC 9(5).
         05 WS-NAME PIC A(25).
    01 WS-EOF PIC A(1).
    01 ACTION PIC X(10).
    01 DIRECTION PIC X(10).
    01 WS-STR3 PIC X(10).
    01 CELL PIC 9(2).
    01 CELL-STR PIC X(10).
    01 SCRAP PIC X(10).
    01 WS-STR-BY PIC X(10).
    01 WS-COUNTER PIC 9(3) VALUE 0.

    01 WS-TIMES PIC 9(2) VALUE 1.
    01 WS-ROW PIC 9(2) VALUE 1.
    01 WS-COLUMN PIC 9(2) VALUE 2.
    01 RECT-WIDTH PIC 9(2) VALUE 3.
    01 RECT-HEIGHT PIC 9(2) VALUE 2.
    01 WS-TABLE.
       05 WS-A OCCURS 6 TIMES INDEXED BY I.
       10 WS-C OCCURS 50 TIMES INDEXED BY J.
          15 WS-D PIC X(1) VALUE '.'.

 PROCEDURE DIVISION.
  OPEN INPUT STUDENT.
     PERFORM UNTIL WS-EOF='Y'
     READ STUDENT INTO WS-LINE
        AT END MOVE 'Y' TO WS-EOF
        NOT AT END
            UNSTRING WS-LINE DELIMITED BY SPACE
                INTO ACTION, DIRECTION, CELL-STR, WS-STR-BY, WS-TIMES
            END-UNSTRING
            IF ACTION = 'rect'
                UNSTRING DIRECTION DELIMITED BY 'x'
                    INTO RECT-WIDTH, RECT-HEIGHT
                END-UNSTRING
                CALL 'CREATE-RECT' USING WS-TABLE, RECT-WIDTH, RECT-HEIGHT
            ELSE
                UNSTRING CELL-STR DELIMITED BY '='
                  INTO SCRAP, CELL
                END-UNSTRING
                IF DIRECTION = 'column'
                    ADD 1 TO CELL
                    CALL 'MOVE-COLUMN' USING WS-TABLE, CELL, WS-TIMES
                ELSE
                    ADD 1 TO CELL
                    CALL 'MOVE-ROW' USING WS-TABLE, CELL, WS-TIMES
                END-IF
            END-IF
      *> DEBUG INFO
      *>      DISPLAY WS-LINE
      *>      CALL 'PRINT-TABLE' USING WS-TABLE
     END-READ
     END-PERFORM
     CLOSE STUDENT.
     CALL 'PRINT-TABLE' USING WS-TABLE.
     CALL 'COUNTER' USING WS-TABLE, WS-COUNTER.
     DISPLAY WS-COUNTER, ', RURUCEOEIL'
 STOP RUN.

   *> 0 index to 1 index compensation
