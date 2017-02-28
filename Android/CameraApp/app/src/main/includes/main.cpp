#include <iostream>
#include "myconvert.hpp"



int main(int argc, const char * argv[]) {
    wstring s = L"17";
    
    int val = convertStringToInteger(s);
    std::cout << "Hello, World! " << val << endl;
    return 0;
}
