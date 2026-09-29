%closepreview(cam);
clearvars -except wS wO data %Borrar todo expeto por los pesos
%% Modificable para Cambiar resolucion de la imagen obtenida de la cam
taFilPix=28; %Pxeles
taColuPix=28; %Pixeles 
%% Acceder a la camara  
inf=imaqhwinfo; infCam=imaqhwinfo(string(inf.InstalledAdaptors));%?	tomar infroamcion de la camara
cam=videoinput(string(inf.InstalledAdaptors)); %seleccionar camara
preview(cam) %mostrar video
sigmoide = @(v) 1./(1+exp(-v)); %Para poder hacer calculos matriciales con ella
for iter=1:10000
im=getsnapshot(cam); %tomar captura de la camara
im=PrepararImagen(im,taFilPix,taColuPix);
imshow(im)
%x=reshape(im,taFilPix*taColuPix,1); %Se tiene la entrasa de [784,1]
x=reshape(im', taFilPix*taColuPix, []);
%%---------------------------------Generalizacion
pause(.01)
        x0=[1;x]; %entrada con bias
        v0=wO'*x0; %applicacion 
        y0=tanh(v0);
        xS=[1; y0]; % salida
        vS=wS'*xS;
        yS=sigmoide(vS)';
        [~,ic]=max(yS);
        if ic==1
                disp('CERO');
            elseif ic==2
                disp('UNO');
            elseif ic==3
                disp('DOS');
            elseif ic==4
                disp('TRES');
            elseif ic==5
                disp('CUATRO');
            elseif ic==6
                disp('CINCO');
            elseif ic==7
                disp('SEIS');
            elseif ic==8
                disp('SIETE');
            elseif ic==9
                disp('OCHO');
            elseif ic==10
                disp('NUEVE');
         end          
%%---------------------------------------------------------
end



%% Funciones 
function a = PrepararImagen(imagen, tamanioColumnasEnPixeles,tamanioFilasEnPixeles)
% im=rgb2gray(imagen); %convertir a escala de grises
% im=imcomplement(im);
% im=normalize(double(im),'range'); %binarizar
img_gray = rgb2gray(imagen);
[n,m] = size(img_gray);
for i=1:n
    for j=1:m
        if img_gray(i,j)>100 
            img_gray(i,j) = 0;
        else
            img_gray(i,j) = 255;
        end
    end
end
img_gray = imresize(img_gray,[tamanioColumnasEnPixeles tamanioFilasEnPixeles]);
a = (double(img_gray)/255);
end
