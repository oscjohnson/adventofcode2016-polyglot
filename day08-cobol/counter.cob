 IDENTIFICATION DIVISION.
 PROGRAM-ID. COUNTER.

 DATA DIVISION.
    WORKING-STORAGE SECTION.
    01 WS-I PIC 9(2) VALUE 0.
    01 WS-J PIC 9(2) VALUE 0.
    LINKAGE SECTION.
    01 WS-COUNTER PIC 9(3) VALUE 0.
    01 WS-TABLE.
       05 WS-A OCCURS 6 TIMES INDEXED BY I.
       10 WS-C OCCURS 50 TIMES.
          15 WS-D PIC X(1) VALUE '.'.

 PROCEDURE DIVISION USING WS-TABLE, WS-COUNTER.
    PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I>6
      PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J>50
        IF WS-C(WS-I,WS-J) = '#'
          ADD 1 TO WS-COUNTER
        END-IF
      END-PERFORM
    END-PERFORM
    
  EXIT PROGRAM.
