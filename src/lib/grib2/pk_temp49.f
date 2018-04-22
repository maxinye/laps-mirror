      SUBROUTINE PK_TEMP49(KFILDO,IPACK,ND5,IS4,NS4,L3264B,
     1                     LOCN,IPOS,IER,*)
C
C        JULY      2002   RUDACK  USED TEMPLATE 4.0 AS A GUIDE  
C        SEPTEMBER 2002   GLAHN   MODIFIED TO CALL PK_TEMP40; NOW   
C                                 TREATS IS4(38) AND IS4(43) AS SIGNED
C
C        PURPOSE
C            PACKS TEMPLATE 4.9, A TEMPLATE FOR POP12 FROM THE PRODUCT
C            DEFINITION SECTION OF A GRIB2 MESSAGE.  IT IS THE 
C            RESPONSIBILITY OF THE CALLING ROUTINE TO PACK THE FIRST 
C            9 OCTETS IN SECTION 4.
C
C        DATA SET USE
C           KFILDO - UNIT NUMBER FOR OUTPUT (PRINT) FILE. (OUTPUT)
C
C        VARIABLES
C              KFILDO = UNIT NUMBER FOR OUTPUT (PRINT) FILE. (INPUT)
C            IPACK(J) = THE ARRAY THAT HOLDS THE ACTUAL PACKED MESSAGE
C                       (J=1,ND5). (INPUT/OUTPUT)
C                 ND5 = THE SIZE OF THE ARRAY IPACK( ). (INPUT)
C              IS4(J) = THE PRODUCT DEFINITION INFORMATION FOR 
C                       TEMPLATE 4.9 IS WRITTEN TO ELEMENTS 10 THROUGH
C                       55 OR MORE, DEPENDING ON THE TIME RANGE OVER 
C                       WHICH STATISTICAL PROCESSING IS DONE
C                       (J=1,NS4).  (INPUT/OUTPUT)
C                 NS4 = SIZE OF IS4( ). (INPUT) 
C              L3264B = THE INTEGER WORD LENGTH IN BITS OF THE MACHINE
C                       BEING USED. VALUES OF 32 AND 64 ARE
C                       ACCOMMODATED. (INPUT)
C                LOCN = THE WORD POSITION FROM WHICH TO PACK THE
C                       NEXT VALUE. (INPUT/OUTPUT)
C                IPOS = THE BIT POSITION IN LOCN FROM WHICH TO START
C                       PACKING THE NEXT VALUE.  (INPUT/OUTPUT)
C                 IER = RETURN STATUS CODE. (OUTPUT)
C                         0 = GOOD RETURN.
C                       1-4 = ERROR CODES GENERATED BY PKBG. SEE THE 
C                             DOCUMENTATION IN THE PKBG ROUTINE.
C                       402 = IS4( ) HAS NOT BEEN DIMENSIONED LARGE
C                             ENOUGH TO CONTAIN THE ENTIRE TEMPLATE. 
C                       403 = IS4(8) DOES NOT CONTAIN A SUPPORTED 
C                             TEMPLATE NUMBER.
C                   * = ALTERNATE RETURN WHEN IER NE 0. 
C
C             LOCAL VARIABLES
C             MINSIZE = THE SMALLEST ALLOWABLE DIMENSION FOR IS4( ).
C                   N = L3264B = THE INTEGER WORD LENGTH IN BITS OF
C                       THE MACHINE BEING USED. VALUES OF 32 AND
C                       64 ARE ACCOMMODATED.
C               ISIGN = SIGN OF VALUE BEING PACKED, 0 = POSITIVE,
C                       1 = NEGATIVE.  THE SIGN ALWAYS GOES IN THE
C                       LEFTMOST BIT OF THE AREA ASSIGNED TO THAT VALUE.
C
C        NON SYSTEM SUBROUTINES CALLED
C           PKBG
C
      PARAMETER(MINSIZE=55)
C
      DIMENSION IPACK(ND5),IS4(NS4)
C
      N=L3264B
      IER=0
C
C        CHECK TO MAKE SURE THAT THIS IS TEMPLATE 4.9. 
C
      IF(IS4(8).NE.9)THEN
C        WRITE(KFILDO,10)IS4(8)
C10      FORMAT(/' TEMPLATE ',I4,' INDICATED BY IS4(8)'/
C    1           ' IS NOT CORRECT IN PK_TEMP49.'/)
         IER=403
         GO TO 900
      ENDIF
C
C        CHECK THE DIMENSIONS OF IS4( ).
C
      IF(NS4.LT.MINSIZE)THEN
C        WRITE(KFILDO,20)NS4,MINSIZE
C20      FORMAT(/' IS4( ) IS CURRENTLY DIMENSIONED TO CONTAIN'/
C    1           ' NS4=',I4,' ELEMENTS. THIS ARRAY MUST BE'/
C    2           ' DIMENSIONED TO AT LEAST ',I4,' ELEMENTS'/
C    3           ' TO CONTAIN ALL OF THE DATA IN PRODUCT'/
C    4           ' DEFINITION TEMPLATE 4.9.'/)
         IER=402
         GO TO 900
      ENDIF
