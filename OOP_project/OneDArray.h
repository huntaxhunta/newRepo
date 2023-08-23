/*
 * OneDArray.h
 *
 *  Created on: 2023年8月18日
 *      Author: jin
 */

#ifndef ONEDARRAY_H_
#define ONEDARRAY_H_

const int DECLARED_SIZE = 10;

class OneDArray {
private:
	int numberUsed;
	int target;
	int array[];
public:
	void fillArray();
	int search();
	void output(int);

};

void OneDArray::fillArray(){
	cout << "Enter up to " << DECLARED_SIZE << " nonnegative integers.\n"
	      << "Mark the end of the list with a negative number.\n";
	int next, index = 0;
	    cin >> next;
	    while ((next >= 0) && (index < DECLARED_SIZE))
	    {
	        array[index] = next;
	        index++;
	        cin >> next;
	    }

	    numberUsed = index;

}

int OneDArray::search()
{
	cout << "Enter a number to search for: ";
	cin >> target;
    int index = 0;
    bool found = false;

    for(int i = 0; i < numberUsed; i++){
    	if(array[i] == target){
    		index = i;
    		found = true;
    	}
    }
    if (found)
        return index;
    else
        return -1;
}

void OneDArray::output(int result){
	if (result == -1)
		cout << target << " is not on the list.\n";
	else{
		cout << target << " is stored in array position " << result << endl << "(Remember: The first position is 0.)\n";
	}

}


#endif /* ONEDARRAY_H_ */
