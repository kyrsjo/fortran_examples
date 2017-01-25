#include <stdlib.h>
#include <string.h>
#include <stdio.h>
//#include <fcntl.h> //open
#include <sys/stat.h>
#include <unistd.h> //unlink

#if defined(_WIN32)
#include <windows.h>
#endif

#include "libArchive_wrapper.h"

int main(int argc, char** argv){

  //List the files to compress
  char** filesToCompress;
  const size_t strlen = 32;
  const size_t numStrings = 4;
  filesToCompress = malloc(4*sizeof(char*));
  
  filesToCompress[0]=calloc(strlen,sizeof(char));
  strncpy(filesToCompress[0],"README",strlen);
  filesToCompress[1]=calloc(strlen,sizeof(char));
  strncpy(filesToCompress[1],"buildTest.sh",strlen);
  filesToCompress[2]=calloc(strlen,sizeof(char));
  strncpy(filesToCompress[2],"buildLibArchive.sh",strlen);
  filesToCompress[3]=calloc(strlen,sizeof(char));
  strncpy(filesToCompress[3],"noFile",strlen);

  //Create tmpdir folder if neccessary
  struct stat st;
  int status;
  if (stat("tmpdir", &st) != 0) {
    printf("Creating tmpdir\n");
#if defined(_WIN32)
    status = CreateDirectory("tmpdir",NULL);
#else
    status = mkdir("tmpdir",S_IRWXU);
#endif
    if (status){
      printf("Something went wrong when creating tmpdir. Sorry!");
      exit(1);
    }
  }
  else if (stat("tmpdir", &st) == 0 && ! S_ISDIR(st.st_mode)) {
    printf("tmpdir exists, but is not a directory. You fix it!\n");
    exit(1);
  }
  
  //Delete old tmp file
  int un_status = unlink("tmpdir/test.zip"); //Not Windows friendly
  printf("Deleting 'tmpdir/test.zip'...\n");
  if (un_status) {
    printf("Unlink was not a sucess, status=%i -- maybe the zip file didn't exist? Oh well.\n",un_status);
  }
  //Delete other files (created by decompression)

  for (int i=0; i<numStrings;i++){
    char* tmpstr = calloc((strlen+7),sizeof(char));
    strncat(tmpstr,"tmpdir/",7);
    strncat(tmpstr,filesToCompress[i],strlen);
    int un_status = unlink(tmpstr); //Not Windows friendly
    printf("Deleted '%s', status=%i\n",tmpstr,un_status);
    free(tmpstr);
    tmpstr=NULL;
  }
  printf("\n");

  
  //Create tmp zip file!
  write_archive("tmpdir/test.zip",filesToCompress,numStrings);
  printf("\n");
  
  //List the archive contents
  list_archive("tmpdir/test.zip");
  printf("\n");
  
  //Unzip it.
  read_archive("tmpdir/test.zip", "tmpdir");
  
  //Free storage
  free(filesToCompress[0]);
  free(filesToCompress[1]);
  free(filesToCompress[2]);
  free(filesToCompress);

  //Unzip Sixin.zip
  if (stat("sixin_dir", &st) != 0) {
    printf("Creating sixin_dir\n");
#if defined(_WIN32)
    status = CreateDirectory("sixin_dir",NULL);
#else
    status = mkdir("sixin_dir",S_IRWXU);
#endif
    if (status){
      printf("Something went wrong when creating sixin_dir. Sorry!");
      exit(1);
    }
  }
  else if (stat("sixin_dir", &st) == 0 && ! S_ISDIR(st.st_mode)) {
    printf("sixin_dir exists, but is not a directory. You fix it!\n");
    exit(1);
  }

  read_archive("Sixin.zip", "sixin_dir");
  

}
