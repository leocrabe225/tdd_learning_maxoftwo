       IDENTIFICATION DIVISION.
       PROGRAM-ID. chckrslt.
       DATA DIVISION.
       LINKAGE SECTION.
       01 LK-TEST-ID      PIC  9(03).
       01 LK-EXPECTED     PIC S9(06).
       01 LK-ACTUAL       PIC S9(06).
       01 LK-NUM-1        PIC S9(06).
       01 LK-NUM-2        PIC S9(06).

       PROCEDURE DIVISION USING LK-TEST-ID,
                                LK-NUM-1,
                                LK-NUM-2,
                                LK-EXPECTED,
                                LK-ACTUAL.
           IF LK-ACTUAL EQUAL LK-EXPECTED
               DISPLAY "✔ PASS: "
                       "Test #" LK-TEST-ID
                       " [" LK-NUM-1 "," LK-NUM-2 "]"
           ELSE
               DISPLAY "✘ FAIL: "
                       "Test #" LK-TEST-ID
                       " [" LK-NUM-1 "," LK-NUM-2 "]" 
                       " (Expected: " LK-EXPECTED
                       ", Got: " LK-ACTUAL ")"
           END-IF.
           EXIT PROGRAM.
           