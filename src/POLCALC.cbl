       IDENTIFICATION DIVISION.
       PROGRAM-ID. POLCALC.
      ******************************************************************
      * Computes policy payout = premium * (1 + risk-pct/100)
      ******************************************************************
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY POLICYREC.

       PROCEDURE DIVISION.
       MAIN-PARA.
           MOVE "POL0000001"      TO WS-POLICY-ID
           MOVE 1000.00           TO WS-POLICY-PREMIUM
           MOVE 12.50              TO WS-POLICY-RISK-PCT
           COMPUTE WS-POLICY-PAYOUT =
               WS-POLICY-PREMIUM * (1 + (WS-POLICY-RISK-PCT / 100))
           DISPLAY "POLICY-ID: " WS-POLICY-ID
           DISPLAY "PAYOUT: " WS-POLICY-PAYOUT
           STOP RUN.
