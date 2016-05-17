#include <fcntl.h>
#include <archive.h>
#include <archive_entry.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

//********************************************************************************************************
void write_archive(const char *outname, char **filename, int nFiles) {
  // Adapted from
  // https://github.com/libarchive/libarchive/wiki/Examples#A_Basic_Write_Example
  struct archive *a;
  struct archive_entry *entry;
  struct stat st;
  int err;
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
    err = stat(filename[i], &st); // POSIX only, use GetFileSizeEx on Windows.
    printf("stat reported err=%i\n", err);
    if(err != 0) continue;
    
    archive_entry_set_pathname(entry, filename[i]);
    archive_entry_set_size(entry, st.st_size);
    archive_entry_set_filetype(entry, AE_IFREG);
    archive_entry_set_perm(entry, 0644);
    archive_write_header(a, entry);
    
    //Write the data
    fd = open(filename[i], O_RDONLY);
    len = read(fd, buff, sizeof(buff));
    while ( len > 0 ) {
      err=archive_write_data(a, buff, len);
      if (err < 0){
	printf("Error when writing file, got err=%i\n",err);
	exit(1);
      }
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
void list_archive(const char* const infile) {
  // Adapted from:
  // https://github.com/libarchive/libarchive/wiki/Examples#List_contents_of_Archive_stored_in_File
  
  printf("Opening archive '%s' for listing...\n",infile);
  
  struct archive* a = archive_read_new();
  archive_read_support_format_zip(a);
  int err = archive_read_open_filename(a, infile,10240);//Note: Blocksize isn't neccessarilly adhered to
  if (err != ARCHIVE_OK) {
    printf("Error when opening archive '%s', err=%i\n",infile,err);
  }
  
  struct archive_entry* entry;
  while (archive_read_next_header(a,&entry)==ARCHIVE_OK){
    printf("Found file: '%s'\n",archive_entry_pathname(entry));
    archive_read_data_skip(a);
  }
  
  archive_read_close(a);
  err = archive_read_free(a);
  if (err != ARCHIVE_OK){
    printf("Error when calling archive_read_free(), '%s', err=%i\n",infile,err);
  }
}

//********************************************************************************************************
void read_archive(const char* const infile, const char* extractfolder){
  // Strongly inspired by
  // https://github.com/libarchive/libarchive/wiki/Examples#A_Complete_Extractor
  
  printf("Opening archive '%s' for extracting to folder '%s'...\n",infile,extractfolder);

  //Check that the archive exists

  //Check that the folder exists, if not then create it
  
  struct archive* a = archive_read_new();
  archive_read_support_format_zip(a);
  struct archive* ext = archive_write_disk_new();
  archive_write_disk_set_options(ext,ARCHIVE_EXTRACT_TIME|ARCHIVE_EXTRACT_PERM|ARCHIVE_EXTRACT_ACL|ARCHIVE_EXTRACT_FFLAGS);
  archive_write_disk_set_standard_lookup(ext);
  
  int err;
  err = archive_read_open_filename(a, infile, 10240);
  if (err != ARCHIVE_OK) {
    printf("Error opening archive, err=%i\n",err);
    exit(1);
  }

  struct archive_entry *entry;
  
  const int fcount_max = 1000;
  char completed=0; //C-Boolean
  for(int fcount=0; fcount<fcount_max;fcount++){
    err = archive_read_next_header(a,&entry);
    if (err == ARCHIVE_EOF){
      completed=1;
      break;
    }
    else if (err != ARCHIVE_OK){
      printf("Error when reading archive, err=%i\n",err);
      printf("%s\n",archive_error_string(a));
      exit(1);
    }
    printf("Found file: '%s'\n",archive_entry_pathname(entry));

    //char newpath[PATH_MAX];
    
    
    //err = archive_write_header(ext, entry); //This will by default clobber the files which are inside the archive...
    /*
    if (err != ARCHIVE_OK){
      printf("Error when extracting archive, err=%i\n",err);
      printf("%s\n",archive_error_string(ext));
      exit(1);
    }
    */
  }
  if (!completed) {
    printf("Error: The file header loop was aborted by the infinite loop guard\n");
    exit(1);
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
  read_archive("tmpdir/test.zip", "tmpdir");
  
  //Free storage
  free(filesToCompress[0]);
  free(filesToCompress[1]);
  free(filesToCompress[2]);
  free(filesToCompress);
}
