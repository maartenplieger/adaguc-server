#include "CDirReader.h"
#include "CDebugger.h"

DEF_ERRORMAIN ()

int main(){
  
  CDirReader::test_makeCleanPath();
  CDirReader::test_compareLists();

  /* Test + operator of CT::string */
  try {
    CT::string a = "teststring_a";
    if (!a.equals("teststring_a")) throw __LINE__;
    CT::string c = a + "b";
    if (!a.equals("teststring_a")) throw __LINE__;
    if (!c.equals("teststring_ab")) throw __LINE__;
    a+="bc";
    if (!a.equals("teststring_abc")) throw __LINE__;
    a+=CT::string("d") + "e";
    if (!a.equals("teststring_abcde")) throw __LINE__;
    CT::string b = "f";
    if (!a.equals("teststring_abcde")) throw __LINE__;
    CT::string d = a + b;
    if (!a.equals("teststring_abcde")) throw __LINE__;
  }catch(int e) {
    CDBError("Error at line %d", e);
  }

  /* Test isNumeric and isFloat of CT::string */
  try{
    if (CT::string("20.5").isNumeric()) throw __LINE__;
    if (CT::string("20.0").isNumeric()) throw __LINE__;
    if (!CT::string("20").isNumeric()) throw __LINE__;
    if (!CT::string("21").isNumeric()) throw __LINE__;

    if (!CT::string("20.5").isFloat()) throw __LINE__;
    if (!CT::string("20.0").isFloat()) throw __LINE__;
    if (!CT::string("20").isFloat()) throw __LINE__;
    if (!CT::string("21").isFloat()) throw __LINE__;
  }catch(int e){
    CDBError("Error at line %d", e);
  }

  return 0;
}
