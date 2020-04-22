use <transforms.scad>
use <constants.scad>
use <shapes.scad>
use <PerfilesASK_1_0.scad>
use <UtilidadesPerfiles.scad>
x=0;
//ALA
//Buscar(4); x=1;
//Catalogo(); x=1;
$NumeroDeSecciones=1; //Numero de secciones de perfil, conicidad o diedro distintos
$Perfil=["NACA2415"]; //Nombre del perfil incluido en el archivo PerfilesASK_1_0, para ver todos los perfiles disponibles ejecuta Catalogo() quitando los comentarios de la linea anterior o ejecuta Buscar() y elije un numero entre 1 y 570;
$Envergadura=3500;
$Cuerda=[470]; //Cuerda en mm
$Diedro=[2]; //Angulo diedro en º
$Torcimiento=[1.0]; //Angulo de torcimiento del ala en º
$Flechado=[5]; //Angulo de flechado del ala en º, 
$Conicidad=[0.9]; //Relacion entre la cuerda de punta y la cuerda de raiz conicidad=cuerda de punta / cuerda de raiz 
$PosicionAla=[0,50]; //Posicion relativa del ala respecto al centro de gravedad (mm)
$Alerones=[0.3,0.66,0.301]; //Tamaño de los alerones [ancho %Cuerda, largo %Envergadura, Posicion %Envergadura] [0,x,x] no hay alerones
$Flaps=[0.0,0.5,0.0]; //Tamaño de los flaps [ancho %Cuerda, largo %Envergadura, Posicion %Envergadura], si se deja en [0,x,x] no hay flaps


//Empenaje

$TipoEmpenaje="Convencional"; //Configuracion del empenaje "T", "Convencional", "Medio", "V", "VInvertida","H"
$PerfilEV="NACA0012"; //Perfil del Empenaje Vertical
$PerfilEH="NACA0012"; //Perfil del Empenaje Horizontal
$CuerdaEV=350; //Cuerda del Empenaje Vertical
$CuerdaEH=250; //Cuerda del Empenaje Horizontal
$EnvergaduraEV=450; //Envergadura del Empenaje Vertical
$EnvergaduraEH=600; //Envergadura del Empenaje Horizontal
$ConicidadEV=.5; //Relacion entre la cuerda raiz y la cuerda de punta del empenaje vertical
$ConicidadEH=0.9; //Relacion entre la cuerda raiz y la cuerda de punta del empenaje horizontal
$Timon=0.2; //Porcentaje de la cuerda del empenaje vertical usado como Timon
$Elevador=0.25; //Porcentaje de la cuerda del empenaje horizontal usado como elevador
$VAngulo=60; //Angulo del empenaje en V y V invertida
$PosicionEH=[100,0]; //Posicion en mm del empenaje horizontal en el empenaje medio o H [x, z], Posicion del empenaje convencional y T [x,0]


//Avion
$Tipo="Entrenador"; //Tipo de avion: Entrenador, Acrobatico, Planeador, Carga, Fotografia_Aerea.  
$Incidencia=3; //Angulo de incidencia (Angulo entre la cuerda del ala y la cuerda del empenaje
$PosicionE=[$Cuerda[0]*2.5,-50]; //Posicion relativa del empenaje con respecto al centro de gravedad [Longitud, Altura]

//Fuselaje
$Dimenciones=[$Cuerda[0]*3.5,150,200];
$TipoF="Caja";
//
if(!x){
    //Dibujar Ala
    translate([$PosicionAla[0]-$Cuerda[0]*0.25,0,$PosicionAla[1]]) rotate([0,$Incidencia,0]) Ala($NumeroDeSecciones, $Perfil, $Envergadura, $Cuerda, $Diedro, $Torcimiento, $Flechado, $Conicidad, $PosicionAla, $Alerones, $Flaps);
    //Dibujar Empenaje
    Empenaje($TipoEmpenaje, $PerfilEV, $PerfilEH, $CuerdaEV, $CuerdaEH, $EnvergaduraEV, $EnvergaduraEH, $PosicionE, $ConicidadEV, $ConicidadEH, $VAngulo, $PosicionEH, $Timon, $Elevador);
    //Dibujar Fuselaje
    Fuselaje($Dimenciones, $PosicionAla, $Tipo, $TipoF, $Cuerda[0], $PosicionE, $CuerdaEH, $Incidencia);
}



