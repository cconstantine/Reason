#include <stdio.h>
#include <iostream>


extern "C" {

  int say_str (std::string s)
  {
    std::cout << s << std::endl;
    return 1;
  }

  int say_cstr(char* s)
  {
    return printf("%s\n", s);
  }
      

  int print_int(unsigned int i)
  {
    return printf("%d\n", i);
  }
}
