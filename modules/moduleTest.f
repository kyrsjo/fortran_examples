      module datashare
      
      !integer, parameter :: N = 100
      integer, parameter :: N = 600000000 !4.8 Gb > data segment limit (and 32-bit limit)
      
      double precision,dimension(N) :: data

      !In case the module is only used in subroutines,
      ! and at some points none of these are actually running,
      ! the data in the moldule goes out of scope and un-initialized.
      ! SAVE prevents this. Note that the same gotcha applies to COMMON blocks!
      save
      
      end module datashare
      
      program test
      use datashare
      implicit none
      integer i
      double precision sum
      
      write(*,*) "N=",N
      
      sum=0.0d0      
      do i=1,N
         data(i) = i*3.14
         sum = sum+data(i)
      end do
      
      write(*,*) "Sum =", sum
      
      call writer
      
      end program

      subroutine writer
      use datashare
      implicit none
      integer i
      double precision sum
      
      sum=0.0d0
      write(*,*) "N=",N
      
      do i=1,N
         sum = sum+data(i)
      end do
      write(*,*) "Sum =", sum
      
      end subroutine
