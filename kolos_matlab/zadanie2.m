plik = fopen('dane.txt','r');
formatSpec = '%10f';
sizeA = [1 Inf];
A = fscanf(plik,formatSpec,sizeA);
str=sprintf('%3.1f   ',A);
disp("Dane:")
disp("Ciag")
disp(str)
suma=0;
for i=1:length(A)
    if (A(i) >= -5.0)&(A(i) <= 5.0)
        suma = suma+A(i);
    end
end
disp("Wyniki:")
disp(['suma wyrazów ciągu o wartościach z przedziału <-5,5> wynosi: ',num2str(suma)])