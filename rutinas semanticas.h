#ifndef RUTINAS_SEMANTICAS_H_INCLUDED
#define RUTINAS_SEMANTICAS_H_INCLUDED
#include <string.h>
float opRelacional(float t1,char op[50], float t2){

    if(!strcmp(op,">")){

        return t1>t2;
    }
    else if(!strcmp(op,"<")){

        return t1<t2;
    }
    else if(!strcmp(op,">=")){

        return t1>=t2;
    }
    else if(!strcmp(op,"<=")){

        return t1<=t2;
    }
    printf("Operador incorrecto");
    return 0;
}


#endif // RUTINAS_SEMANTICAS_H_INCLUDED
