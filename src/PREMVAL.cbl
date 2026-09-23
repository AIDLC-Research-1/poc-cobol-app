       IDENTIFICATION DIVISION.
       PROGRAM-ID. PREMVAL.
      ******************************************************************
      * Validates a premium amount is within an accepted band
      ******************************************************************
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY POLICYREC.
       01  WS-VALID-FLAG   PIC X(1) VALUE "N".

       PROCEDURE DIVISION.
       MAIN-PARA.
           MOVE "POL0000002"      TO WS-POLICY-ID
           MOVE 2500.00           TO WS-POLICY-PREMIUM

           IF WS-POLICY-PREMIUM >= 100.00 AND
              WS-POLICY-PREMIUM <= 50000.00
               MOVE "Y" TO WS-VALID-FLAG
           ELSE
               MOVE "N" TO WS-VALID-FLAG
           END-IF

           DISPLAY "POLICY-ID: " WS-POLICY-ID
           DISPLAY "VALID: " WS-VALID-FLAG
           STOP RUN.
