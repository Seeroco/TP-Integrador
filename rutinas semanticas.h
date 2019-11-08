#ifndef RUTINAS_SEMANTICAS_H_INCLUDED
#define RUTINAS_SEMANTICAS_H_INCLUDED
#include <string.h>

typedef struct{

char value[100][100];
char type[100][100];
int length;

}map;
int yaDeclarado(char identificadorNuevo[100], map listaID){

    int b = 0;
    for(int i = 0; i< listaID.length; i++){

        if(!strcmp(identificadorNuevo,listaID.value[i])){
            b = 1;
        }

    }
    return b;
}
void reportMap(map m,char valueName[100]){

for(int i = 0; i<m.length; i++){
    printf("%s%s\n",valueName,m.value[i]);
    printf("Tipo: %s\n",m.type[i]);
}


}


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

void checkType(char tipo1[100], char tipo2[100]){

    if(strchr(tipo1,'*')||strchr(tipo2,'*')){
        printf("Tipos incompatibles en operaciones binarias\n");
    }

}

#endif // RUTINAS_SEMANTICAS_H_INCLUDED
