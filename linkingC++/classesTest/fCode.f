      program testLink

      integer n
      real r   !float
      real*8 x !double

      character(32) str1

      !character str2 (5)*(32)
      character(32) str2(5)
      
      !Function definitions (like in a header file), not needed for subroutines.
      real*8 test_double_double
      double precision test_objgetpi
      
      write(*,*) "Calling test1:"
      call test_void()

      write(*,*) "Calling test_void_int with argument 42:"
      call test_void_int(42)
      n=42
      write(*,*) "Calling test_void_int with argument n=",n,":"
      call test_void_int(n)

      write(*,*)
      
      write(*,*) "Calling test_void_float with argument 3.14:"
      call test_void_float(3.14) !OK
      r=3.14
      write(*,*) "Calling test_void_float with argument r=",r,":"
      call test_void_float(r) !OK
      x=3.14
      write(*,*) "Calling test_void_float with argument x=",x,":"
      call test_void_float(x) !Broken
      
      write(*,*)
      
      write(*,*) "Calling test_void_double with argument 3.14:"
      call test_void_double(3.14) !Broken
      r=3.14
      write(*,*) "Calling test_void_double with argument r=",r,":"
      call test_void_double(r) !Broken
      x=3.14
      write(*,*) "Calling test_void_double with argument x=",x,":"
      call test_void_double(x) !OK

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

      !!! Here comes the CLASS TEST !!!

      call test_makeObj(42)
      call test_objgetpi_sub(x)
      write(*,*) "Called test_objgetpi_sub, x=",x
      x= 0.0
      x = test_objgetpi()
      write(*,*) "Called test_objgetpi, x=",x
      call test_destroyObj()
      
      end program
