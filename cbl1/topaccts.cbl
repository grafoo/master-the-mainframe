       IDENTIFICATION DIVISION.
       PROGRAM-ID. TOPACCTS.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CUSTRECS-FILE ASSIGN TO CUSTRECS.
           SELECT TOPACCTS-FILE ASSIGN TO TOPACCTS.

       DATA DIVISION.
       FILE SECTION.
       FD  TOPACCTS-FILE
           RECORDING MODE F.
       01  TOPACCTS-REPORT-LINE PIC X(80).

       FD  CUSTRECS-FILE RECORD CONTAINS 80 CHARACTERS RECORDING MODE F.
       01  CUSTREC.
           05 FNAME PIC X(11).
           05 LNAME PIC X(22).
           05 FDATE PIC X(8).
           05       PIC X(3).
           05 LDATE PIC X(8).
           05       PIC X(9).
           05 BALANCE PIC X(12).

       WORKING-STORAGE SECTION.
       01  TOPACCT-TABLE.
           05 TOPACCT
              OCCURS 20 TIMES
              INDEXED BY I.
              10 FNAME PIC X(11).
              10 LNAME PIC X(22).
              10 BALANCE PIC X(12).

       01  EOF PIC 9 VALUE 0.

       01  TOPACCT-NUM PIC 9(2) VALUE 0.

       01  TOPACCT-BALANCE-TMP PIC 9,999,999V99.
       01  TOPACCT-BALANCE-CMP PIC 9,999,999V99.

       01  DATE-TODAY-HEADER.
           05 TODAY-YEAR PIC 9(4).
           05 TODAY-MONTH PIC 9(2).
           05 TODAY-DAY PIC 9(2).
           05 TODAY-TRAILER PIC 9(8)X9(4).

       PROCEDURE DIVISION.
       MAINLINE.
           COMPUTE TOPACCT-BALANCE-CMP =
              FUNCTION NUMVAL-C("8,500,000.00")
           PERFORM OPEN-FILES
           PERFORM WRITE-REPORT-HEADERS
           PERFORM READ-CUSTOMER-RECS
           PERFORM WRITE-REPORT-NUM-CUST-RECS
           PERFORM WRITE-REPORT-TOPACCTS
           PERFORM CLOSE-FILES
           STOP RUN
           .

       WRITE-REPORT-TOPACCTS.
           PERFORM WRITE-REPORT-TOPACCT
           VARYING I FROM 1 BY 1 UNTIL I > TOPACCT-NUM
           .

       WRITE-REPORT-TOPACCT.
           STRING
              FNAME IN TOPACCT(I) DELIMITED BY SIZE
              " " DELIMITED BY SIZE
              LNAME IN TOPACCT(I) DELIMITED BY SIZE
              " " DELIMITED BY SIZE
              BALANCE IN TOPACCT(I) DELIMITED BY SIZE
              INTO TOPACCTS-REPORT-LINE
           WRITE TOPACCTS-REPORT-LINE
           .

       WRITE-REPORT-HEADERS.
           MOVE "REPORT OF TOP ACCOUNT BALANCE HOLDERS"
              TO TOPACCTS-REPORT-LINE
           WRITE TOPACCTS-REPORT-LINE

           MOVE FUNCTION CURRENT-DATE TO DATE-TODAY-HEADER
           STRING
              "PREPARED FOR PAT STANARD ON" DELIMITED BY SIZE
              " " DELIMITED BY SIZE
              TODAY-MONTH DELIMITED BY SIZE
              "." DELIMITED BY SIZE
              TODAY-DAY DELIMITED BY SIZE
              "." DELIMITED BY SIZE
              TODAY-YEAR DELIMITED BY SIZE
              INTO TOPACCTS-REPORT-LINE
           WRITE TOPACCTS-REPORT-LINE
           .

       WRITE-REPORT-NUM-CUST-RECS.
           STRING
              "# OF RECORDS: " DELIMITED BY SIZE
              TOPACCT-NUM DELIMITED BY SIZE
              INTO TOPACCTS-REPORT-LINE
           WRITE TOPACCTS-REPORT-LINE

           MOVE "==============================================="
              TO TOPACCTS-REPORT-LINE
           WRITE TOPACCTS-REPORT-LINE
           .

       OPEN-FILES.
           OPEN INPUT CUSTRECS-FILE
           OPEN OUTPUT TOPACCTS-FILE
           .

       READ-CUSTOMER-RECS.
           PERFORM UNTIL EOF = 1
           PERFORM READ-REC
           PERFORM REPORT-TOPACCT
           END-PERFORM
           .

       REPORT-TOPACCT.
           COMPUTE TOPACCT-BALANCE-TMP =
              FUNCTION NUMVAL-C (BALANCE IN CUSTREC)
           IF TOPACCT-BALANCE-TMP > TOPACCT-BALANCE-CMP
              ADD 1 TO TOPACCT-NUM
              MOVE FNAME IN CUSTREC TO FNAME IN TOPACCT(TOPACCT-NUM)
              MOVE LNAME IN CUSTREC TO LNAME IN TOPACCT(TOPACCT-NUM)
              MOVE BALANCE IN CUSTREC
                 TO BALANCE IN TOPACCT(TOPACCT-NUM)
           END-IF
           .

       READ-REC.
           READ CUSTRECS-FILE AT END MOVE 1 TO EOF
           .

       CLOSE-FILES.
           CLOSE TOPACCTS-FILE
           CLOSE CUSTRECS-FILE
           .
