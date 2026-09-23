       IDENTIFICATION DIVISION.
       PROGRAM-ID. CLAIMCHK.
      ******************************************************************
      * Flags whether a claim amount exceeds the policy payout
      ******************************************************************
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY POLICYREC.
       01  WS-CLAIM-AMOUNT   PIC 9(9)V99.
       01  WS-EXCEEDS-FLAG   PIC X(1) VALUE "N".

       PROCEDURE DIVISION.
       MAIN-PARA.
           MOVE "POL0000004"      TO WS-POLICY-ID
           MOVE 1500.00           TO WS-POLICY-PAYOUT
           MOVE 1750.00           TO WS-CLAIM-AMOUNT

           IF WS-CLAIM-AMOUNT > WS-POLICY-PAYOUT
               MOVE "Y" TO WS-EXCEEDS-FLAG
           ELSE
               MOVE "N" TO WS-EXCEEDS-FLAG
           END-IF

           DISPLAY "POLICY-ID: " WS-POLICY-ID
           DISPLAY "CLAIM EXCEEDS PAYOUT: " WS-EXCEEDS-FLAG
           STOP RUN.
