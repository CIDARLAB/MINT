    /*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar ufgrammer;

netlist 
    :   header 
        flowBlock 
        controlBlock? 
        EOF
    ;

header  
    :   (tag='3D')? 'DEVICE' ufname  
    ;

flowBlock 	
	:   'LAYER FLOW' (s=flowStat)+ 'END LAYER' 
	;

flowStat 	
	:	portStat
        |       portBankStat
	|	channelStat
	|	nodeStat
	|	cellTrapStat
        |       cellTrapBankStat
	|	logicArrayStat
	|	muxStat
        |       treeStat
	|	setCoordStat
        |       mixerStat
        |       gradGenStat
        |       rotaryStat
        |       dropletGenStat
        |       valve3DStat
        |       viaStat
        |       transposerStat
        ;

controlBlock
    :   'LAYER CONTROL'
        (s=controlStat)+ 
        'END LAYER'
               
    ;

controlStat 
	:	portStat
        |       portBankStat
	|	channelStat
	|	nodeStat
	|	valveStat
	|	setCoordStat
        |       netStat
	;


//Flow Statements

portStat
    :   'PORT' ufnames ('r''='r=INT)';'
    ;


    
portBankStat
    :   o='V' 'BANK' ufname 'of' n=INT 'PORT'  'r''='r=INT 'dir''='dir=('RIGHT'|'LEFT') 'spacing''='spacing=INT 'channelWidth''='fw=INT ';'
    ;
channelStat
    :   'CHANNEL' ufname 'from' component1=ID port1=INT 'to' component2=ID port2=INT 'w''='w=INT';'
    ;
nodeStat
    :   'NODE' ufnames ';'
    ;
cellTrapStat
    :   'SQUARE CELL TRAP' ufnames 'chamberWidth''='i2=INT 'chamberLength''='i1=INT 'channelWidth''='i0=INT';'
    |   orientation=('V'|'H') 'LONG CELL TRAP' ufnames  'numChambers''='i4=INT 'chamberWidth''='i2=INT 'chamberLength''='i1=INT  'chamberSpacing''='i3=INT 'channelWidth''='i0=INT';'
    ;
cellTrapBankStat
    :   o=('V'|'H') 'BANK' ufname 'of' n=INT 'CELL TRAP'  'numChambers''='i4=INT 'chamberWidth''='i2=INT 'chamberLength''='i1=INT  'chamberSpacing''='i3=INT 'spacing''='spacing=INT 'channelWidth''='i0=INT';'
    ;
logicArrayStat
    :   'LOGIC ARRAY' ufname 'flowChannelWidth''=' cw1=INT 'controlChannelWidth''=' cw2=INT 'chamberLength''='i1=INT 'chamberWidth''='i2=INT 'r''='i3=INT ';'
    ;
muxStat
    :   orientation=('V'|'H') 'MIXER' ufname 'numBends''=' n=INT 'bendSpacing''=' bd=INT 'bendLength''=' bl=INT 'channelWidth''=' cw=INT ';'
    ;
treeStat
    :   orientation=('V'|'H') 'TREE' ufname n1=INT 'to' n2=INT 'spacing''='spacing=INT 'flowChannelWidth''=' cw1=INT ';'
    ;
setCoordStat
    :   ufname ('SET X' x=INT) ('SET Y' y=INT) ';'
    ;
mixerStat
    :   orientation=('V'|'H') 'MIXER' ufname 'numBends''=' n=INT 'bendSpacing=' bd=INT 'bendLength''=' bl=INT 'channelWidth''=' cw=INT ';'
    ;
gradGenStat
    :   orientation=('V'|'H') 'GRADIENT GENERATOR' ufname in=INT 'to' out=INT 'numBends''=' n=INT 'bendSpacing''=' bd=INT 'bendLength''=' bl=INT 'channelWidth''=' cw=INT ';'
    ;
rotaryStat
    :   orientation=('V'|'H') 'ROTARY PUMP' ufname 'radius''=' r=INT 'flowChannelWidth''=' fw=INT 'controlChannelWidth''=' cw=INT ';'
    ;
dropletGenStat
    :   orientation=('V'|'H') 'DROPLET GENERATOR' 'T' ufname 'radius''=' r=INT 'oilChannelWidth''=' cw1=INT 'waterChannelWidth''=' cw2=INT ';'
    |   orientation=('V'|'H') 'DROPLET GENERATOR' 'FLOW FOCUS' ufname 'radius''=' r=INT 'oilChannelWidth''=' cw1=INT 'waterChannelWidth''=' cw2=INT 'angle''=' theta=INT 'length''=' l=INT ';'       
    ;
valve3DStat
    :   orientation=('V'|'H') '3DVALVE' ufname 'radius''=' r=INT 'gap''=' g=INT ';'
    ;
viaStat
    :   'VIA' ufnames ';'
    ;
transposerStat
    :   'TRANSPOSER' ufname 'valveRadius' '=' r=INT 'valveGap''=' g=INT 'flowChannelWidth''=' fw=INT 'controlChannelWidth''=' cw=INT ';' 
    ;

//Control Statements
valveStat
    :   'VALVE' ufname 'on' channel=ID ('w''='w=INT)? ('l' '='l=INT)?';'
    ; 

netStat
    :   'NET' ufname 'from' srcName=ID srcTerm=INT 'to' tarName=ID tarTerm=INT (',' tarName=ID tarTerm=INT)+ 'channelWidth' '=' cw=INT ';'
    ;

//Common Parser Rules

ufname
    :   ID
    ;

ufnames
    :   ufname (',' ufname)*
    ;
        

//Common Lexical Rules

ID  :	('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
    ;

INT :   [0-9]+ ; // Define token INT as one or more digits
WS  :   [ \t\r\n]+ -> skip ; // Define whitespace rule, toss it out