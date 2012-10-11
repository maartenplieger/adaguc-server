#include "CXMLSerializerInterface.h"
const char * CXMLSerializerInterface::className="CXMLSerializerInterface";
void CXMLObjectInterface::addElement(CXMLObjectInterface *baseClass,int rc, const char *name,const char *value){
  CXMLSerializerInterface * base = (CXMLSerializerInterface*)baseClass;
  base->currentNode=(CXMLObjectInterface*)this;
  if(rc==0)if(value!=NULL)this->value.copy(value);
}

int parseInt(const char *pszValue){
  if(pszValue==NULL)return 0;
  int dValue=atoi(pszValue);
  return dValue;  
}

float parseFloat(const char *pszValue){
  if(pszValue==NULL)return 0;
  float fValue=(float)atof(pszValue);
  return fValue;  
}

double parseDouble(const char *pszValue){
  if(pszValue==NULL)return 0;
  double fValue=(double)atof(pszValue);
  return fValue;  
}