//MODULOS

//Para dibujar el ala 
module Ala(NumeroDeSecciones=1, Perfil=["NACA2415","NACA0012"], Envergadura=1000, Cuerda=[200], Diedro=[3], Torcimiento=[0], Flechado=[0], Conicidad=[1], PosicionAla=0, Alerones=[20,400,0.7], Flaps=[90,300,0]){
    
    mirror([0,1,0]) rotate([90,0,0]) semiAla();
    rotate([90,0,0]) semiAla();
    
    module semiAla(){
        difference(){
            chain_hull() {
                rotate([-Diedro[0],0,0]) linear_extrude(height = 0.1, center = true, convexity = 10, twist = 0, scale=1) Perfil(Perfil[0], Cuerda[0]);
                translate([Envergadura*tan(Flechado[0])/2,Envergadura*tan(Diedro[0])/2,Envergadura/2]) rotate([-Diedro[0],0,Torcimiento[0]]) scale(Conicidad[0]) linear_extrude(height = 0.1, center = true, convexity = 10, twist = 0, scale=1)  Perfil(Perfil[0], Cuerda[0]);
            } 
            //Alerones
            rotate([-Diedro[0],90-atan2(Cuerda[0]*(1-Conicidad[0]),Envergadura/2)+Flechado[0],Torcimiento[0]]) translate([-Envergadura*Alerones[2]/2,-0.1*Cuerda[0],(1-Alerones[0])*Cuerda[0]]) linear_extrude(height = Alerones[1]*Envergadura/2, center = false, convexity = 10) polygon(points=[[0,0],[0,0.2*Cuerda[0]],[2,0.2*Cuerda[0]],[2,0]]);         
            rotate([-Diedro[0],-atan2(Cuerda[0]*(1-Conicidad[0]),Envergadura/2)+Flechado[0],-Torcimiento[0]]) translate([(1-Alerones[0])*Cuerda[0],0,Envergadura*Alerones[2]/2]) linear_extrude(height = Alerones[1]*Envergadura/2, center = false, convexity = 10) polygon(points=[[0,0],[0,Cuerda[0]],[0.1*Cuerda[0],Cuerda[0]]]);
            rotate([-Diedro[0],90-atan2(Cuerda[0]*(1-Conicidad[0]),Envergadura/2)+Flechado[0],Torcimiento[0]]) translate([-Alerones[1]*Envergadura/2-Envergadura*Alerones[2]/2,-0.1*Cuerda[0],(1-Alerones[0])*Cuerda[0]]) linear_extrude(height = Alerones[1]*Envergadura/2, center = false, convexity = 10) polygon(points=[[0,0],[0,0.2*Cuerda[0]],[2,0.2*Cuerda[0]],[2,0]]);
            //Flaps
            if(Envergadura*Alerones[2]/2>Flaps[1]*Envergadura/2+Envergadura*Flaps[2]/2){
                rotate([-Diedro[0],90-atan2(Cuerda[0]*(1-Conicidad[0]),Envergadura/2),Torcimiento[0]]) translate([-Envergadura*Flaps[2]/2,-0.1*Cuerda[0],(1-Flaps[0])*Cuerda[0]]) linear_extrude(height = Flaps[1]*Envergadura/2, center = false, convexity = 10) polygon(points=[[0,0],[0,0.2*Cuerda[0]],[2,0.2*Cuerda[0]],[2,0]]);         
                rotate([-Diedro[0],-atan2(Cuerda[0]*(1-Conicidad[0]),Envergadura/2),-Torcimiento[0]]) translate([(1-Flaps[0])*Cuerda[0],0,Envergadura*Flaps[2]/2]) linear_extrude(height = Flaps[1]*Envergadura/2, center = false, convexity = 10) polygon(points=[[0,0],[0,Cuerda[0]],[0.1*Cuerda[0],Cuerda[0]]]);
                rotate([-Diedro[0],90-atan2(Cuerda[0]*(1-Conicidad[0]),Envergadura/2),Torcimiento[0]]) translate([-Flaps[1]*Envergadura/2-Envergadura*Flaps[2]/2,-0.1*Cuerda[0],(1-Flaps[0])*Cuerda[0]]) linear_extrude(height = Flaps[1]*Envergadura/2, center = false, convexity = 10) polygon(points=[[0,0],[0,0.2*Cuerda[0]],[2,0.2*Cuerda[0]],[2,0]]); 
            }
        }
        //Puntas de ala
        chain_hull() {
            translate([Envergadura*tan(Flechado[0])/2,Envergadura*tan(Diedro[len(Diedro)-1])/2,Envergadura/2]) rotate([-Diedro[len(Diedro)-1],0,Torcimiento[0]]) scale(Conicidad[0]) linear_extrude(height = 0.1, center = true, convexity = 10, twist = 0, scale=1)  Perfil(Perfil[0], Cuerda[0]);
            translate([((Cuerda[0]*0.1)+Envergadura)*tan(Flechado[0])/2,((Cuerda[0])+Envergadura)*tan(Diedro[len(Diedro)-1])/2,(Cuerda[0]*0.05)+Envergadura/2]) rotate([40,0,Torcimiento[0]]) scale(Conicidad[0]) linear_extrude(height = 0.1, center = true, convexity = 10, twist = 0, scale=1) Perfil(Perfil[0], Cuerda[0]);
        }
    }
}

