C     Test/examples for recursion in FORTRAN
C     gfortran recursion.f -o recursion && ./recursion
C
C     From:
C     http://fortranwiki.org/fortran/show/recursion
C     
C     Note use of "recursive" and "result" keywords

      program ackermann
      integer :: ack
      write(*,*) ack(3, 12)
      end program ackermann
      
      recursive function ack(m, n) result(a)
      integer, intent(in) :: m,n
      integer :: a
      if (m == 0) then
      a=n+1
      else if (n == 0) then
      a=ack(m-1,1)
      else
      a=ack(m-1, ack(m, n-1))
      end if
      end function ack
