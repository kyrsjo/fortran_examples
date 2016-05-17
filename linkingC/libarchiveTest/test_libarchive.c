#include <fcntl.h>
#include <archive.h>
#include <archive_entry.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Adapted from
//https://github.com/libarchive/libarchive/wiki/Examples#A_Basic_Write_Example
void write_archive(const char *outname, char **filename, int nFiles) {
  struct archive *a;
  struct archive_entry *entry;
  struct stat st;
  int statErr;
  char buff[8192];
  int len;
  int fd;
  
  printf("Writing outname='%s'\n\n",outname);
  
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
    printf("statErr=%i\n\n", statErr);
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


int main(int argc, char** argv){
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

  
  //write_archive("test.tgz",filesToCompress,numStrings);
  write_archive("test.zip",filesToCompress,numStrings);

  free(filesToCompress[0]);
  free(filesToCompress[1]);
  free(filesToCompress[2]);
  free(filesToCompress);
}