//Para dibujar el empenaje
module Empenaje(TipoEmpenaje="T", PerfilEV="NACA0012", PerfilEH="NACA0012", CuerdaEV=20, CuerdaEH=10, EnvergaduraEV=15, EnvergaduraEH=40, PosicionE=[100,10], ConicidadEV=0.5, ConicidadEH=1, VAngulo=60, PosicionEH=[-0.2,0], Timon=0.2, Elevador=0.3){
    
    if(TipoEmpenaje == "T"){
        difference(){    
            //Empenaje Vertical
            translate([PosicionE[0],0,PosicionE[1]]) Seccion(PerfilEV, CuerdaEV, EnvergaduraEV, ConicidadEV) Perfil(PerfilEV, CuerdaEV);
            //Timon
            translate([PosicionE[0]+(1-Timon)*CuerdaEV,0,PosicionE[1]]) rotate([0,0,0]) linear_extrude(height = EnvergaduraEV*1.05, center = false, convexity = 10) polygon(points=[[0,0],[0,CuerdaEV],[0.5*CuerdaEV,CuerdaEV]]);
            mirror([0,1,0]) translate([PosicionE[0]+(1-Timon)*CuerdaEV,0,PosicionE[1]]) rotate([0,0,0]) linear_extrude(height = EnvergaduraEV*1.05, center = false, convexity = 10) polygon(points=[[0,0],[0,CuerdaEV],[0.5*CuerdaEV,CuerdaEV]]);
            //Espacio para movimiento del elevador
            mirror([0,0,1]) difference(){
                    translate([PosicionE[0]+(1-ConicidadEV)*CuerdaEV+(1-Elevador)*CuerdaEH,0,-PosicionE[1]-EnvergaduraEV]) rotate([90,0,0]) cylinder(h=0.2*CuerdaEV, r=Elevador*CuerdaEH*1.1, center=true);
                    translate([PosicionE[0]+(1-ConicidadEV)*CuerdaEV+(1-Elevador)*CuerdaEH,0,-PosicionE[1]-EnvergaduraEV+tan(33.5)*CuerdaEH]) rotate([0,65,0]) cube([1.1*CuerdaEH,0.22*CuerdaEV,3*CuerdaEH], center=true);
                }
        }
        difference(){    
            //Empenaje Horizontal
            union(){
                translate([PosicionEH[0]+PosicionE[0]+(1-ConicidadEV)*CuerdaEV,0,PosicionE[1]+EnvergaduraEV]) rotate([90,0,0]) Seccion(PerfilEH, CuerdaEH, EnvergaduraEH/2, ConicidadEH) Perfil(PerfilEH, CuerdaEH);
                mirror([0,1,0]) translate([PosicionE[0]+(1-ConicidadEV)*CuerdaEV,0,PosicionE[1]+EnvergaduraEV]) rotate([90,0,0]) Seccion(PerfilEH, CuerdaEH, EnvergaduraEH/2, ConicidadEH) Perfil(PerfilEH, CuerdaEH);
            }
            //Elevador
            translate([PosicionEH[0]+PosicionE[0]+(1-ConicidadEV)*CuerdaEV+(1-Elevador)*CuerdaEH,0,PosicionE[1]+EnvergaduraEV]) rotate([90,0,0]) linear_extrude(height = EnvergaduraEH*1.05, center = true, convexity = 10) polygon(points=[[0,0],[0,CuerdaEH],[0.5*CuerdaEH,CuerdaEH]]);
        translate([PosicionEH[0]+PosicionE[0]+(1-ConicidadEV)*CuerdaEV+(1-Elevador)*CuerdaEH,0,PosicionE[1]+EnvergaduraEV]) mirror([0,0,1]) rotate([90,0,0]) linear_extrude(height = EnvergaduraEH*1.05, center = true, convexity = 10) polygon(points=[[0,0],[0,CuerdaEH],[0.5*CuerdaEH,CuerdaEH]]);
        }
    }
    
