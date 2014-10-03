C     Tests for I/O in F77
C     gfortran inputOutput.f -o inputOutput && ./inputOutput && cat test.txt

      program IOtest
        implicit none

C       For part (A)
        REAL, PARAMETER :: PI = 3.14 ! constant
        REAL :: radius
        REAL :: area

C       For part (B) and (C)
        INTEGER, PARAMETER :: file1 = 10
        CHARACTER*300 longstring !if this is too short, the string will just be cropped at the end
                                 !     (but valgrind still indicates zero errors)
        
C       For part (D)
        Integer, parameter :: Imax = 20
        INTEGER fibonaci(-2:Imax)
        integer :: I = 0, I2,I3
        



        write (*,*) "Test of I/O functions in F77"
        
C       (A) Reading from keyboard
        PRINT *, "Area of circle: Please give radius"
     &       ,"(currently =", radius, ")" !Comment out this line to avoid valgrind going berzerk
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
        
C       (C) Reading back the same text file
        open(file1,file="test.txt",status="old")
        print *, "read file back.."
 101    continue                !loop
        read(file1,1000,END=102) longstring
C        write (*,*) "'"//longstring//"'"
        write (*,*) "'"//trim(longstring)//"'"
        goto 101                ! loop...
 102    continue                ! break out of loop
 1000   FORMAT(A)               ! format for reading a free form text file
        close(file1)

C       (D) Generate fibonaci sequence, write it to file and read it back in
        print *, "Computing fibonaci sequence"
        fibonaci(-2) = 0
        write(*,*) -2, fibonaci(-2)
        fibonaci(-1) = 1
        write(*,*) -1, fibonaci(-1)
        do 200 I = 0,Imax ! Don't loop to far or we segfault...
           fibonaci(I) = fibonaci(I-1)+fibonaci(I-2)
           write(*,*) I, fibonaci(I)
 200    continue
        
C       Write text file
        print *, "writing it to ascii file and zeroing"
 2001   FORMAT (I12 I12)
        open(file1,file="testFibo.txt",status="replace",action="write")
        do 201 I = -2,Imax
           write(file1,2001) I,fibonaci(I)
           fibonaci(I) = -1
 201    continue
        close(file1)
        do 205 I = -2,Imax
           write(*,*) I, fibonaci(I)
 205    continue

C       Read text file
        print *, "Reading ASCII file back in"
        open(file1,file="testFibo.txt",status="old",action="read")
 202    read(file1,2001,END=203) I, fibonaci(I)
        write(*,*) I, fibonaci(I)
        goto 202
 203    close(file1)
        
C       Write binary ("unformatted") file, sequential mode (i.e. records with metadata)
        open(file1,file="testFibo.dat",status="replace",action="write", 
     &       form="unformatted")
        do 301 I = -2,Imax
           write(file1) I, fibonaci(I)
 301    continue
        close(file1)

C       Read binary ("unformatted") file, sequenctial mode
        print *, "Reading a unformatted/sequential file back in"
        open(file1,file="testFibo.dat",status="old",action="read", 
     &       form="unformatted")
 302    read(file1,end=303) I,I2
        write (*,*) I, I2, I2.eq.fibonaci(I) ! also check that we have the correct data back
        goto 302
 303    close(file1)
        
C       Write binary ("unformatted") file, direct access mode 
C        => i.e. no per-record (WRITE/READ call) metadata
C        Should give shorter files 
        open(file1,file="testFibo.dat2",status="replace",
     &       access="direct",
     &       action="write", form="unformatted",recl=sizeof(I)*2)
        do 401 I = -2,Imax
           write(file1,rec=I+3) I, fibonaci(I)
 401    continue
        close(file1)

C     Read it back in
        print *, "Reading a unformatted/direct file back in"
        print *, "File should be ", 1*4*2 * (Imax+3), " bytes shorter"
        print *,              "(two 4-byte/32-bit metadata per record, 
     &Imax+3 (0,-1,-2) records"
        open(file1,file="testFibo.dat2",status="old",
     &       access="direct",
     &       action="read", form="unformatted",recl=sizeof(I)*2)
        do 402 I3 = 1,Imax+3
           read(file1,rec=I3) I,I2
           write (*,*) I3, I, I2, I2.eq.fibonaci(I) ! also check that we have the correct data back
 402    continue
 403    close(file1)
        
        
      end program
