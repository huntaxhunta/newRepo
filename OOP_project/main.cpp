//Searches a partially filled array of nonnegative integers.
#include <iostream>

using namespace std;

#include "OneDArray.h"

int main( )
{
    OneDArray arr;
    arr.fillArray();
    int result = arr.search();
    arr.output(result);
    return 0;
}