    if(TipoEmpenaje=="Convencional"){
        //Empenaje Vertical
        difference(){    
            translate([PosicionE[0],0,PosicionE[1]]) Seccion(PerfilEV, CuerdaEV, EnvergaduraEV, ConicidadEV) Perfil(PerfilEV, CuerdaEV);
            //Timon
            translate([PosicionE[0]+(1-Timon)*CuerdaEV,0,PosicionE[1]]) rotate([0,0,0]) linear_extrude(height = EnvergaduraEV*1.05, center = false, convexity = 10) polygon(points=[[0,0],[0,CuerdaEV],[0.5*CuerdaEV,CuerdaEV]]);
            mirror([0,1,0]) translate([PosicionE[0]+(1-Timon)*CuerdaEV,0,PosicionE[1]]) rotate([0,0,0]) linear_extrude(height = EnvergaduraEV*1.05, center = false, convexity = 10) polygon(points=[[0,0],[0,CuerdaEV],[0.5*CuerdaEV,CuerdaEV]]);
            //Espacio para movimiento del elevador
            difference(){
                translate([PosicionEH[0]+PosicionE[0]+(1-Elevador)*CuerdaEH,0,PosicionE[1]]) rotate([90,0,0]) cylinder(h=0.22*CuerdaEV, r=Elevador*CuerdaEH*1.1, center=true);
                translate([PosicionEH[0]+PosicionE[0]+(1-Elevador)*CuerdaEH,0,PosicionE[1]+tan(30.8)*CuerdaEH]) rotate([0,65,0]) cube([CuerdaEH,0.2*CuerdaEV,3*CuerdaEH], center=true);
            }
        }
        //Empenaje Horizontal
        difference(){  
            union(){
                translate([PosicionEH[0]+PosicionE[0],0,PosicionE[1]]) rotate([90,0,0]) Seccion(PerfilEH, CuerdaEH, EnvergaduraEH/2, ConicidadEH) Perfil(PerfilEH, CuerdaEH);
                mirror([0,1,0]) translate([PosicionEH[0]+PosicionE[0],0,PosicionE[1]]) rotate([90,0,0]) Seccion(PerfilEH, CuerdaEH, EnvergaduraEH/2, ConicidadEH) Perfil(PerfilEH, CuerdaEH);
            }
            //Elevador
            translate([PosicionEH[0]+PosicionE[0]+(1-Elevador)*CuerdaEH,0,PosicionE[1]]) rotate([90,0,0]) linear_extrude(height = EnvergaduraEH*1.05, center = true, convexity = 10) polygon(points=[[0,0],[0,CuerdaEH],[0.5*CuerdaEH,CuerdaEH]]);
            mirror([0,0,1]) translate([PosicionEH[0]+PosicionE[0]+(1-Elevador)*CuerdaEH,0,-PosicionE[1]]) rotate([90,0,0]) linear_extrude(height = EnvergaduraEH*1.05, center = true, convexity = 10) polygon(points=[[0,0],[0,CuerdaEH],[0.5*CuerdaEH,CuerdaEH]]);            
        }
    }
    
