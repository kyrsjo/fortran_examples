      program testLink

      integer n
      real r
      real*8 x

      character(32) str1

      !character str2 (5)*(32)
      character(32) str2(5)
      
      !Function definitions (like in a header file), not needed for subroutines.
      real*8 test_double_double
      
      write(*,*) "Calling test1:"
      call test_void()

      write(*,*) "Calling test_void_int with argument 42:"
      call test_void_int(42)
      n=42
      write(*,*) "Calling test_void_int with argument n=",n,":"
      call test_void_int(n)

      write(*,*)
      
      write(*,*) "Calling test_void_float with argument 3.14:"
      call test_void_float(3.14)
      r=3.14
      write(*,*) "Calling test_void_float with argument r=",r,":"
      call test_void_float(r)
      x=3.14
      write(*,*) "Calling test_void_float with argument x=",x,":"
      call test_void_float(x)
      
      write(*,*)
      
      write(*,*) "Calling test_void_double with argument 3.14:"
      call test_void_double(3.14)
      r=3.14
      write(*,*) "Calling test_void_double with argument r=",r,":"
      call test_void_double(r)
      x=3.14
      write(*,*) "Calling test_void_double with argument x=",x,":"
      call test_void_double(x)

      write(*,*)
      
c$$$      write(*,*) "Calling test_void_double with argument 3.14:"
c$$$      call test_double_double(3.14) !Don't call write(*,*) on a printing function!
c$$$      r=3.14
c$$$      write(*,*) "Calling test_void_double with argument r=3.14:"
c$$$      r=test_double_double(r)
c$$$      write(*,*) "Got return",r
      x=3.14
      write(*,*) "Calling test_void_double with argument x=3.14:"
      x= test_double_double(x)
      write(*,*) "Got return =",x

      write(*,*)

      str1="hi there!"
      write(*,*) "Calling test_void_string with argument str1=",str1
      call test_void_string(str1)

      str2(1)="Hi number 1"
      str2(2)="Hi number two"
      str2(3)="Hi number 3!?!"
      write(*,*) "Calling test_void_stringArray with argument str2:"
      write(*,*) "(1):", str2(1)
      write(*,*) "(2):", str2(2)
      write(*,*) "(3):", str2(3)
      call test_void_string(str2)
      write(*,*) "(1):", str2(1)
      write(*,*) "(2):", str2(2)
      write(*,*) "(3):", str2(3)
      call test_void_stringarray(str2,3)
      
      
      end program
