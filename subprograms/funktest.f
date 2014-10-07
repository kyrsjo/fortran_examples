C     Test/examples for the different subprogram/subroutine
C     variants used with FORTRAN.
C     gfortran funktest.f sub.f -o funktest && ./funktest 

      program subprog
        implicit none
     
        REAL :: A,p
        REAL :: FTEST1,func2
        
        INTEGER :: I,J
        character :: rowmrk

C       Simple function statement (types declared above)
        FTEST1(A,p) = A*SIN(p)**2
      
C       Proper F95 loop
        write (*,*) "          I  ", "         p   ", "FTEST1(2.0,p)"
        do I = 0,50,1
           write (*,*) I, I*2*3.14/100, FTEST1(2.0,I*2*3.14/100)
        end do
        
        write (*,*) ! blank line
        do I=0,5,1
           do J=0,5,1
              if (J .eq. 5) then
                 rowmrk = "*"
              else 
                 rowmrk = " "
              end if

              write (*,*) I,J,FUNC2(1.0*I,1.5*J), rowmrk
           end do
        end do
        
        write(*,*) !blank
        call testSub ! in sub.f
        
      end program subprog

C     function: return one value
      real function func2(x,y)
        implicit none
        real :: x,y
        real :: func2
        
        func2 = x*y
        
      end function func2