    if(TipoEmpenaje=="Medio"){
        translate([PosicionE[0],0,PosicionE[1]]) Seccion(PerfilEV, CuerdaEV, EnvergaduraEV, ConicidadEV) Perfil(PerfilEV, CuerdaEV);
        translate([PosicionE[0]+(1-ConicidadEV-0.2)*CuerdaEV+PosicionEV[0],0,PosicionE[1]+EnvergaduraEV/2+PosicionEV[1]]) rotate([90,0,0]) Seccion(PerfilEH, CuerdaEH/0.9, EnvergaduraEH/2, ConicidadEH*0.7) Perfil(PerfilEH, CuerdaEH);
        mirror([0,1,0]) translate([PosicionE[0]+(1-ConicidadEV-0.2)*CuerdaEV+PosicionEV[0],0,PosicionE[1]+EnvergaduraEV/2+PosicionEV[1]]) rotate([90,0,0]) Seccion(PerfilEH, CuerdaEH/0.9, EnvergaduraEH/2, ConicidadEH*0.7) Perfil(PerfilEH, CuerdaEH);
    }
    
    if(TipoEmpenaje=="V"){
        translate([PosicionE[0],0,PosicionE[1]]) rotate([VAngulo,0,0]) Seccion(PerfilEH, CuerdaEH, EnvergaduraEH/2, ConicidadEH) Perfil(PerfilEH, CuerdaEH);
        mirror([0,1,0]) translate([PosicionE[0],0,PosicionE[1]]) rotate([VAngulo,0,0]) Seccion(PerfilEH, CuerdaEH, EnvergaduraEH/2, ConicidadEH) Perfil(PerfilEH, CuerdaEH);
    }
    
    if(TipoEmpenaje=="VInvertida"){
        translate([PosicionE[0],0,PosicionE[1]]) rotate([180-VAngulo,0,0]) Seccion(PerfilEH, CuerdaEH, EnvergaduraEH/2, ConicidadEH) Perfil(PerfilEH, CuerdaEH);
        mirror([0,1,0]) translate([PosicionE[0],0,PosicionE[1]]) rotate([180-VAngulo,0,0]) Seccion(PerfilEH, CuerdaEH, EnvergaduraEH/2, ConicidadEH) Perfil(PerfilEH, CuerdaEH);
    }
    
    if(TipoEmpenaje=="H"){
        translate([PosicionE[0],EnvergaduraEH/2,PosicionE[1]]) Seccion(PerfilEV, CuerdaEV, EnvergaduraEV, ConicidadEV) Perfil(PerfilEV, CuerdaEV);
        mirror([0,1,0]) translate([PosicionE[0],EnvergaduraEH/2,PosicionE[1]]) Seccion(PerfilEV, CuerdaEV, EnvergaduraEV, ConicidadEV) Perfil(PerfilEV, CuerdaEV);
        translate([PosicionE[0]+(1-ConicidadEV-0.2)*CuerdaEV+PosicionEV[0],0,PosicionE[1]+EnvergaduraEV/2+PosicionEV[1]]) rotate([90,0,0]) Seccion(PerfilEH, CuerdaEH, EnvergaduraEH/2, ConicidadEH) Perfil(PerfilEH, CuerdaEH);
        mirror([0,1,0]) translate([PosicionE[0]+(1-ConicidadEV-0.2)*CuerdaEV+PosicionEV[0],0,PosicionE[1]+EnvergaduraEV/2+PosicionEV[1]]) rotate([90,0,0]) Seccion(PerfilEH, CuerdaEH, EnvergaduraEH/2, ConicidadEH) Perfil(PerfilEH, CuerdaEH);
    }
}
module Seccion(Perfil, Cuerda, Envergadura, Conicidad){
    chain_hull() {
        translate([0,0,0]) rotate([0,0,0]) linear_extrude(height = 0.1, center = true, convexity = 10, twist = 0) NACA0012(Cuerda);
        translate([(1-Conicidad)*Cuerda,0,Envergadura]) rotate([0,0,0]) linear_extrude(height = 0.1, center = true, convexity = 10, twist = 0) scale(Conicidad)  children();
    }
}

