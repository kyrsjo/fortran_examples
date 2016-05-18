      program test_libarchive_fortran
      
      integer nargs
      character(len=32) arg
      
      write(*,*) "This is a program to test libArchive_wrapper "//
     &     "functionality, similar to test_libarchive.c"

      
C     Read command line arguments
      nargs = iargc()
      if (nargs.ne.1) then
         call USAGE
         stop 1
      endif
      call getarg(1,arg)
      if ( len(trim(arg)) .ne. 1) then
         call USAGE
         stop 2
      endif

      select case (arg(1:1))
      case ("W")
         call WRITE
      case ("L")
         call LIST
      case ("R")
         call READ
      case default
         call USAGE
         stop 3
      end select
         
      end program

      subroutine USAGE
         write(*,*) "Expected 1 argument, which is the action to do"
         write(*,*) "Valid actions:"
         write(*,*) "  W: Create/write the archive"
         write(*,*) "  L: List the archive"
         write(*,*) "  R: Read the archive"
      end subroutine

      subroutine WRITE
      character(32) filenames(4)
      filenames(1)="README"
      filenames(2)="buildTest.sh"
      filenames(3)="buildLibArchive.sh"
      filenames(4)="noFile"
      
      write(*,*) "Writing!"
      FLUSH(6)
      call f_write_archive("tmpdir/test.zip", filenames,4)
      
      end subroutine

      subroutine LIST
      write(*,*) "Listing!"
      FLUSH(6)
      call f_list_archive("tmpdir/test.zip")
      write(*,*) "Done"
      end subroutine

      subroutine READ
      write(*,*) "Reading!"
      FLUSH(6)
      call f_read_archive("tmpdir/test.zip","tmpdir")
      write(*,*) "Done"
      end subroutine
