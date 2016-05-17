#include <fcntl.h>
#include <archive.h>
#include <archive_entry.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//********************************************************************************************************
void write_archive(const char *outname, char **filename, int nFiles) {
  // Adapted from
  // https://github.com/libarchive/libarchive/wiki/Examples#A_Basic_Write_Example
  struct archive *a;
  struct archive_entry *entry;
  struct stat st;
  int statErr;
  char buff[8192];
  int len;
  int fd;
  
  
  printf("Writing outname='%s'\n",outname);
  
  a = archive_write_new(); //Constructs the archive in memory? If so, may be problematic for large archives.
  //For tar.gz:
  // archive_write_add_filter_gzip(a);
  // archive_write_set_format_pax_restricted(a); // Note 1
  //For .zip:
  archive_write_set_format_zip(a);

  archive_write_open_filename(a, outname);
  entry = archive_entry_new();
  for (int i=0;i<nFiles;i++){
    printf("Compressing filename='%s'... ",filename[i]);

    //Write the header
    statErr = stat(filename[i], &st); // POSIX only, use GetFileSizeEx on Windows.
    printf("statErr=%i\n", statErr);
    if(statErr != 0) continue;
    archive_entry_set_pathname(entry, filename[i]);
    archive_entry_set_size(entry, st.st_size);
    archive_entry_set_filetype(entry, AE_IFREG);
    archive_entry_set_perm(entry, 0644);
    archive_write_header(a, entry);

    //Write the data
    fd = open(filename[i], O_RDONLY);
    len = read(fd, buff, sizeof(buff));
    while ( len > 0 ) {
        archive_write_data(a, buff, len);
        len = read(fd, buff, sizeof(buff));
    }
    close(fd);
    
    archive_entry_clear(entry);
  }
  archive_entry_free(entry);
  printf("Complete!\n");
  archive_write_close(a); // Note 4
  archive_write_free(a); // called archive_write_finish() in old versions of libarchive
}

//********************************************************************************************************
void list_archive(const char* const inname) {
  // Adapted from:
  // https://github.com/libarchive/libarchive/wiki/Examples#List_contents_of_Archive_stored_in_File
  
  printf("Opening archive '%s' for listing:\n",inname);
  
  struct archive* a = archive_read_new();
  archive_read_support_format_zip(a);
  int r = archive_read_open_filename(a, inname,10240);//Note: Blocksize isn't neccessarilly adhered to
  if (r != ARCHIVE_OK) {
    printf("Error when opening archive '%s', r=%i\n",inname,r);
  }
  
  struct archive_entry* entry;
  while (archive_read_next_header(a,&entry)==ARCHIVE_OK){
    printf("Found file: '%s'\n",archive_entry_pathname(entry));
    archive_read_data_skip(a);
  }
  
  archive_read_close(a);
  r = archive_read_free(a);
  if (r != ARCHIVE_OK){
    printf("Error when calling archive_read_free(), '%s', r=%i\n",inname,r);
  }
}

//********************************************************************************************************
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
    status = mkdir("tmpdir",S_IRWXU);
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
  //read_archive("tmpdir/test.zip")
  
  //Free storage
  free(filesToCompress[0]);
  free(filesToCompress[1]);
  free(filesToCompress[2]);
  free(filesToCompress);
}