module Fuselaje(Dimenciones=[1000,100,200], PosicionAla=[400,0], Tipo="Entrenador", TipoF="Caja", Cuerda=200, PosicionE=[500,0], CuerdaEH=200, Incidencia=2){
    if(Tipo=="Entrenador"){
        chain_hull() {
            translate([-Dimenciones[0]/3,0,-PosicionAla[1]-Dimenciones[2]*0.4/2]) rotate([0,0,0]) Cuaderna(Dimenciones=[1,Dimenciones[1]*.8,Dimenciones[2]*.5], R=10);
            translate([-Dimenciones[0]*0.2,0,-PosicionAla[1]-Dimenciones[2]*0.4/2]) rotate([0,0,0]) Cuaderna(Dimenciones=[1,Dimenciones[1],Dimenciones[2]*0.6], R=10);
            translate([-Cuerda*0.25,0,-PosicionAla[1]]) rotate([0,0,0]) Cuaderna(Dimenciones=[1,Dimenciones[1],Dimenciones[2]], R=10);
            translate([Cuerda*0.76,0,-PosicionAla[1]-Cuerda*sin(Incidencia)/2]) rotate([0,0,0]) Cuaderna(Dimenciones=[1,Dimenciones[1],Dimenciones[2]-Cuerda*sin(Incidencia)], R=10);
            translate([Cuerda*1.3,0,-PosicionAla[1]-Dimenciones[2]*0.3/2]) rotate([0,0,0]) Cuaderna(Dimenciones=[1,Dimenciones[1]*0.8,Dimenciones[2]*0.6], R=10);
            translate([PosicionE[0]+CuerdaEH*3/4,0,PosicionE[1]]) rotate([0,0,0]) Cuaderna(Dimenciones=[1,Dimenciones[1]*0.2,Dimenciones[2]*0.1], R=4);
        }
    }
    if(Tipo=="Acrobatico"){
        
    }
    if(Tipo=="Planeador"){
        
    }
    if(Tipo=="Carga"){
        
    }
    if(Tipo=="Fotografia_Aerea"){
        
    }
}

module Cuaderna(Dimenciones=[1,100,200], R=10){
    difference(){ 
        cube(Dimenciones, center=true);
        difference(){   
            cube(Dimenciones*1.01, center=true);
            translate([0,(Dimenciones[1]/2)-R,(Dimenciones[2]/2)-R]) rotate([0,90,0]) cylinder(h=Dimenciones[0]*1.1, r=R, center=true);
            translate([0,-((Dimenciones[1]/2)-R),((Dimenciones[2]/2)-R)]) rotate([0,90,0]) cylinder(h=Dimenciones[0]*1.1, r=R, center=true);
            translate([0,(Dimenciones[1]/2)-R,-((Dimenciones[2]/2)-R)]) rotate([0,90,0]) cylinder(h=Dimenciones[0]*1.1, r=R, center=true);
            translate([0,-((Dimenciones[1]/2)-R),-((Dimenciones[2]/2)-R)]) rotate([0,90,0]) cylinder(h=Dimenciones[0]*1.1, r=R, center=true);
            cube([1.2,Dimenciones[1]-2*R,Dimenciones[2]], center=true);
            cube([1.2,Dimenciones[1],Dimenciones[2]-2*R], center=true);    
        } 
    }
}




