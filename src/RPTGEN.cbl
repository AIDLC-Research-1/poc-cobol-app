       IDENTIFICATION DIVISION.
       PROGRAM-ID. RPTGEN.
      ******************************************************************
      * Emits a simple text report line for a policy record
      ******************************************************************
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY POLICYREC.
       01  WS-REPORT-LINE  PIC X(60).

       PROCEDURE DIVISION.
       MAIN-PARA.
           MOVE "POL0000003"      TO WS-POLICY-ID
           MOVE 750.00            TO WS-POLICY-PREMIUM
           MOVE 5.00               TO WS-POLICY-RISK-PCT
           COMPUTE WS-POLICY-PAYOUT =
               WS-POLICY-PREMIUM * (1 + (WS-POLICY-RISK-PCT / 100))

           STRING "POLICY " WS-POLICY-ID
                  " PAYOUT " WS-POLICY-PAYOUT
                  DELIMITED BY SIZE INTO WS-REPORT-LINE

           DISPLAY WS-REPORT-LINE
           STOP RUN.
