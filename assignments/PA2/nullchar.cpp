# include <iostream>
# include <fstream>

using namespace std;

int main(){
    fstream f;
    f.open("nullchartest.txt");
    char buf[] = "\"te\0st\"\n\0";

    // cout<<buf<<endl;
    f.write(buf, sizeof(buf));
    char bu[] = "";
    f.write(bu, sizeof(bu));
    f.close();
    return 0;
}