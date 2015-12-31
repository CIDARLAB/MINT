    /*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

grammar ufgrammer;

netlist 
    :   importBlock?
        header 
        ufmoduleBlock?
        flowBlock 
        controlBlock? 
        EOF
    ;

importBlock
    :   importStat+
    ;

importStat
    :   'IMPORT' ufmodulename 
    ;

header  
    :   (tag='3D')? 'DEVICE' ufname  
    ;

ufmoduleBlock
    :   ufmoduleStat+
    ;

ufmoduleStat
    :   ufmodulename ufnames ';'
    ;

flowBlock 	
    :   'LAYER FLOW' (s=flowStat)+ 'END LAYER' 
    ;

flowStat 	
    :   portStat
    |   portBankStat
    |   channelStat
    |   nodeStat
    |   cellTrapStat
    |   cellTrapBankStat
    |   logicArrayStat
    |   muxStat
    |   treeStat
    |   setCoordStat
    |   mixerStat
    |   gradGenStat
    |   rotaryStat
    |   dropletGenStat
    |   valve3DStat
    |   viaStat
    |   transposerStat
    |   ufterminalStat
    ;

controlBlock
    :   'LAYER CONTROL'
        (s=controlStat)+ 
        'END LAYER'          
    ;

controlStat 
    :   portStat
    |   portBankStat
    |   channelStat
    |   nodeStat
    |   valveStat
    |   setCoordStat
    |   netStat
    |   ufmoduleStat
    |   ufterminalStat
    ;


//Flow and Control Statements

portStat
    :   'PORT' ufnames ('r''='r=INT)';'
    ;
   
portBankStat
    :   orientation='V' 'BANK' ufname 'of' number=INT 'PORT'  'r''='r=INT 'dir''='dir=('RIGHT'|'LEFT') 'spacing''='spacing=INT 'channelWidth''='channel_width=INT ';'
    |   orientation='H' 'BANK' ufname 'of' number=INT 'PORT'  'r''='r=INT 'dir''='dir=('UP'|'DOWN')  'spacing''='spacing=INT 'channelWidth''='channel_width=INT';'
    ;

portBankStatParams
    :   portBankStatParam (portBankStatParams)*
    ;

portBankStatParam
    :   'r''='r=INT
    |   'dir''='dir=('RIGHT'|'LEFT')
    |   'spacing''='spacing=INT
    |   'channelWidth''='channel_width=INT 
    ;

channelStat
    :   'CHANNEL' ufname 'from' component1=ID port1=INT 'to' component2=ID port2=INT 'w''='width=INT';'
    ;
nodeStat
    :   'NODE' ufnames ';'
    ;
cellTrapStat
    :   (type='SQUARE CELL TRAP') ufnames 'chamberWidth''='channel_width=INT 'chamberLength''='chamber_length=INT 'channelWidth''='chamber_width=INT';'
    |   orientation=('V'|'H') (type='LONG CELL TRAP') ufnames  'numChambers''='num_chambers=INT 'chamberWidth''='chamber_width=INT 'chamberLength''='chamber_length=INT  'chamberSpacing''='chamber_spacing=INT 'channelWidth''='channel_width=INT';'
    ;
cellTrapBankStat
    :   orientation=('V'|'H') 'BANK' ufname 'of' number=INT 'CELL TRAP'  'numChambers''='num_chambers=INT 'chamberWidth''='chamber_width=INT 'chamberLength''='chamber_length=INT  'chamberSpacing''='chamber_spacing=INT 'spacing''='spacing=INT 'channelWidth''='channel_width=INT';'
    ;
logicArrayStat
    :   'LOGIC ARRAY' ufname 'flowChannelWidth''=' flow_channel_width=INT 'controlChannelWidth''=' control_channel_width=INT 'chamberLength''='chamber_length=INT 'chamberWidth''='chamber_width=INT 'r''='radius=INT ';'
    ;
muxStat
    :   orientation=('V'|'H') (type='MUX') ufname n1=INT 'to' n2=INT 'spacing''='spacing=INT 'flowChannelWidth''=' flow_channel_width=INT 'controlChannelWidth''=' control_channel_width=INT ';'       
    ;
treeStat
    :   orientation=('V'|'H') (type='TREE') ufname n1=INT 'to' n2=INT 'spacing''='spacing=INT 'flowChannelWidth''='flow_channel_width=INT ';'
    ;
setCoordStat
    :   ufname ('SET X' x=INT) ('SET Y' y=INT) ';'
    ;
mixerStat
    :   orientation=('V'|'H') 'MIXER' ufname 'numBends''=' number_bends=INT 'bendSpacing''=' bend_spacing=INT 'bendLength''=' bend_length=INT 'channelWidth''=' channel_width=INT ';'
    ;
gradGenStat
    :   orientation=('V'|'H') 'GRADIENT GENERATOR' ufname in=INT 'to' out=INT 'numBends''=' number_bends=INT 'bendSpacing''=' bend_spacing=INT 'bendLength''=' bend_length=INT 'channelWidth''=' channel_width=INT ';'
    ;
rotaryStat
    :   orientation=('V'|'H') 'ROTARY PUMP' ufname 'radius''=' radius=INT 'flowChannelWidth''=' flow_channel_width=INT 'controlChannelWidth''=' control_channel_width=INT ';'
    ;
dropletGenStat
    :   orientation=('V'|'H') 'DROPLET GENERATOR' (type='T') ufname 'radius''='radius=INT 'oilChannelWidth''=' oil_channel_width=INT 'waterChannelWidth''=' water_channel_width=INT ';' 
    |   orientation=('V'|'H') 'DROPLET GENERATOR' (type='FLOW FOCUS') ufname 'radius''='radius=INT 'oilChannelWidth''=' oil_channel_width=INT 'waterChannelWidth''=' water_channel_width=INT 'angle''=' angle=INT 'length''=' length=INT ';' 
    ;
valve3DStat
    :   orientation=('V'|'H') '3DVALVE' ufname 'radius''=' radius=INT 'gap''=' gap=INT ';'
    ;
viaStat
    :   'VIA' ufnames ';'
    ;
transposerStat
    :   'TRANSPOSER' ufname 'valveRadius' '=' valve_radius=INT 'valveGap''=' valve_gap=INT 'flowChannelWidth''=' flow_channel_width=INT 'controlChannelWidth''=' control_channel_width=INT ';' 
    ;

valveStat
    :   'VALVE' ufname 'on' channel=ID ('w''='w=INT)? ('l' '='l=INT)?';'
    ; 

netStat
    :   'NET' ufname 'from' source_name=ID source_terminal=INT 'to' uftargets 'channelWidth' '=' channel_width=INT ';'
    ;

ufterminalStat
    :   'TERMINAL' ufterminal ufname ';'
    ;
//Common Parser Rules


ufmodulename
    :   ID
    ;

ufterminal
    :   INT
    ;

uftargets
    :    uftarget (',' uftarget)+
    ;

uftarget
    :   target_name=ID target_terminal=INT
    ;

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