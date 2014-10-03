C     Tests for string handling in F77
C     gfortran strings.f -o strings && ./strings 

      program stringTest
        implicit none
        CHARACTER*10 :: a = "abc"
        CHARACTER*10 :: a2 = "abc2"
        CHARACTER*15 :: b = "abc"
        CHARACTER*15 :: c = "   abc"
        
C     Write stuff for a, LEN()
        write (*,*) "a      = '", a, '"'
        write (*,*) "len(a) = ", len(a)

C     Write stuff for b, TRIM(), LEN()
        write (*,*)
        write (*,*) "b            = '", b, '"'
        write (*,*) "len(b)       = ", len(b)
        write (*,*) "trim(b)      = '", trim(b), "'" ! Remove trailing blanks
        write (*,*) "len(trim(b)) = ",len(trim(b))
        
C     Concatenation, TRIM()
        write (*,*)
        write (*,*) "a // b                    = '", a // b, "'"
        write (*,*) "a // ',' // b             = '", a // ',' // b, "'"
        write (*,*) "trim(a) // ',' // trim(b) = '", 
     &       trim(a) // ',' // trim(b), "'"

C     Write stuff for c, TRIM(), ADJUSTL()
        write (*,*)
        write (*,*) "c                    = '", c, "'"
        write (*,*) "trim(c)              = '", TRIM(C), "'"
        write (*,*) "adjustl(c)           = '", adjustl(C), "'" ! Shift characters left to remove initial whitespace (but keep total length)
        write (*,*) "adjustl(trim(c))     = '", adjustl(TRIM(C)), "'"
        write (*,*) "trim(adjustl(c))     = '", trim(adjustl(C)), "'"
        write (*,*) "adjustr(c)           = '", adjustr(c), "'" ! Shift characters right, to remove trailing whitespace (but keep total length)
        write (*,*) "len_trim(c)          = ", len_trim(c)     ! length of string, ignore trailing blanks
        write (*,*) "len_trim(adjustl(c=) = ", len_trim(adjustl(c))

C     Comparisons for a, b
C     Apparently, when comparing two strings of unequal length in FORTRAN,
C      the shortest is padded with blanks
        write (*,*)
        write (*,*) "LGE(a,b) aka. a >= b: ", LGE(a,b), "(lexical)"
        write (*,*) "LGT(a,b) aka. a >  b: ", LGT(a,b), "(lexical)"
        write (*,*) "LLE(a,b) aka. a <= b: ", LLE(a,b), "(lexical)"
        write (*,*) "LLT(a,b) aka. a <  b: ", LLt(a,b), "(lexical)"
        write (*,*) "a .eq. b:             ", a.eq.b
        write (*,*) "a .eq. c:             ", a.eq.c
        write (*,*) "a .eq. adjustl(c):    ", a.eq.adjustl(c)

C     Comparisons for a,c
        write (*,*)
        write (*,*) "a2        = '", a2, "'"
        write (*,*) "a .eq. a2 =  ", a.eq.a2

C     Use array slicing (same as in numpy)
        write (*,*)
        write (*,*) "a2(:3) = '", a2(:3), "'"
        write (*,*) "a2(:3) .eq. a = ", a2(:3) .eq. a
        write (*,*) "a2(:3) .eq. b = ", a2(:3) .eq. b  
 
      end
