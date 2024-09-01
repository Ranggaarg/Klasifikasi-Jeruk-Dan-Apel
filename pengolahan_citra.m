% Memanggil menu "browse file"
[nama_file, nama_folder] = uigetfile('*.jpg');

%Jika ada nama file yang dipilih maka akan mengeksekusi perintah dibawah
if ~isequal(nama_file, 0)
    % 
     % Membaca file citra rgb
    Img = imread(fullfile(nama_folder, nama_file));
  %  figure, imshow(Img)
    % Melakukan konversi citra rgb menjadi citra L*a*b
    cform = makecform('srgb2lab');
    lab = applycform(Img, cform);
 %   figure, imshow(lab)
    % Mengekstrak komponen dari citra L*a*b
    a = lab(:,:,2);
 %   figure, imshow(a)
    % Melakukan thresholding terhadap komponen a
    bw  = a > 140;
 %   figure, imshow(bw)
    % Melakukan operasi morfologi untuk menyempurnakan hasil segmentasi
    bw = imfill(bw,'holes');
 %   figure, imshow(bw)
    % Mengkonversi citra rgb menjadi citra hsv
    hsv = rgb2hsv(Img);
    % Mengekstrak komponen h dan s dari citra hsv
    h = hsv(:,:,1); %Hue
    s = hsv(:,:,2); %Saturasi
    % Mengubah nilai piksel background menjadi nol
    h(~bw) = 0;
    s(~bw) = 0;
    % Menghitung rata-rata nilai hue dan saturasi
    data_uji(1,1) = sum(sum(h))/sum(sum(bw));
    data_uji(1,2) = sum(sum(s))/sum(sum(bw));
    
% Memanggil model hasil pelatihan
load Mdl

% Membaca kelas keluaran hasil pengujian
kelas_keluaran = predict(Mdl, data_uji);

% Menampilkan citra asli dan kelas keluaran hasil pengujian
figure, imshow(Img)
title({['Nama File : ',nama_file],[kelas_keluaran{1}]})
else   
    % Jika tidak ada nama file maka akan kembali
    return
end