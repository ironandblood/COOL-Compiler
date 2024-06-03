# include <iostream>
# include <fstream>

using namespace std;

int main(){
    ofstream os;
    os.open("longchar.txt");
    string s="\"";
    for (int i=0;i<1025;i++){
        s.push_back(char('a'+rand()%26));
        // if (i == 1024) s.push_back("\"");
    }
    // s[0]="\"";s[9999] = "\"";

    os<<s;
    return 0;
}