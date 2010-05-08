#include <stdio.h>
#include <iostream>


extern "C" {

  int say (std::string s)
  {
    std::cout << s << std::endl;
    return 1;
  }

  int print_int(unsigned int i)
  {
    return printf("%d\n", i);
  }
}
