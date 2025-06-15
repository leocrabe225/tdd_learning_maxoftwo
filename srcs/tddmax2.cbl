       IDENTIFICATION DIVISION.
       PROGRAM-ID. tddmax2.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT F-TEST-FILE ASSIGN TO "input/input.test"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-F-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD F-TEST-FILE.
       01 F-TEST-LINE.
           05 F-IN-A           PIC X(06).
           05 FILLER           PIC X(01).
           05 F-IN-B           PIC X(06).
           05 FILLER           PIC X(01).
           05 F-EXPECTED       PIC X(06).

       WORKING-STORAGE SECTION.
       01 WS-F-STATUS          PIC X(02).
           88 WS-F-STATUS-OK             VALUE "00".
           88 WS-F-STATUS-EOF            VALUE "10".

       01 WS-NUM-1             PIC S9(06).
       01 WS-NUM-2             PIC S9(06).
       01 WS-NUM-EXPECTED      PIC S9(06).
       01 WS-ACTUAL            PIC S9(06).
       01 WS-TEST-ID           PIC  9(03) VALUE 0.
       01 WS-TEST-NAME         PIC  X(40).

       PROCEDURE DIVISION.
           OPEN INPUT F-TEST-FILE
           PERFORM UNTIL WS-F-STATUS-EOF
               READ F-TEST-FILE
                   NOT AT END
                       MOVE F-IN-A TO WS-NUM-1
                       MOVE F-IN-B TO WS-NUM-2
                       MOVE F-EXPECTED TO WS-NUM-EXPECTED
                       ADD 1 TO WS-TEST-ID
                       CALL "maxoftwo"
                           USING 
                           WS-NUM-1
                           WS-NUM-2
                           WS-ACTUAL
                       END-CALL
                       CALL "chckrslt"
                           USING
                           WS-TEST-ID
                           WS-NUM-1
                           WS-NUM-2
                           WS-NUM-EXPECTED
                           WS-ACTUAL
                       END-CALL
               END-READ
           END-PERFORM
           CLOSE F-TEST-FILE
           STOP RUN.
