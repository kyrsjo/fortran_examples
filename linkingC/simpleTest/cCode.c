#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef UNDERSCORE
  void test_void_(){
#endif
#ifndef UNDERSCORE
  void test_void(){
#endif
    printf("test_void\n");
}


#ifdef UNDERSCORE
  void test_void_int_(int* i){
#endif
#ifndef UNDERSCORE
  void test_void_int(int* i){
#endif
    printf("test_void_int: i=%i\n",*i);
}

#ifdef UNDERSCORE
  void test_void_float_(float* a){
#endif
#ifndef UNDERSCORE
  void test_void_float(float* a){
#endif
    printf("test_void_float: a=%g\n",*a);
}

#ifdef UNDERSCORE
  void test_void_double_(double* a){
#endif
#ifndef UNDERSCORE
  void test_void_double(double* a){
#endif
    printf("test_void_double: a=%g\n",*a);
}

  
#ifdef UNDERSCORE
double test_double_double_(double* a){
#endif
#ifndef UNDERSCORE
double test_double_double(double* a){
#endif
  printf("test_void_double: a=%g, returning=%g\n",*a,(*a)*2);
  return (*a)*2;
}

#ifdef UNDERSCORE
void test_void_string_(char* str, int strlen){
#endif
#ifndef UNDERSCORE
void test_void_string(char* str, int strlen){
#endif
  //Make sure to zero-terminate the string!
  char* str2 = malloc((strlen+1)*sizeof(char));
  strncpy(str2,str,strlen);
  str2[strlen]=0;
  
  printf("test_void_string, str='%s', strlen=%i\n",str2,strlen);

  free(str2);
}

//Note: The names of functions to call from Frotran
//gets converted to lowercase when linking,
//so don't call the function stringArray etc.
#ifdef UNDERSCORE
 void test_void_stringarray_(char* str, int* arraylen, int strlen){
#endif
#ifndef UNDERSCORE
  void test_void_stringarray(char* str, int* arraylen,int strlen){
#endif
  printf("test_void_stringArray, strlen=%i, arraylen=%i\n",strlen,*arraylen);
  for (int i=0;i<(*arraylen);i++){
    //Make sure to zero-terminate the string!
    char* str2 = malloc((strlen+1)*sizeof(char));
    strncpy(str2,&str[strlen*i],strlen);
    str2[strlen]=0;
    
    printf("test_void_stringArray, str='%s', strlen=%i\n",str2,strlen);
    
    free(str2);
  }
  
}
