C     Test/examples for the different subprogram/subroutine
C     variants used with FORTRAN.
C     gfortran funktest.f sub.f -o funktest && ./funktest 

      program subprog
        implicit none
     
        REAL :: A,p
        REAL :: FTEST1,func2, twofunc
        
        INTEGER :: I,J
        character :: rowmrk

        REAL :: x,y,z

        real subfunc
        intrinsic cos

C       Statement function (types declared above)
        FTEST1(A,p) = A*SIN(p)**2
      
C       Call simple function statement
C       Proper F95 loop:
        write (*,*) "          I  ", "         p   ", "FTEST1(2.0,p)"
        do I = 0,50,1
           write (*,*) I, I*2*3.14/100, FTEST1(2.0,I*2*3.14/100)
        end do

C       Call function
C       Proper F95 for loop, if then/else
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

C       Call subroutine
        write(*,*) !blank    
        X = 1
        Y = 2
        Z = 0.0
        call sub2(X,Y,z)     ! Works: Real->Real
        write (*,*) "Z became:",z
        call sub2(3.0,2.0,z) ! Works: Real->Real
        write (*,*) "Z became:",z
        call sub2(1,2,z) ! Does not work: Int->Real
        write (*,*) "Z became:",z
        I = 1
        J = 2
        call sub2(I,J,z)        ! Does not work: Int->Real
        write (*,*) "Z became:",z

C       Call subroutine in external file
        write(*,*) !blank
        call testSub ! in sub.f

C       Call with a function as a parameter
        write(*,*) !blank
        write(*,*) subfunc(sin,3.14/2)
        write(*,*) subfunc(sin,3.14)
C        print *, cos(3.14/2),"*" ! If COS never called earlier, need INTRINSIC statement
        write(*,*) subfunc(cos,3.14/2)
        write(*,*) subfunc(cos,3.14)
        
        write (*,*) twofunc(1.0,2.0) ! If never called earlier, segmentation fault.
        write(*,*) subfunc(twofunc,3.14) !Results in silent incorrect call: Func2 actually takes two arguments
        
      end program subprog

C     function: return one value
      real function func2(x,y)
        implicit none
        real :: x,y
        real :: func2
C        write (*,*) "in func2, x=", X, "y=", Y

        func2 = x*y
        
      end function func2

C     function which takes two values
      real function twoFunc(x,y)
        implicit none
        real :: x,y, twofunc
        
        write (*,*) "in func2, x=", X, "y=", Y
        
        twofunc = x+y
        
      end function twofunc
        

C     subroutine: Return any number of values, through call-by-reference
      subroutine  sub2(a,b,c)
        implicit none
        real :: a,b,c

        c = a+b
      end subroutine sub2

C     Passing the name of another subroutine as a parameter
      function subfunc(func,arg)
        implicit none
        real :: subfunc
        real :: func, arg
        
        subfunc = func(arg)
      end function subfunc
        
