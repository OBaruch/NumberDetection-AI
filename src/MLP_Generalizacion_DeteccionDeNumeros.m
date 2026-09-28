%data = dlmread('entrenamientoTodo.txt');
sigmoide = @(v) 1./(1+exp(-v)); %Para poder hacer calculos matriciales con ella
xd = data(40001:end,1:end-10)';%%--------------originalmente va tranpuesto
d=data(40001:end,end-9:end)';  
correctos=0;
[nP,nK]=size(xd);
for i=1:length(xd)
        x0=[1;xd(:,i)]; %entrada con bias
        v0=wO'*x0; %applicacion 
        y0=tanh(v0);
        xS=[1; y0]; % salida
        vS=wS'*xS;
        yS=sigmoide(vS)';
        [~,ic]=max(yS);
        if round(yS(:,:)') == d(:,i)
            correctos=correctos+1;
        end
        
end
porcentaje=(100*correctos)/nK;
disp('El procentaje de aciertos es:');
disp(porcentaje);