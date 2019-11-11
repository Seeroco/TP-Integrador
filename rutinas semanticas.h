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
int existsMap(char idname[100], map identificadores){

    for(int i = 0; i<identificadores.length;i++){
        if(!strcmp(idname,identificadores.value[i])){
            return 1;
        }
    }
    return 0;
}
void getMap(char idname[100],map identificadores,char tipo[100]){
    int key = existsMap(idname,identificadores);
    if(key){
        for(int i = 0; i<identificadores.length;i++){
            if(!strcmp(idname,identificadores.value[i])){
                strcpy(tipo,identificadores.type[i]);
            }
        }
    }

}
void removePointer(char tipo[100], int p){
    char s[100];

    if(p){
        int i = 0;
        while(i<strlen(tipo)-1){
            s[i] = tipo[i];
            i++;
        }
        s[i] = '\0';
        strcpy(tipo,s);
    }

}
int chequearTipos(char tipo1[100], char tipo2[100]){
    if(!strcmp(tipo2,"IDSOLO")){
        return 1;
    }
    else if(!strcmp(tipo1,"float")|| !strcmp(tipo1,"double")){

        if(!strcmp(tipo2,"int")||strcmp(tipo2,"char")|| !strcmp(tipo2,"double") || !strcmp(tipo2,"float") || !strcmp(tipo2,"long") || !strcmp(tipo2,"short")){
            return 1;
        }
        else{
            return 0;
        }

    }
    else if(!strcmp(tipo1,"char*")){
        return !strcmp(tipo1,tipo2);
    }
    else if(!strcmp(tipo1,"int")|| !strcmp(tipo1,"long") || !strcmp(tipo1,"short")|| !strcmp(tipo1,"char")){
        if(!strcmp(tipo2,"int")|| !strcmp(tipo2,"short") || !strcmp(tipo2,"long") || !strcmp(tipo2,"char")){
            return 1;
        }
        else{
            return 0;
        }
    }
    return 0;
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
