#ifndef RUTINAS_SEMANTICAS_H_INCLUDED
#define RUTINAS_SEMANTICAS_H_INCLUDED
#include <string.h>

typedef struct{

char value[100][100];
char type[100][100];
int length;

}map;

typedef struct{
    char name[100];
    char type[100][100];
    int length;

}fInfo;

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
    printf("Tipo: %s\n\n",m.type[i]);
}


}

void reportFunction(fInfo funciones[100],int funcioneslen){

    for(int i = 0;i < funcioneslen;i++ ){
        printf("Funcion: %s\n",funciones[i].name);
        int j = 0;
        while(j<funciones[i].length){
            printf("Recibe: %s\n",funciones[i].type[j]);
            j++;
        }
        printf("Devuelve: %s\n\n",funciones[i].type[j]);
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
