C     Tests for I/O in F77
C     gfortran inputOutput.f -o inputOutput && ./inputOutput && cat test.txt

      program IOtest
        implicit none

C       For part (A)
        REAL, PARAMETER :: PI = 3.14 ! constant
        REAL :: radius
        REAL :: area

C       For part (B)
        INTEGER, PARAMETER :: file1 = 10

        write (*,*) "Test of I/O functions in F77"
        
C       (A) Reading from keyboard
        PRINT *, "Area of circle: Please give radius (currently =", 
     & radius, ")"
        read (*,*) radius
        area = PI * radius**2
        print *, "Area = ", area
        
C       (B) Writing to text file
        print *, "Test writing to file 'test.txt'"
        open(unit=file1, file="test.txt", action="write",
     &       status ="replace")
        write(file1,*) "### test.txt ###"
        write(file1,*) "Radius = ", radius, ", => area = ", area
        close(file1)
        
      end program
