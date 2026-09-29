clearvars -except data;
close all; clc; 
%% leer muestras
data = dlmread('entrenamientoTodo.txt');
%% MLP
%% Entrenamiento 
sigmoide = @(v) 1./(1+exp(-v)); %Para poder hacer calculos matriciales con ella
xd = data(1:40000,1:end-10)';%%--------------originalmente va tranpuesto
d=data(1:40000,end-9:end)';
[nP,nK]=size(xd); %numero de entreadas y muestras _____cambie 
[nS,~]=size(d); %numero de salidas
nO=50;%nP-1%(nP+10)/2; %capa oculta ------------------------EDITABLE-------------------
eta=.2; %aprendisaje
wO=rand(nP+1,nO)*.001; %Inicialisamos pesos aleatorios de capa oculta
wS=rand(nO+1,nS)*.001; %Inicialisamos pesos aleatorios de capa de salida
eVector=[];
for i=1:300 %iteraciones del MLP
    eA=0;
    i
    for k=1:nK  %para recopilacion de datos de entreniamiento
        %% Porpagacion hacia delante
        xO=[1; xd(:,k)]; % agregamos al dato k el bias
        vO=wO'*xO;      % se calcula la salida de las neuronas de la clapa oculta 
        yO= tanh(vO);   % se calucla la funcion de activacion de las salida de la capa oculta
        xS=[1; yO];     % ahora las salida son la entrada de la capa de salida
        vS=wS'*xS;      % se calucla la salida de las neuronas  de la capa de salida
        yS=sigmoide(vS); % se calulca la funcion de activacion de la capa de salida
        e=d(:,k)-yS;    %Se calucla el error al deseado 
        eA=eA+e;
        %% Propagacion hacia atras
        deltaS=e.*(yS.*(1-yS));
        deltaO=((ones(nO,1)-yO).*(ones(nO,1)+yO)).*(wS(2:end,:)*deltaS);
        %% Reecalculo de los pesos
        wS=wS+eta*(deltaS*xS')';
        wO=wO+eta*(deltaO*xO')';
        
    end
    eVector=[eVector eA];
end
% Plotear evoluvion el error por iteracion
for sal=1:nS
figure
plot(eVector(sal,:));
str = sprintf('Erro en la salida: %d', sal-1); %MENOS UNOS SOLO EN ESTE ALGROITMO QUE  QUEREMOS VER LOS NUMEROS DEL 0 AL 9
title(str);
end