C
C           SINCE THIS TEMPLATE SHARES THE SAME INFORMATION
C           AS TEMPLATE 4.0, CALL THE PK_TEMP40 ROUTINE
         CALL PK_TEMP40(KFILDO,IPACK,ND5,IS4,NS4,L3264B,LOCN,IPOS,
     1                  IER,*900)
C
C        PACK THE FORECAST PROBABILITY NUMBER.
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(35),8,N,IER,*900)
C
C        PACK THE TOTAL NUMBER OF FORECAST PROBABILITIES.
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(36),8,N,IER,*900)
C
C        PACK THE PROBABILITY TYPE.
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(37),8,N,IER,*900)
C
C        PACK THE SCALE FACTOR OF LOWER LIMIT.
         ISIGN=0
         IF(IS4(38).LT.0) ISIGN=1
         CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,ISIGN,1,N,IER,*900)
         CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,ABS(IS4(38)),7,N,IER,*900)
C
C        PACK THE SCALED VALUE OF LOWER LIMIT.
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(39),32,N,IER,*900)
C
C        PACK THE SCALE VALUE OF UPPER LIMIT.
         ISIGN=0
         IF(IS4(43).LT.0) ISIGN=1
         CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,ISIGN,1,N,IER,*900)
         CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,ABS(IS4(43)),7,N,IER,*900)
C
C        PACK THE SCALED VALUE OF UPPER LIMIT.
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(44),32,N,IER,*900)
C
C        PACK YEAR OF END OF OVERALL TIME INTERVAL. 
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(48),16,N,IER,*900)
C
C        PACK MONTH OF END OF OVERALL TIME INTERVAL. 
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(50),8,N,IER,*900)
C
C        PACK DAY OF END OF OVERALL TIME INTERVAL. 
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(51),8,N,IER,*900)
C
C        PACK HOUR OF END OF OVERALL TIME INTERVAL. 
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(52),8,N,IER,*900)
C
C        PACK MINUTE OF END OF OVERALL TIME INTERVAL.  
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(53),8,N,IER,*900)
C
C        PACK SECOND OF END OF OVERALL TIME INTERVAL. 
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(54),8,N,IER,*900)
C
C        PACK THE NUMBER OF TIME RANGE SPECIFICATIONS DESCRIBING
C        THE TIME INTERVALS USED TO CALCULATE THE STATISTICALLY
C        PROCESSED FIELD.
      CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(55),8,N,IER,*900)
C
C        CHECK TO MAKE SURE THAT IS4( ) WAS DIMENSIONED LARGE ENOUGH
C        TO CONTAIN THE DATA FOR ALL OF THE IS4(55) TIME RANGES.
C
      ISIZE=56+12*(IS4(55)-1)
      IF(NS4.LT.ISIZE)THEN
C        WRITE(KFILDO,19)NS4,ISIZE
C19      FORMAT(/' IS4( ) IS CURRENTLY DIMENSIONED TO CONTAIN'/
C    1           ' NS4=',I4,' ELEMENTS.  THIS ARRAY MUST BE'/
C    2           ' DIMENSIONED TO AT LEAST ',I4,' ELEMENTS'/
C    3           ' TO CONTAIN ALL OF THE TIME RANGES'/
C    4           ' IN PRODUCT DEFINITION TEMPLATE 4.9.'/)
         IER=402
         GO TO 900
      ENDIF
C
      DO 30 I=1,IS4(55)
         IC=12*(I-1)
C
C           PACK THE TOTAL NUMBER OF DATA VALUES MISSING IN
C           STATISTICAL PROCESS.
         CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(56+IC),32,N,
     1             IER,*900)
C
C           PACK THE STATISTICAL PROCESS USED TO CALCULATE THE
C           PROCESSED FIELD FROM THE FIELD AT EACH TIME INCREMENT
C           DURING THE TIME RANGE.
         CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(60+IC),8,N,
     1             IER,*900)
C
C           PACK THE TYPE OF TIME INCREMENT BETWEEN SUCCESSIVE
C           FIELDS USED IN THE STATISTICAL PROCESS.
         CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(61+IC),8,N,
     1             IER,*900)
C
C           PACK THE INDICATOR OF UNIT OF TIME FOR TIME RANGE OVER
C           WHICH STATISTICAL PROCESSING IS DONE.
         CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(62+IC),8,N,
     1             IER,*900)
C
C           PACK THE LENGTH OF THE TIME RANGE OVER WHICH STATISTICAL
C           PROCESSING IS DONE, IN UNITS DEFINED BY THE PREVIOUS
C           OCTET.
         CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(63+IC),32,N,
     1             IER,*900)
C
C           PACK THE INDICATOR OF UNIT OF TIME FOR THE INCREMENT
C           BETWEEN THE SUCCESSIVE FIELDS USED.
         CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(67+IC),8,N,
     1             IER,*900)
C
C           PACK THE TIME INCREMENT BETWEEN SUCCESSIVE FIELDS,
C           IN UNITS DEFINED BY THE PREVIOUS OCTET.
         CALL PKBG(KFILDO,IPACK,ND5,LOCN,IPOS,IS4(68+IC),32,N,
     1             IER,*900)
C
 30   ENDDO
C
C       ERROR RETURN SECTION
C
 900  IF(IER.NE.0)RETURN 1
C
      RETURN
      END
